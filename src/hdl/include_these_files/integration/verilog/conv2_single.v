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
//第二层卷积单通道卷积
module conv2_single #(
    parameter                       INPUT_DATA_WIDTH  = 8,
    parameter                       OUTPUT_DATA_WIDTH = 24,
    parameter                       DISP_WIDTH        = 28 //输入图像像素宽高
)(
    input                           clk,
    input                           rst_n,

    input  [INPUT_DATA_WIDTH - 1:0] data_in,
    input  [1:0]                    data_in_index,  //当前卷积的特征图索引
    input                           data_in_valid,

    output signed[OUTPUT_DATA_WIDTH - 1:0]data_out_1,
    output signed[OUTPUT_DATA_WIDTH - 1:0]data_out_2,
    output signed[OUTPUT_DATA_WIDTH - 1:0]data_out_3,
    output                          data_out_valid,
    output                          conv_complete   //一次特征图卷积完成信号
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

conv2_linebuffer conv2_linebuffer_inst0(
    .clka(clk),    // input wire clka
    .ena(1'b1),      // input wire ena
    .wea(data_in_valid),      // input wire [0 : 0] wea
    .addra(wr_addr),  // input wire [4 : 0] addra
    .dina(window_in[0]),    // input wire [23 : 0] dina
    
    .clkb(clk),    // input wire clkb
    .enb(1'b1),      // input wire enb
    .addrb(rd_addr),  // input wire [4 : 0] addrb
    .doutb(window_out[0])  // output wire [23 : 0] doutb
);

conv2_linebuffer conv2_linebuffer_inst1(
    .clka(clk),    // input wire clka
    .ena(1'b1),      // input wire ena
    .wea(data_in_valid),      // input wire [0 : 0] wea
    .addra(wr_addr),  // input wire [10 : 0] addra
    .dina(window_in[1]),    // input wire [23 : 0] dina
    
    .clkb(clk),    // input wire clkb
    .enb(1'b1),      // input wire enb
    .addrb(rd_addr),  // input wire [10 : 0] addrb
    .doutb(window_out[1])  // output wire [23 : 0] doutb
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

//第二层卷积层权重 每次3个3*3卷积核
reg  signed [9:0] c2_w_1[2:0][2:0]; //权重扩大了256倍
reg  signed [9:0] c2_w_2[2:0][2:0];
reg  signed [9:0] c2_w_3[2:0][2:0];

always @(*)begin
    case(data_in_index)
        2'b00:begin
            {c2_w_1[2][2],c2_w_1[2][1],c2_w_1[2][0],
             c2_w_1[1][2],c2_w_1[1][1],c2_w_1[1][0],
             c2_w_1[0][2],c2_w_1[0][1],c2_w_1[0][0]}
            // = {10'b1110110011,10'b1110101000,10'b0000001000,
            //    10'b0000000001,10'b0000110100,10'b1011111000,
            //    10'b0001110100,10'b0010101111,10'b0001010111};
            ={10'd37,10'd140,10'd59,
            -10'd56,-10'd28,-10'd68,
            10'd110,-10'd10,10'd132};
            {c2_w_2[2][2],c2_w_2[2][1],c2_w_2[2][0],
             c2_w_2[1][2],c2_w_2[1][1],c2_w_2[1][0],
             c2_w_2[0][2],c2_w_2[0][1],c2_w_2[0][0]}
            // = {10'b0000111101,10'b1101011111,10'b1110101001,
            //    10'b0000101010,10'b1101110100,10'b1110011001,
            //    10'b0000000100,10'b1111111010,10'b1101110101};
            ={10'd54,10'd69,-10'd5,
            10'd17,10'd31,10'd144,
            -10'd44,-10'd69,-10'd38};
            {c2_w_3[2][2],c2_w_3[2][1],c2_w_3[2][0],
             c2_w_3[1][2],c2_w_3[1][1],c2_w_3[1][0],
             c2_w_3[0][2],c2_w_3[0][1],c2_w_3[0][0]}
            //  = {10'b0000111010,10'b1101011111,10'b1111011101,
            //     10'b1111010010,10'b1111111011,10'b0001000100,
            //     10'b1111000110,10'b0000010010,10'b0010001010};
            ={10'd97,10'd142,-10'd16,
            10'd4,10'd50,-10'd10,
            -10'd84,10'd73,10'd17};
        end
        2'b01:begin
            {c2_w_1[2][2],c2_w_1[2][1],c2_w_1[2][0],
             c2_w_1[1][2],c2_w_1[1][1],c2_w_1[1][0],
             c2_w_1[0][2],c2_w_1[0][1],c2_w_1[0][0]}
            // = {10'b0010011110,10'b0000001010,10'b0000111100,
            //    10'b0010010101,10'b0010100001,10'b0010101101,
            //    10'b0011001010,10'b0011011011,10'b0100000110};
            ={10'd83,10'd53,10'd3,
            -10'd116,10'd37,-10'd10,
            10'd30,-10'd84,10'd15};
            {c2_w_2[2][2],c2_w_2[2][1],c2_w_2[2][0],
             c2_w_2[1][2],c2_w_2[1][1],c2_w_2[1][0],
             c2_w_2[0][2],c2_w_2[0][1],c2_w_2[0][0]}
            // = {10'b0010111101,10'b0010101001,10'b0000111000,
            //    10'b0001100000,10'b1111011111,10'b0001011100,
            //    10'b1111000101,10'b0000010011,10'b0000001101};
            ={-10'd86,10'd28,-10'd72,
            10'd101,-10'd144,-10'd121,
            -10'd54,10'd88,-10'd15};
            {c2_w_3[2][2],c2_w_3[2][1],c2_w_3[2][0],
             c2_w_3[1][2],c2_w_3[1][1],c2_w_3[1][0],
             c2_w_3[0][2],c2_w_3[0][1],c2_w_3[0][0]}
            // = {10'b1101110111,10'b1111011100,10'b0001100111,
            //    10'b1111010111,10'b0000011010,10'b0001101001,
            //    10'b0010111011,10'b0001100001,10'b1111011000};
            ={-10'd1,10'd138,-10'd134,
            -10'd17,-10'd154,10'd19,
            10'd61,10'd52,-10'd96};
        end
        2'b10:begin
            {c2_w_1[2][2],c2_w_1[2][1],c2_w_1[2][0],
             c2_w_1[1][2],c2_w_1[1][1],c2_w_1[1][0],
             c2_w_1[0][2],c2_w_1[0][1],c2_w_1[0][0]}
            // = {10'b1111001111,10'b0000111110,10'b0000010000,
            //    10'b0000010111,10'b1111101001,10'b1110001111,
            //    10'b1101100110,10'b1110000001,10'b1111111111};
            ={-10'd125,10'd63,-10'd42,
            -10'd26,-10'd32,10'd85,
            10'd35,10'd84,10'd64};
            {c2_w_2[2][2],c2_w_2[2][1],c2_w_2[2][0],
             c2_w_2[1][2],c2_w_2[1][1],c2_w_2[1][0],
             c2_w_2[0][2],c2_w_2[0][1],c2_w_2[0][0]}
            // = {10'b0000101011,10'b0001110101,10'b0011010110,
            //    10'b0000001001,10'b0001010101,10'b0010001010,
            //    10'b0000110111,10'b0001110010,10'b0011111010};
            ={-10'd1,10'd138,10'd29,
            -10'd58,10'd43,-10'd26,
            10'd54,10'd63,10'd9};
            {c2_w_3[2][2],c2_w_3[2][1],c2_w_3[2][0],
             c2_w_3[1][2],c2_w_3[1][1],c2_w_3[1][0],
             c2_w_3[0][2],c2_w_3[0][1],c2_w_3[0][0]}
            // = {10'b0001011100,10'b0010100110,10'b0010000100,
            //    10'b0001101000,10'b0001110010,10'b1111001001,
            //    10'b0001010100,10'b0001111110,10'b1111010111};
            ={10'd113,10'd59,-10'd80,
            -10'd7,10'd34,-10'd51,
            -10'd98,10'd30,10'd114};
        end
        default:;
    endcase
end

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
                window_mul_result_1[i][j] <= {{(OUTPUT_DATA_WIDTH-INPUT_DATA_WIDTH){1'b0}},window[i][j]}*{{(OUTPUT_DATA_WIDTH-10){c2_w_1[i][j][9]}},c2_w_1[i][j]}; 
                window_mul_result_2[i][j] <= {{(OUTPUT_DATA_WIDTH-INPUT_DATA_WIDTH){1'b0}},window[i][j]}*{{(OUTPUT_DATA_WIDTH-10){c2_w_2[i][j][9]}},c2_w_2[i][j]}; 
                window_mul_result_3[i][j] <= {{(OUTPUT_DATA_WIDTH-INPUT_DATA_WIDTH){1'b0}},window[i][j]}*{{(OUTPUT_DATA_WIDTH-10){c2_w_3[i][j][9]}},c2_w_3[i][j]}; 
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
        window_sum_1 <= window_sum_1_line1 + window_sum_1_line2 + window_sum_1_line3;
        window_sum_2 <= window_sum_2_line1 + window_sum_2_line2 + window_sum_2_line3;
        window_sum_3 <= window_sum_3_line1 + window_sum_3_line2 + window_sum_3_line3;
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

wire data_out_valid_o;
reg  [3:0]data_out_valid_temp;

//这里卷积后的输出原来是11*11,为方便后面进行池化,直接舍去每行最后一个与最后一行
assign data_out_valid_o = (x_cnt >= 2 && y_cnt >= 2 && x_cnt != 12 && y_cnt != 12) ? 1'b1:1'b0;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        data_out_valid_temp <= 'd0;
    else
        data_out_valid_temp <= {data_out_valid_temp[2:0],data_out_valid_o};
end

assign data_out_valid = data_out_valid_temp[3];

//第一层卷积结果进行RELU输出
assign data_out_1 = window_sum_1;
assign data_out_2 = window_sum_2;
assign data_out_3 = window_sum_3;

//产生一次卷积完成信号
wire conv_end;
reg  [3:0] conv_end_temp;   

assign conv_end = (y_cnt == 12 && x_cnt == 12) ? 1'b1 : 1'b0;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        conv_end_temp <= 4'b0;
    else 
        conv_end_temp <= {conv_end_temp[2:0],conv_end};
end

assign conv_complete = conv_end_temp[3];

endmodule
