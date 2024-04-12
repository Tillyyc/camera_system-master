`timescale 1ns / 1ps

//input=> 3 5x5 output=> 1x75
module reshape #(
    parameter                   DATA_WIDTH = 32
)(
    input                       clk,
    input                       rst_n,
    input                       predict_end,

    input  [DATA_WIDTH - 1:0]   data_in_1,  
    input  [DATA_WIDTH - 1:0]   data_in_2,
    input  [DATA_WIDTH - 1:0]   data_in_3,
    input                       data_in_valid,

    output [DATA_WIDTH - 1:0]   data_out,
    output                      data_out_valid
    );

//read into RAM and read out
reg                     fifo_2_rd_en;
wire [DATA_WIDTH - 1:0] fifo_2_data;
reg                     fifo_3_rd_en;
wire [DATA_WIDTH - 1:0] fifo_3_data;

reg  [4:0]              data_in_1_cnt;
reg  [4:0]              fifo_2_rd_cnt;
reg  [4:0]              fifo_3_rd_cnt;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        data_in_1_cnt <= 'd0;
    else if(data_in_1_cnt == 25)
        data_in_1_cnt <= 'd0;
    else if(data_in_valid)
        data_in_1_cnt <= data_in_1_cnt + 1'b1;
    else 
        data_in_1_cnt <= data_in_1_cnt;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        fifo_2_rd_cnt <= 'd0;
    else if(fifo_2_rd_cnt == 25)
        fifo_2_rd_cnt <= 1'b0;
    else if(fifo_2_rd_en)
        fifo_2_rd_cnt <= fifo_2_rd_cnt + 1'b1;
    else
        fifo_2_rd_cnt <= fifo_2_rd_cnt;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        fifo_2_rd_en <= 'd0;
    else if(fifo_2_rd_cnt == 25 - 1)
        fifo_2_rd_en <= 1'b0;
    else if(data_in_1_cnt == 25)    //1st feature map finished
        fifo_2_rd_en <= 1'b1;
    else 
        fifo_2_rd_en <= fifo_2_rd_en;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        fifo_3_rd_cnt <= 'd0;
    else if(fifo_3_rd_cnt == 25)
        fifo_3_rd_cnt <= 'd0;
    else if(fifo_3_rd_en)
        fifo_3_rd_cnt <= fifo_3_rd_cnt + 1'b1;
    else
        fifo_3_rd_cnt <= fifo_3_rd_cnt;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        fifo_3_rd_en <= 1'b0;
    else if(fifo_3_rd_cnt == 25 - 1)
        fifo_3_rd_en <= 1'b0;
    else if(fifo_2_rd_cnt == 25)    //2nd feature map finished
        fifo_3_rd_en <= 1'b1;
    else
        fifo_3_rd_en <= fifo_3_rd_en;
end 

fifo_reshape fifo_reshape_inst0(
  .clk      (clk),      // input wire clk
  .srst     (predict_end),
  .din      (data_in_2),      // input wire [23 : 0] din
  .wr_en    (data_in_valid),  // input wire wr_en
  .rd_en    (fifo_2_rd_en),  // input wire rd_en
  .dout     (fifo_2_data),    // output wire [23 : 0] dout
  .full     (),    // output wire full
  .empty    ()  // output wire empty
);

fifo_reshape fifo_reshape_inst1(
  .clk      (clk),      // input wire clk
  .srst     (predict_end),
  .din      (data_in_3),      // input wire [23 : 0] din
  .wr_en    (data_in_valid),  // input wire wr_en
  .rd_en    (fifo_3_rd_en),  // input wire rd_en
  .dout     (fifo_3_data),    // output wire [23 : 0] dout
  .full     (),    // output wire full
  .empty    ()  // output wire empty
);

//switch output value
reg  [DATA_WIDTH - 1:0] ro_data_out;
reg                     ro_data_out_valid;
reg                     fifo_2_rd_en_d1;
reg                     fifo_3_rd_en_d1;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        fifo_2_rd_en_d1 <= 1'b0;
        fifo_3_rd_en_d1 <= 1'b0;
    end
    begin
        fifo_2_rd_en_d1 <= fifo_2_rd_en;
        fifo_3_rd_en_d1 <= fifo_3_rd_en;
    end
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        ro_data_out        <= 'd0;
        ro_data_out_valid  <= 'd0;
    end
    else if(data_in_valid)begin
        ro_data_out        <= data_in_1;
        ro_data_out_valid  <= data_in_valid;
    end
    else if(fifo_2_rd_en_d1)begin
        ro_data_out        <= fifo_2_data;
        ro_data_out_valid  <= fifo_2_rd_en_d1;
    end
    else if(fifo_3_rd_en_d1)begin
        ro_data_out        <= fifo_3_data;
        ro_data_out_valid  <= fifo_3_rd_en_d1;
    end
    else begin
        ro_data_out        <= 'd0;      
        ro_data_out_valid  <= 'd0;
    end
end

assign data_out = ro_data_out;
assign data_out_valid = ro_data_out_valid;

endmodule
