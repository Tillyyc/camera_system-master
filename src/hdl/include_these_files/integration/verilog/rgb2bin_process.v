`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/06 14:48:54
// Design Name: 
// Module Name: rgb2bin_process
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
module rgb2bin_process(
    input               clk,
    input               rst_n,
    input               lcd_clk,
    input  [7:0]        bin_threshod,

    input               img_frame_vsync,
    input               img_frame_hsync,
    input               img_data_valid ,
    input  [23:0]       img_data,

    output              out_frame_vsync ,
    output              out_data_valid  ,
    output [15:0]       out_data        ,   //输出给LCD显示数据
    output              lenet_data_valid,
    output [7:0]        lenet_data          //输出给Lenet数据
    );

//RGB2GARY delay 3 clock
wire 	   post0_frame_vsync;   
wire 	   post0_frame_href ;   
wire 	   post0_frame_clken;    
wire [7:0] post0_img_Y      ;    

rgb2ycbcr rgb2ycbcr_inst                
(
	.clk                (clk                ),					
	.rst_n              (rst_n              ),				

	.per_frame_vsync    (img_frame_vsync    ),		
	.per_frame_href     (img_frame_hsync    ),		
	.per_frame_clken    (img_data_valid     ),		
	.per_img_red        (img_data[23:16]    ),			
	.per_img_green      (img_data[15: 8]    ),		
	.per_img_blue       (img_data[ 7: 0]    ),			
	
	.post_frame_vsync   (post0_frame_vsync  ),	
	.post_frame_href    (post0_frame_href   ),		
	.post_frame_clken   (post0_frame_clken  ),	
	.post_img_Y         (post0_img_Y        ),			
	.post_img_Cb        (                   ),			
	.post_img_Cr        (                   )			
);

//delay 8 clock
wire bin_frame_vsync;
wire bin_data_valid ;
wire bin_data       ;

imopen imopen_inst0(
    .clk                (clk                ),
    .rst_n              (rst_n              ),

    .per_frame_vsync    (post0_frame_vsync  ),
    .per_frame_href     (post0_frame_href   ),
    .per_frame_clken    (post0_frame_clken  ),
    //.per_img_Bit        (post0_img_Y > bin_threshod ? 1 : 0),
    .per_img_Bit        (post0_img_Y),
    .post_frame_vsync   (bin_frame_vsync    ),
    .post_frame_href    (                   ),
    .post_frame_clken   (bin_data_valid     ),
    .post_img_Bit       (bin_data           )
);

reg  [9:0] x_cnt;
reg  [9:0] y_cnt;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        x_cnt <= 10'd0;
    else if(x_cnt == 640 -1 && post0_frame_clken)
        x_cnt <= 10'd0;
    else if(post0_frame_clken)
        x_cnt <= x_cnt + 1'b1;
    else 
        x_cnt <= x_cnt;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        y_cnt <= 10'd0;
    else if(y_cnt == 480)
        y_cnt <= 10'd0;
    else if(x_cnt == 640 -1 && post0_frame_clken)
        y_cnt <= y_cnt + 1'b1;
    else
        y_cnt <= y_cnt;
end

reg  row_valid; //行有效
reg  col_valid; //列有效

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        row_valid <= 1'b0;
    else if((x_cnt % 6 == 0) && (x_cnt >= 229 && x_cnt <= 396))
        row_valid <= 1'b1;
    else
        row_valid <= 1'b0;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        col_valid <= 1'b0;
    else if((y_cnt % 6 == 0) && (y_cnt >= 156 && y_cnt <= 323))
        col_valid <= 1'b1;
    else 
        col_valid <= 1'b0;
end

assign lenet_data_valid = row_valid && col_valid && post0_frame_clken;
assign lenet_data       = post0_img_Y;

assign out_frame_vsync = img_frame_vsync;
assign out_data_valid = img_data_valid;
// assign out_data = (x_cnt >= 229 && x_cnt <= 396 && y_cnt >= 156 && y_cnt <= 323) ? {16{~bin_data}} : {img_data[23:19],img_data[15:10],img_data[7:3]};
assign out_data = (x_cnt >= 233 && x_cnt <= 400 && y_cnt >= 156 && y_cnt <= 323) ? {post0_img_Y[7:3],post0_img_Y[7:2],post0_img_Y[7:3]} : {img_data[23:19],img_data[15:10],img_data[7:3]};

endmodule
