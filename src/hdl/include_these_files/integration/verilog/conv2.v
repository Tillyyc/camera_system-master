`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 江城白羊生姜座
// 
// Create Date: 2023/12/30 16:11:31
// Design Name: 
// Module Name: conv2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
/*
卷积过程: 第二层输入为三通道,权重为9个3*3卷积核
每次使用3个卷积核与输入的三通道卷积再累加成一张特征图输出
总共输出3张11*11特征图像,卷积采用全并行
*/
module conv2 #(
    parameter           INPUT_DATA_WIDTH  = 24,
    parameter           OUTPUT_DATA_WIDTH = 32
)(
    input               clk,
    input               rst_n,
    input               predict_end,

    input  [INPUT_DATA_WIDTH - 1:0]       data_in_1,  //输入13*13
    input  [INPUT_DATA_WIDTH - 1:0]       data_in_2,
    input  [INPUT_DATA_WIDTH - 1:0]       data_in_3,
    input               data_in_valid,

    output [OUTPUT_DATA_WIDTH - 1:0]       data_out_1,
    output [OUTPUT_DATA_WIDTH - 1:0]       data_out_2,
    output [OUTPUT_DATA_WIDTH - 1:0]       data_out_3,
    output reg          data_out_valid
    );

//第二层卷积偏置
wire signed [OUTPUT_DATA_WIDTH - 1:0] c2_b[2:0];
// assign {c2_b[0],c2_b[1],c2_b[2]} = {-32'd5376,32'd12544,32'd13824}; //第二层卷积偏置需要乘以65536倍
assign {c2_b[0],c2_b[1],c2_b[2]} = {-32'd3,32'd58,32'd19}; //第二层卷积偏置需要乘以65536倍

//输入的第二、三张特征图像缓存
//这里使用串行结构,每次一张特征图与3个3*3卷积核进行卷积
wire [INPUT_DATA_WIDTH - 1:0] fifo_data_1;
wire [INPUT_DATA_WIDTH - 1:0] fifo_data_2;
wire [INPUT_DATA_WIDTH - 1:0] fifo_data_3;

reg  data_in_1_rd_en;  //第一张特征图读取
reg  data_in_2_rd_en;
reg  data_in_3_rd_en;
reg  [7:0] data_rd_cnt;   //从fifo中读出量

reg  [INPUT_DATA_WIDTH - 1:0] conv2_data;
reg  [1:0]  conv2_index;
reg         conv2_data_valid;
wire        conv2_data_complete;
reg  [1:0]  current_conv; //当前卷积的特征图 

fifo_data_buffer fifo_data_buffer_inst0 (
    .clk      (clk),      // input wire clk
    .srst     (predict_end),    // input wire srst
    .din      (data_in_1),      // input wire [23 : 0] din
    .wr_en    (data_in_valid),  // input wire wr_en
    .rd_en    (data_in_1_rd_en),  // input wire rd_en
    .dout     (fifo_data_1),    // output wire [23 : 0] dout
    .full     (),    // output wire full
    .empty    ()  // output wire empty
);

fifo_data_buffer fifo_data_buffer_inst1 (
    .clk      (clk),      // input wire clk
    .srst     (predict_end),
    .din      (data_in_2),      // input wire [23 : 0] din
    .wr_en    (data_in_valid),  // input wire wr_en
    .rd_en    (data_in_2_rd_en),  // input wire rd_en
    .dout     (fifo_data_2),    // output wire [23 : 0] dout
    .full     (),    // output wire full
    .empty    ()  // output wire empty
);

fifo_data_buffer fifo_data_buffer_inst2 (
    .clk      (clk),      // input wire clk
    .srst     (predict_end),
    .din      (data_in_3),      // input wire [23 : 0] din
    .wr_en    (data_in_valid),  // input wire wr_en
    .rd_en    (data_in_3_rd_en),  // input wire rd_en
    .dout     (fifo_data_3),    // output wire [23 : 0] dout
    .full     (),    // output wire full
    .empty    ()  // output wire empty
);

//写入fifo计数器
reg  [7:0] fifo_data_cnt;   //写入13*13=168个数据

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        fifo_data_cnt <= 8'd0;
    else if(fifo_data_cnt == 13*13-1 && data_in_valid)
        fifo_data_cnt <= 8'd0;
    else if(data_in_valid)
        fifo_data_cnt <= fifo_data_cnt + 1'b1;
    else
        fifo_data_cnt <= fifo_data_cnt;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        data_in_1_rd_en <= 1'b0;
        data_in_2_rd_en <= 1'b0;
        data_in_3_rd_en <= 1'b0;
    end
    else if(data_rd_cnt == 13*13 - 1)begin
        data_in_1_rd_en <= 1'b0;
        data_in_2_rd_en <= 1'b0;
        data_in_3_rd_en <= 1'b0;
    end
    else if(fifo_data_cnt == 13*13 - 1) //第一张特征图全部写入fifo,开始读出进行卷积
        data_in_1_rd_en <= 1'b1;
    else if(conv2_data_complete && current_conv == 0)
        data_in_2_rd_en <= 1'b1;
    else if(conv2_data_complete && current_conv == 1)
        data_in_3_rd_en <= 1'b1;
    else begin
        data_in_1_rd_en <= data_in_1_rd_en;
        data_in_2_rd_en <= data_in_2_rd_en;
        data_in_3_rd_en <= data_in_3_rd_en;
    end
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        data_rd_cnt <= 8'd0;
    else if(data_rd_cnt == 13*13 - 1)
        data_rd_cnt <= 8'd0;
    else if(data_in_1_rd_en || data_in_2_rd_en || data_in_3_rd_en)
        data_rd_cnt <= data_rd_cnt + 1'b1;
    else 
        data_rd_cnt <= data_rd_cnt;
end

//串行卷积输入控制
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        current_conv <= 'd0;
    else if(current_conv == 2 && conv2_data_complete)   
        current_conv <= 'd0;
    else if(conv2_data_complete)    //完成一张特征图卷积,接着下一张
        current_conv <= current_conv + 1'b1;
    else
        current_conv <= current_conv;
end

//数据有效信号延迟一个时钟
reg  data_in_1_rd_en_d1;
reg  data_in_2_rd_en_d1;
reg  data_in_3_rd_en_d1;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        data_in_1_rd_en_d1 <= 'd0;
        data_in_2_rd_en_d1 <= 'd0;
        data_in_3_rd_en_d1 <= 'd0;
    end
    else begin
        data_in_1_rd_en_d1 <= data_in_1_rd_en;
        data_in_2_rd_en_d1 <= data_in_2_rd_en;
        data_in_3_rd_en_d1 <= data_in_3_rd_en;
    end
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        conv2_data       <= 'd0;
        conv2_index      <= 'd0;
        conv2_data_valid <= 'd0; 
    end
    else if(current_conv == 0)begin
        conv2_data       <= fifo_data_1;
        conv2_index      <= 2'b00;
        conv2_data_valid <= data_in_1_rd_en_d1; 
    end
    else if(current_conv == 1)begin
        conv2_data       <= fifo_data_2;
        conv2_index      <= 2'b01;
        conv2_data_valid <= data_in_2_rd_en_d1; 
    end
    else if(current_conv == 2)begin
        conv2_data       <= fifo_data_3;
        conv2_index      <= 2'b10;
        conv2_data_valid <= data_in_3_rd_en_d1; 
    end
    else begin
        conv2_data       <= conv2_data      ;
        conv2_index      <= conv2_index     ;
        conv2_data_valid <= conv2_data_valid;
    end
end

wire [OUTPUT_DATA_WIDTH - 1:0] conv2_data_1_out;
wire [OUTPUT_DATA_WIDTH - 1:0] conv2_data_2_out;
wire [OUTPUT_DATA_WIDTH - 1:0] conv2_data_3_out;
wire        conv2_data_out_valid;

conv2_single #(
    .INPUT_DATA_WIDTH   (24                 ),
    .OUTPUT_DATA_WIDTH  (32                 ),
    .DISP_WIDTH         (13                 ) //输入图像像素宽高
)conv2_single_inst0(
    .clk                (clk                ),
    .rst_n              (rst_n              ),

    .data_in            (conv2_data         ),
    .data_in_index      (conv2_index        ),  //当前卷积的特征图索引
    .data_in_valid      (conv2_data_valid   ),

    .data_out_1         (conv2_data_1_out   ),
    .data_out_2         (conv2_data_2_out   ),
    .data_out_3         (conv2_data_3_out   ),
    .conv_complete      (conv2_data_complete),  //一次卷积完成信号
    .data_out_valid     (conv2_data_out_valid)
    );

//缓存第一、第二张特征图卷积结果
wire [OUTPUT_DATA_WIDTH*3-1:0] conv2_data_1_result;
wire [OUTPUT_DATA_WIDTH*3-1:0] conv2_data_2_result;

fifo_conv2_result fifo_conv2_result_inst0 (
  .clk          (clk),      // input wire clk
  .srst         (predict_end),
  .din          ({conv2_data_3_out,conv2_data_2_out,conv2_data_1_out}),      // input wire [95 : 0] din
  .wr_en        ((conv2_data_out_valid && current_conv == 0)),  // input wire wr_en
  .rd_en        ((conv2_data_out_valid && current_conv == 2)),  // input wire rd_en
  .dout         (conv2_data_1_result),    // output wire [31 : 0] dout
  .full         (),    // output wire full
  .empty        ()  // output wire empty
);

fifo_conv2_result fifo_conv2_result_inst1 (
  .clk          (clk),      // input wire clk
  .srst         (predict_end),
  .din          ({conv2_data_3_out,conv2_data_2_out,conv2_data_1_out}),      // input wire [31 : 0] din
  .wr_en        ((conv2_data_out_valid && current_conv == 1)),  // input wire wr_en
  .rd_en        ((conv2_data_out_valid && current_conv == 2)),  // input wire rd_en
  .dout         (conv2_data_2_result),    // output wire [31 : 0] dout
  .full         (),    // output wire full
  .empty        ()  // output wire empty
);

//卷积后的结果累加
reg  signed [OUTPUT_DATA_WIDTH-1:0] conv2_result_1;
reg  signed [OUTPUT_DATA_WIDTH-1:0] conv2_result_2;
reg  signed [OUTPUT_DATA_WIDTH-1:0] conv2_result_3;
wire               conv2_result_valid;

wire signed [31:0] conv2_out_31;
wire signed [31:0] conv2_out_32;
wire signed [31:0] conv2_out_33;
assign conv2_out_31 = conv2_data_1_out; //当前第三张特征图像卷积结果
assign conv2_out_32 = conv2_data_2_out; 
assign conv2_out_33 = conv2_data_3_out; 

wire signed [31:0] conv2_out_21;
wire signed [31:0] conv2_out_22;
wire signed [31:0] conv2_out_23;
assign conv2_out_21 = conv2_data_2_result[31: 0]; //第二张特征图像卷积结果
assign conv2_out_22 = conv2_data_2_result[63:32]; 
assign conv2_out_23 = conv2_data_2_result[95:64]; 

wire signed [31:0] conv2_out_11;
wire signed [31:0] conv2_out_12;
wire signed [31:0] conv2_out_13;
assign conv2_out_11 = conv2_data_1_result[31: 0]; //第一张特征图像卷积结果
assign conv2_out_12 = conv2_data_1_result[63:32]; 
assign conv2_out_13 = conv2_data_1_result[95:64]; 

assign conv2_result_valid = (conv2_data_out_valid && current_conv == 2);    //最后一张特征图卷积完才输出结果

reg  signed [31:0] conv2_out_31_d1; //fifo读出需要一个周期,第三张特征图输出延迟一拍同步
reg  signed [31:0] conv2_out_32_d1;
reg  signed [31:0] conv2_out_33_d1;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        conv2_out_31_d1 <= 'd0;
        conv2_out_32_d1 <= 'd0;
        conv2_out_33_d1 <= 'd0;
    end
    else begin
        conv2_out_31_d1 <= conv2_out_31;
        conv2_out_32_d1 <= conv2_out_32;
        conv2_out_33_d1 <= conv2_out_33;
    end
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        conv2_result_1 <= 'd0;
        conv2_result_2 <= 'd0;
        conv2_result_3 <= 'd0;
    end
    else begin
        conv2_result_1 <= conv2_out_11 + conv2_out_21 + conv2_out_31_d1 + -131072;
        conv2_result_2 <= conv2_out_12 + conv2_out_22 + conv2_out_32_d1 + -524288;
        conv2_result_3 <= conv2_out_13 + conv2_out_23 + conv2_out_33_d1 + -196608;
        // conv2_result_1 <= conv2_data_1_out + conv2_data_1_result[OUTPUT_DATA_WIDTH*1-1:OUTPUT_DATA_WIDTH*0] + conv2_data_2_result[OUTPUT_DATA_WIDTH*1-1:OUTPUT_DATA_WIDTH*0] + c2_b[0];
        // conv2_result_2 <= conv2_data_2_out + conv2_data_1_result[OUTPUT_DATA_WIDTH*2-1:OUTPUT_DATA_WIDTH*1] + conv2_data_2_result[OUTPUT_DATA_WIDTH*2-1:OUTPUT_DATA_WIDTH*1] + c2_b[1];
        // conv2_result_3 <= conv2_data_3_out + conv2_data_1_result[OUTPUT_DATA_WIDTH*3-1:OUTPUT_DATA_WIDTH*2] + conv2_data_2_result[OUTPUT_DATA_WIDTH*3-1:OUTPUT_DATA_WIDTH*2] + c2_b[2];
    end
end

reg  conv2_result_valid_d1;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        data_out_valid <= 1'b0;
        conv2_result_valid_d1 <= 1'b0;
    end
    else begin
        data_out_valid <= conv2_result_valid_d1;
        conv2_result_valid_d1 <= conv2_result_valid;
    end
end

//RELU激活输出
assign data_out_1 = conv2_result_1[OUTPUT_DATA_WIDTH-1] == 0 ? conv2_result_1: 0;
assign data_out_2 = conv2_result_2[OUTPUT_DATA_WIDTH-1] == 0 ? conv2_result_2: 0;
assign data_out_3 = conv2_result_3[OUTPUT_DATA_WIDTH-1] == 0 ? conv2_result_3: 0;

endmodule
