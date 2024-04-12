`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 江城白羊生姜座
// 
// Create Date: 2024/01/01 14:00:49
// Design Name: 
// Module Name: linear
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
//全连接层
module linear #(
    parameter                   DATA_WIDTH = 16
)(
    input                       clk,
    input                       rst_n,

    input  [DATA_WIDTH - 1:0]   data_in,
    input                       data_in_valid,

    output [DATA_WIDTH*2*3-1:0]data_out,
    output                      data_out_valid
    );

//全连接层偏置
// wire signed [31:0] f_b[9:0];
// assign {f_b[]}

//data_in打一拍，延时一个周期读出（与weight相乘）
reg [DATA_WIDTH - 1:0] data_in_delay;
reg data_in_valid_delay1; //mul_result延时信号
reg data_in_valid_delay2; //sum_result延时信号

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        data_in_delay <= 0;
        data_in_valid_delay1 <= 0;
        data_in_valid_delay2 <= 0;
    end
    else begin
        data_in_delay <= data_in;
        data_in_valid_delay1 <= data_in_valid;
        data_in_valid_delay2 <= data_in_valid_delay1;
    end
end

//计数器记录输入数据像素值的编号（一共75个）
reg [6:0] data_cnt;
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        data_cnt <= 0;
    else if(data_in_valid == 1'b1 && data_cnt == 10'd74)
        data_cnt <= 0;
    else if(data_in_valid == 1'b1)
        data_cnt <= data_cnt + 1'b1;
end

//data_out输出
wire data_cnt_equals783;  //data_out输出延时信号
reg data_cnt_equals783_delay1;
reg data_cnt_equals783_delay2;
reg data_cnt_equals783_delay3;
assign data_cnt_equals783 = (data_cnt == 74 && data_in_valid) ? 1'b1:1'b0;
always @(posedge clk)begin
    data_cnt_equals783_delay1 <= data_cnt_equals783;
    data_cnt_equals783_delay2 <= data_cnt_equals783_delay1;
    data_cnt_equals783_delay3 <= data_cnt_equals783_delay2;
end

//权重读取
wire [29:0] weights_rd_data;
weights weights_inst0(
    .clka (clk),    // input wire clka
    .ena  (1'b1),      // input wire ena
    .addra(data_cnt),  // input wire [6 : 0] addra
    .douta(weights_rd_data)  // output wire [99 : 0] douta
);

wire signed [9:0] weights[0:3]; //存放10个类别的一行（共784行）权重
genvar k;
generate
    for(k=0;k<3;k=k+1)begin 
        assign weights[k] = weights_rd_data[(k+1)*10-1:k*10];
    end
endgenerate

//MUL
integer i;
reg signed [DATA_WIDTH*2 - 1:0] mul_result[0:3]; 
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        for(i=0;i<3;i=i+1)begin
            mul_result[i] <= 0;
        end
    end
    else if(data_in_valid_delay1)begin
        for(i=0;i<3;i=i+1)begin
            // {8,X}*{7{},W} 补齐24位
            mul_result[i] <= {{16{1'b0}},data_in_delay} * {{(DATA_WIDTH*2 - 10){weights[i][9]}},weights[i]};
        end
    end
end

//sum_result值为上sum_result加上个mul_result
reg signed [32 - 1:0] sum_result[0:2]; 
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        for(i=0;i<3;i=i+1)begin
            sum_result[i] <= 0;
        end
    end
//    else if(data_in_valid_delay2 && data_cnt == 2)begin
    else if(data_out_valid)begin    //输出结果时清零
        for(i=0;i<3;i=i+1)begin
            sum_result[i] <= 0;
        end
    end
    else if(data_in_valid_delay2)begin

            sum_result[0] <= sum_result[0] + mul_result[0] + 8;
            sum_result[1] <= sum_result[1] + mul_result[1] + 0;
            sum_result[2] <= sum_result[2] + mul_result[2] + -7;

    end
end

//wire signed [9:0] c1_b[2:0]; 
//assign {c1_b[0],c1_b[1],c1_b[2]} = {10'b0000001101,10'b1111101100,10'b0000001010};

//输出320位预测数据
generate
for(k=0;k<3;k=k+1)begin
    assign data_out[(k+1)*32-1:k*32] = sum_result[k];
end
endgenerate

assign data_out_valid = data_cnt_equals783_delay3;

//测试数据
// wire [DATA_WIDTH*2 - 1:0] test_out_0 = data_out[DATA_WIDTH*2 - 1 : DATA_WIDTH*2*0];
// wire [DATA_WIDTH*2 - 1:0] test_out_1 = data_out[DATA_WIDTH*2*2-1 : DATA_WIDTH*2*1];
// wire [DATA_WIDTH*2 - 1:0] test_out_2 = data_out[DATA_WIDTH*2*3-1 : DATA_WIDTH*2*2];
// wire [DATA_WIDTH*2 - 1:0] test_out_3 = data_out[DATA_WIDTH*2*4-1 : DATA_WIDTH*2*3];
// wire [DATA_WIDTH*2 - 1:0] test_out_4 = data_out[DATA_WIDTH*2*5-1 : DATA_WIDTH*2*4];
// wire [DATA_WIDTH*2 - 1:0] test_out_5 = data_out[DATA_WIDTH*2*6-1 : DATA_WIDTH*2*5];
// wire [DATA_WIDTH*2 - 1:0] test_out_6 = data_out[DATA_WIDTH*2*7-1 : DATA_WIDTH*2*6];
// wire [DATA_WIDTH*2 - 1:0] test_out_7 = data_out[DATA_WIDTH*2*8-1 : DATA_WIDTH*2*7];
// wire [DATA_WIDTH*2 - 1:0] test_out_8 = data_out[DATA_WIDTH*2*9-1 : DATA_WIDTH*2*8];
// wire [DATA_WIDTH*2 - 1:0] test_out_9 = data_out[DATA_WIDTH*2*10-1: DATA_WIDTH*2*9];

endmodule
