`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 江城白羊生姜座
// 
// Create Date: 2023/12/30 00:01:44
// Design Name: 
// Module Name: maxpool1
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
module maxpool #(
    parameter                   DATA_WIDTH = 24,
    parameter                   DISP_WIDTH = 26 //输入图像像素宽高
)(
    input                       clk,
    input                       rst_n,

    input  [DATA_WIDTH - 1:0]   data_in_1,
    input  [DATA_WIDTH - 1:0]   data_in_2,
    input  [DATA_WIDTH - 1:0]   data_in_3,
    input                       data_in_valid,

    output [DATA_WIDTH - 1:0]   data_out_1,
    output [DATA_WIDTH - 1:0]   data_out_2,
    output [DATA_WIDTH - 1:0]   data_out_3,
    output                      data_out_valid
    );

wire [DATA_WIDTH*3-1:0] data_in;
assign data_in = {data_in_3,data_in_2,data_in_1};

//26*26图像数据输入计数器
reg [4:0] x_cnt;
reg [4:0] y_cnt;
always @(posedge clk or negedge rst_n)begin
    if(~rst_n)
        x_cnt <= 0;
    else if(data_in_valid && x_cnt == DISP_WIDTH - 1)
        x_cnt <= 0;
    else if(data_in_valid)
        x_cnt <= x_cnt + 1'b1; 
    else
        x_cnt <= x_cnt;
end

always @(posedge clk or negedge rst_n)begin
    if(~rst_n)
        y_cnt <= 0;
    else if(data_in_valid && x_cnt == DISP_WIDTH - 1 && y_cnt == DISP_WIDTH - 1)
        y_cnt <= 0;
    else if(data_in_valid && x_cnt == DISP_WIDTH - 1)
        y_cnt <= y_cnt + 1'b1; 
    else
        y_cnt <= y_cnt;
end

//delay_data_in
reg [DATA_WIDTH*3-1:0] delay_data_in;
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        delay_data_in <= 'd0;
    else
        delay_data_in <= data_in;
end
    
//比较前后两个数据大小并存入RAM 
wire [DATA_WIDTH - 1:0] wr_data[0:2];
wire [DATA_WIDTH - 1:0] rd_data[0:2];
wire        wr_en;
reg  [4:0]  wr_addr;
reg  [4:0]  rd_addr;

assign wr_en = x_cnt > 0;  //数据进入并比较后开始写人RAM
genvar k;
generate
    for(k=0;k<3;k=k+1)begin
        assign wr_data[k] = (data_in[(k+1)*DATA_WIDTH-1:k*DATA_WIDTH] > 
        delay_data_in[(k+1)*DATA_WIDTH-1:k*DATA_WIDTH]) ? 
        data_in[(k+1)*DATA_WIDTH-1:k*DATA_WIDTH] : delay_data_in[(k+1)*DATA_WIDTH-1:k*DATA_WIDTH];
    end
endgenerate

wire [4:0] rd_addr_pre2 = wr_addr + 2;
always @(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
        wr_addr <= 0;
        rd_addr <= 0;
    end
    else if(data_in_valid)begin
        if(wr_addr == DISP_WIDTH - 1)
            wr_addr <= 0;
        else
            wr_addr <= wr_addr + 1'b1;
            
        if(rd_addr_pre2 > DISP_WIDTH - 1)
            rd_addr <= rd_addr_pre2 - DISP_WIDTH;
        else
            rd_addr <= rd_addr_pre2;
    end 
end

generate
for(k=0;k<3;k=k+1)begin
maxpool_linebuffer maxpool_linebuffer_inst0(
  .clka         (clk),    // input wire clka
  .wea          (wr_en),      // input wire [0 : 0] wea
  .addra        (wr_addr),  // input wire [4 : 0] addra
  .dina         (wr_data[k]),    // input wire [31 : 0] dina
  
  .clkb         (clk),    // input wire clkb
  .addrb        (rd_addr),  // input wire [4 : 0] addrb
  .doutb        (rd_data[k])  // output wire [31 : 0] doutb
);
end
endgenerate

//上一行比较出来的最大值与下一行再进行比较
wire [DATA_WIDTH*3-1:0] data_out;
generate
    for(k=0;k<3;k=k+1)begin
        assign data_out[(k+1)*DATA_WIDTH-1:k*DATA_WIDTH] = (rd_data[k] > wr_data[k]) ? rd_data[k] : wr_data[k]; 
    end    
endgenerate

assign data_out_valid = (x_cnt[0:0] == 1 && y_cnt[0:0] == 1) ? 1'b1 : 1'b0; 

//数据输出
assign data_out_1 = data_out[DATA_WIDTH-1: 0];
assign data_out_2 = data_out[DATA_WIDTH*2-1:DATA_WIDTH];
assign data_out_3 = data_out[DATA_WIDTH*3-1:DATA_WIDTH*2];

endmodule
