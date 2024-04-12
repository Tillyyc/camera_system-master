`timescale 1ns / 1ps

module maxpool #(
    parameter                   DATA_WIDTH = 24,
    parameter                   DISP_WIDTH = 26 //input feature map width
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

//26*26 input counter 
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
    
//compare results and save to RAM
wire [DATA_WIDTH - 1:0] wr_data[0:2];
wire [DATA_WIDTH - 1:0] rd_data[0:2];
wire        wr_en;
reg  [4:0]  wr_addr;
reg  [4:0]  rd_addr;

assign wr_en = x_cnt > 0;  
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

//compare the max value for each row
wire [DATA_WIDTH*3-1:0] data_out;
generate
    for(k=0;k<3;k=k+1)begin
        assign data_out[(k+1)*DATA_WIDTH-1:k*DATA_WIDTH] = (rd_data[k] > wr_data[k]) ? rd_data[k] : wr_data[k]; 
    end    
endgenerate

assign data_out_valid = (x_cnt[0:0] == 1 && y_cnt[0:0] == 1) ? 1'b1 : 1'b0; 

//ouput
assign data_out_1 = data_out[DATA_WIDTH-1: 0];
assign data_out_2 = data_out[DATA_WIDTH*2-1:DATA_WIDTH];
assign data_out_3 = data_out[DATA_WIDTH*3-1:DATA_WIDTH*2];

endmodule
