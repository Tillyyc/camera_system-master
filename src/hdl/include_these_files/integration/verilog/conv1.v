`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 江城白羊生姜座
// 
// Create Date: 2023/12/29 23:59:44
// Design Name: 
// Module Name: conv1
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
//第一层卷积
module conv1 #(
    parameter                       INPUT_DATA_WIDTH  = 8,
    parameter                       OUTPUT_DATA_WIDTH = 24,
    parameter                       DISP_WIDTH        = 28 //输入图像像素宽高
)(
    input                           clk,
    input                           rst_n,

    input  [INPUT_DATA_WIDTH - 1:0] data_in,
    input                           data_in_valid,

    output [OUTPUT_DATA_WIDTH - 1:0]data_out_1,
    output [OUTPUT_DATA_WIDTH - 1:0]data_out_2,
    output [OUTPUT_DATA_WIDTH - 1:0]data_out_3,
    output                          data_out_valid
    );

//-------------wr_addr rd_addr--------------
reg  [4:0] wr_addr;
reg  [4:0] rd_addr;
wire [4:0] rd_addr_pre2;

//wr_addr rd_addr
assign rd_addr_pre2 = wr_addr + 5'd2;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        wr_addr <= 5'd0;
        rd_addr <= 5'd0;
    end
    else if(data_in_valid)begin
        //-----------wr_addr----------
        if(wr_addr == DISP_WIDTH - 1)
            wr_addr <= 5'd0;
        else
            wr_addr <= wr_addr + 1'b1;
        //-----------rd_addr----------
        if(rd_addr_pre2 > DISP_WIDTH - 1)
            rd_addr <= rd_addr_pre2 - DISP_WIDTH;
        else
            rd_addr <= rd_addr_pre2;
    end
    else begin
        wr_addr <= wr_addr;
        rd_addr <= rd_addr;
    end
end

//------------------linebuffer inst---------------------
wire [INPUT_DATA_WIDTH - 1:0] window_in [0:1]; //RAM输入数据
wire [INPUT_DATA_WIDTH - 1:0] window_out[0:1]; //RAM输出数据

linebuffer linebuffer_gaussian_layer2_inst0(
    .clka(clk),    // input wire clka
    .ena(1'b1),      // input wire ena
    .wea(data_in_valid),      // input wire [0 : 0] wea
    .addra(wr_addr),  // input wire [4 : 0] addra
    .dina(window_in[0]),    // input wire [7 : 0] dina
    
    .clkb(clk),    // input wire clkb
    .enb(1'b1),      // input wire enb
    .addrb(rd_addr),  // input wire [4 : 0] addrb
    .doutb(window_out[0])  // output wire [7 : 0] doutb
);

linebuffer linebuffer_gaussian_layer2_inst1(
    .clka(clk),    // input wire clka
    .ena(1'b1),      // input wire ena
    .wea(data_in_valid),      // input wire [0 : 0] wea
    .addra(wr_addr),  // input wire [10 : 0] addra
    .dina(window_in[1]),    // input wire [7 : 0] dina
    
    .clkb(clk),    // input wire clkb
    .enb(1'b1),      // input wire enb
    .addrb(rd_addr),  // input wire [10 : 0] addrb
    .doutb(window_out[1])  // output wire [7 : 0] doutb
);

assign window_in[0] = data_in;     //输入图像直接作为第一行
assign window_in[1] = window_out[0]; //第一行的输出作为第二行的输入

//---------------take window---------------
reg  [INPUT_DATA_WIDTH - 1:0] window[2:0][2:0]; //3*3图像窗口
integer i,j;

//矩阵第一行赋值
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        for(i=0;i<3;i=i+1)begin
            window[0][i] <= 'd0;
        end
    end 
    else begin
        window[0][0] <= window_in[0];
        for(i=1;i<3;i=i+1)begin
            window[0][i] <= window[0][i-1];
        end
    end
end

//矩阵第二行赋值
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        for(i=0;i<3;i=i+1)begin
            window[1][i] <= 'd0;
        end
    end 
    else begin
        window[1][0] <= window_in[1];
        for(i=1;i<3;i=i+1)begin
            window[1][i] <= window[1][i-1];
        end
    end
end

//矩阵第三行赋值
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        for(i=0;i<3;i=i+1)begin
            window[2][i] <= 'd0;
        end
    end 
    else begin
        window[2][0] <= window_out[1];
        for(i=1;i<3;i=i+1)begin
            window[2][i] <= window[2][i-1];
        end
    end
end

//第一次卷积层权重 3个3*3卷积核
wire signed [9:0] c1_w_1[2:0][2:0]; //权重扩大了256倍
wire signed [9:0] c1_w_2[2:0][2:0];
wire signed [9:0] c1_w_3[2:0][2:0];
wire signed [9:0] c1_b[2:0];    //第一层卷积偏置
// assign {c1_b[0],c1_b[1],c1_b[2]} = {10'b0000001011,10'b0010010011,10'b0001100011};
assign {c1_b[0],c1_b[1],c1_b[2]} = {10'd48,10'd93,10'd19};

assign {c1_w_1[2][2],c1_w_1[2][1],c1_w_1[2][0],
        c1_w_1[1][2],c1_w_1[1][1],c1_w_1[1][0],
        c1_w_1[0][2],c1_w_1[0][1],c1_w_1[0][0]}
// = {10'b0000111101,10'b0010101100,10'b0000111111,
//    10'b1101110110,10'b1111110111,10'b1110000110,
//    10'b1101100111,10'b1100010011,10'b1100111001;}
        ={10'd107,10'd43,10'd152,
        -10'd141,-10'd91,10'd122,
        10'd21,-10'd93,-10'd138};
assign {c1_w_2[2][2],c1_w_2[2][1],c1_w_2[2][0],
        c1_w_2[1][2],c1_w_2[1][1],c1_w_2[1][0],
        c1_w_2[0][2],c1_w_2[0][1],c1_w_2[0][0]}
// = {10'b0010100111,10'b0100000111,10'b0010110100,
//    10'b1111001111,10'b1111010001,10'b0010110000,
//    10'b1101001000,10'b1110010101,10'b1110111001};
        ={10'd41,10'd36,-10'd93,
        -10'd17,-10'd87,10'd88,
        10'd1,-10'd126,10'd15};
assign {c1_w_3[2][2],c1_w_3[2][1],c1_w_3[2][0],
        c1_w_3[1][2],c1_w_3[1][1],c1_w_3[1][0],
        c1_w_3[0][2],c1_w_3[0][1],c1_w_3[0][0]}
// = {10'b1101100100,10'b0000110110,10'b0001101000,
//    10'b1110010010,10'b1111101101,10'b0001100111,
//    10'b1101101000,10'b0001111001,10'b0011001010};
        ={-10'd84,-10'd102,-10'd48,
        10'd40,-10'd43,10'd49,
        10'd55,-10'd130,-10'd60};

//-----------------------------------------------
//卷积
reg  signed [OUTPUT_DATA_WIDTH - 1:0] window_mul_result_1[2:0][2:0];
reg  signed [OUTPUT_DATA_WIDTH - 1:0] window_mul_result_2[2:0][2:0];
reg  signed [OUTPUT_DATA_WIDTH - 1:0] window_mul_result_3[2:0][2:0];

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        for(i=0;i<3;i=i+1)begin
            for(j=0;j<3;j=j+1)begin
                window_mul_result_1[i][j] <= 'd0;
                window_mul_result_2[i][j] <= 'd0;
                window_mul_result_3[i][j] <= 'd0;
            end
        end
    end
    else begin //参数窗口与缓存图像数据窗口相乘
        for(i=0;i<3;i=i+1)begin
            for(j=0;j<3;j=j+1)begin           //window与c1_w前面补零扩展为输出位，防止计算过程中有符号数变成无符号数
                window_mul_result_1[i][j] <= {{(OUTPUT_DATA_WIDTH-INPUT_DATA_WIDTH){1'b0}},window[i][j]}*{{(OUTPUT_DATA_WIDTH-10){c1_w_1[i][j][9]}},c1_w_1[i][j]}; 
                window_mul_result_2[i][j] <= {{(OUTPUT_DATA_WIDTH-INPUT_DATA_WIDTH){1'b0}},window[i][j]}*{{(OUTPUT_DATA_WIDTH-10){c1_w_2[i][j][9]}},c1_w_2[i][j]}; 
                window_mul_result_3[i][j] <= {{(OUTPUT_DATA_WIDTH-INPUT_DATA_WIDTH){1'b0}},window[i][j]}*{{(OUTPUT_DATA_WIDTH-10){c1_w_3[i][j][9]}},c1_w_3[i][j]}; 
            end                                                                                              
        end
    end
end

//卷积后窗口每行累加
reg  [OUTPUT_DATA_WIDTH - 1:0] window_sum_1_line1;
reg  [OUTPUT_DATA_WIDTH - 1:0] window_sum_1_line2;
reg  [OUTPUT_DATA_WIDTH - 1:0] window_sum_1_line3;
reg  [OUTPUT_DATA_WIDTH - 1:0] window_sum_2_line1;
reg  [OUTPUT_DATA_WIDTH - 1:0] window_sum_2_line2;
reg  [OUTPUT_DATA_WIDTH - 1:0] window_sum_2_line3;
reg  [OUTPUT_DATA_WIDTH - 1:0] window_sum_3_line1;
reg  [OUTPUT_DATA_WIDTH - 1:0] window_sum_3_line2;
reg  [OUTPUT_DATA_WIDTH - 1:0] window_sum_3_line3;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        window_sum_1_line1 <= 'd0;
        window_sum_1_line2 <= 'd0;
        window_sum_1_line3 <= 'd0;
        window_sum_2_line1 <= 'd0;
        window_sum_2_line2 <= 'd0;
        window_sum_2_line3 <= 'd0;
        window_sum_3_line1 <= 'd0;
        window_sum_3_line2 <= 'd0;
        window_sum_3_line3 <= 'd0;
    end
    else begin
        window_sum_1_line1 <= window_mul_result_1[0][0] + window_mul_result_1[0][1] + window_mul_result_1[0][2];
        window_sum_1_line2 <= window_mul_result_1[1][0] + window_mul_result_1[1][1] + window_mul_result_1[1][2];
        window_sum_1_line3 <= window_mul_result_1[2][0] + window_mul_result_1[2][1] + window_mul_result_1[2][2];
        window_sum_2_line1 <= window_mul_result_2[0][0] + window_mul_result_2[0][1] + window_mul_result_2[0][2];
        window_sum_2_line2 <= window_mul_result_2[1][0] + window_mul_result_2[1][1] + window_mul_result_2[1][2];
        window_sum_2_line3 <= window_mul_result_2[2][0] + window_mul_result_2[2][1] + window_mul_result_2[2][2];
        window_sum_3_line1 <= window_mul_result_3[0][0] + window_mul_result_3[0][1] + window_mul_result_3[0][2];
        window_sum_3_line2 <= window_mul_result_3[1][0] + window_mul_result_3[1][1] + window_mul_result_3[1][2];
        window_sum_3_line3 <= window_mul_result_3[2][0] + window_mul_result_3[2][1] + window_mul_result_3[2][2];
    end
end

//窗口9个数累加结果
reg  signed [OUTPUT_DATA_WIDTH - 1:0] window_sum_1;
reg  signed [OUTPUT_DATA_WIDTH - 1:0] window_sum_2;
reg  signed [OUTPUT_DATA_WIDTH - 1:0] window_sum_3;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        window_sum_1 <= 'd0;
        window_sum_2 <= 'd0;
        window_sum_3 <= 'd0;
    end
    else begin
        window_sum_1 <= window_sum_1_line1 + window_sum_1_line2 + window_sum_1_line3 + 10'd23;
        window_sum_2 <= window_sum_2_line1 + window_sum_2_line2 + window_sum_2_line3 + -10'd15;
        window_sum_3 <= window_sum_3_line1 + window_sum_3_line2 + window_sum_3_line3 + -10'd0;
    end
end

// wire signed [OUTPUT_DATA_WIDTH - 1:0] window_sum_1;
// wire signed [OUTPUT_DATA_WIDTH - 1:0] window_sum_2;
// wire signed [OUTPUT_DATA_WIDTH - 1:0] window_sum_3;

// assign window_sum_1 = c1_b[0] + window_mul_result_1[0][0] + window_mul_result_1[0][1] + window_mul_result_1[0][2]
//                               + window_mul_result_1[1][0] + window_mul_result_1[1][1] + window_mul_result_1[1][2]
//                               + window_mul_result_1[2][0] + window_mul_result_1[2][1] + window_mul_result_1[2][2];
// assign window_sum_2 = c1_b[1] + window_mul_result_2[0][0] + window_mul_result_2[0][1] + window_mul_result_2[0][2]
//                               + window_mul_result_2[1][0] + window_mul_result_2[1][1] + window_mul_result_2[1][2]
//                               + window_mul_result_2[2][0] + window_mul_result_2[2][1] + window_mul_result_2[2][2];
// assign window_sum_3 = c1_b[2] + window_mul_result_3[0][0] + window_mul_result_3[0][1] + window_mul_result_3[0][2]
//                               + window_mul_result_3[1][0] + window_mul_result_3[1][1] + window_mul_result_3[1][2]
//                               + window_mul_result_3[2][0] + window_mul_result_3[2][1] + window_mul_result_3[2][2];

//卷积后图像由28*28-->26*26 延迟二行加2个像素才开始有效
reg [4:0] x_cnt;
reg [4:0] y_cnt;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        x_cnt <= 0;
    else if(x_cnt == DISP_WIDTH - 1 && data_in_valid)
        x_cnt <= 0;
    else if(data_in_valid)
        x_cnt <= x_cnt + 1'b1;
    else
        x_cnt <= x_cnt;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        y_cnt <= 0;
    else if(x_cnt == DISP_WIDTH - 1 && y_cnt == DISP_WIDTH - 1 && data_in_valid)
        y_cnt <= 0;
    else if(data_in_valid && x_cnt == DISP_WIDTH - 1)
        y_cnt <= y_cnt + 1'b1;
    else
        y_cnt <= y_cnt;
end

wire data_out_valid_o = (x_cnt >= 2 && y_cnt >= 2) ? 1'b1:1'b0;
reg  [3:0]data_out_valid_temp;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        data_out_valid_temp <= 'd0;
    else
        data_out_valid_temp <= {data_out_valid_temp[2:0],data_out_valid_o};
end

assign data_out_valid = data_out_valid_temp[3];

//第一层卷积结果进行RELU输出
assign data_out_1 = window_sum_1[OUTPUT_DATA_WIDTH - 1] == 0 ? window_sum_1: 0;
assign data_out_2 = window_sum_2[OUTPUT_DATA_WIDTH - 1] == 0 ? window_sum_2: 0;
assign data_out_3 = window_sum_3[OUTPUT_DATA_WIDTH - 1] == 0 ? window_sum_3: 0;

endmodule
