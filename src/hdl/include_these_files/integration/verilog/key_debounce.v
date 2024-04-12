`timescale 1ns / 1ps
module  key_debounce(
    input               sys_clk     , 
    input               sys_rst_n   ,
    input               key_in1     ,
    input               key_in2     ,

    output reg [7:0]    bin_threshod
);

parameter CNT_MAX = 20'd999_999;
reg     [19:0]  cnt1_20ms   ;
reg     [19:0]  cnt2_20ms   ;
reg         key_flag1   ;
reg         key_flag2   ;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt1_20ms <= 20'b0;
    else    if(key_in1 == 1'b1)
        cnt1_20ms <= 20'b0;
    else    if(cnt1_20ms == CNT_MAX && key_in1 == 1'b0)
        cnt1_20ms <= cnt1_20ms;
    else
        cnt1_20ms <= cnt1_20ms + 1'b1;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt2_20ms <= 20'b0;
    else    if(key_in2 == 1'b1)
        cnt2_20ms <= 20'b0;
    else    if(cnt2_20ms == CNT_MAX && key_in2 == 1'b0)
        cnt2_20ms <= cnt2_20ms;
    else
        cnt2_20ms <= cnt2_20ms + 1'b1;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        key_flag1 <= 1'b0;
    else    if(cnt1_20ms == CNT_MAX - 1'b1)
        key_flag1 <= 1'b1;
    else
        key_flag1 <= 1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        key_flag2 <= 1'b0;
    else    if(cnt2_20ms == CNT_MAX - 1'b1)
        key_flag2 <= 1'b1;
    else
        key_flag2 <= 1'b0;

always@(posedge sys_clk or negedge sys_rst_n)begin
    if(sys_rst_n == 1'b0)
        bin_threshod <= 8'd120;
    else if(key_flag1)
        bin_threshod <= bin_threshod + 1'b1;
    else if(key_flag2)
        bin_threshod <= bin_threshod - 1'b1;
    else
        bin_threshod <= bin_threshod;
end

endmodule
