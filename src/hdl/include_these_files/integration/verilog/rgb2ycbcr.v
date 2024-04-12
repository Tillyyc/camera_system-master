`timescale 1ns / 1ps
module rgb2ycbcr(
	//global clock
	input				clk,  				//cmos video pixel clock
	input				rst_n,				//global reset

	//Image data prepred to be processd
	input				per_frame_vsync,	
	input				per_frame_href,		
	input				per_frame_clken,	
	input		[7:0]	per_img_red,		
	input		[7:0]	per_img_green,		
	input		[7:0]	per_img_blue,		

	//Image data has been process
	output				post_frame_vsync,	
	output				post_frame_href,	
	output				post_frame_clken,	
	output		[7:0]	post_img_Y,			
	output		[7:0]	post_img_Cb,		
	output		[7:0]	post_img_Cr			
);

//--------------------------------------------
/*********************************************
//Refer to <OV7725 Camera Module Software Applicaton Note> page 5
	Y 	=	(77 *R 	+ 	150*G 	+ 	29 *B)>>8
	Cb 	=	(-43*R	- 	85 *G	+ 	128*B)>>8 + 128
	Cr 	=	(128*R 	-	107*G  	-	21 *B)>>8 + 128
--->
	Y 	=	(77 *R 	+ 	150*G 	+ 	29 *B)>>8
	Cb 	=	(-43*R	- 	85 *G	+ 	128*B + 32768)>>8
	Cr 	=	(128*R 	-	107*G  	-	21 *B + 32768)>>8
**********************************************/
//Step 1
reg	[15:0]	img_red_r0,		img_red_r1,		img_red_r2;	
reg	[15:0]	img_green_r0,	img_green_r1,	img_green_r2; 
reg	[15:0]	img_blue_r0,	img_blue_r1,	img_blue_r2; 
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		img_red_r0		<=	0; 		
		img_red_r1		<=	0; 		
		img_red_r2		<=	0; 	
		img_green_r0	<=	0; 		
		img_green_r1	<=	0; 		
		img_green_r2	<=	0; 	
		img_blue_r0		<=	0; 		
		img_blue_r1		<=	0; 		
		img_blue_r2		<=	0; 			
		end
	else
		begin
		img_red_r0		<=	per_img_red 	* 	8'd77; 		
		img_red_r1		<=	per_img_red 	* 	8'd43; 	
		img_red_r2		<=	per_img_red 	* 	8'd128; 		
		img_green_r0	<=	per_img_green 	* 	8'd150; 		
		img_green_r1	<=	per_img_green 	* 	8'd85; 			
		img_green_r2	<=	per_img_green 	* 	8'd107; 
		img_blue_r0		<=	per_img_blue 	* 	8'd29; 		
		img_blue_r1		<=	per_img_blue 	* 	8'd128; 			
		img_blue_r2		<=	per_img_blue 	* 	8'd21; 		
		end
end

//--------------------------------------------------
//Step 2
reg	[15:0]	img_Y_r0;	
reg	[15:0]	img_Cb_r0; 
reg	[15:0]	img_Cr_r0; 
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		img_Y_r0	<=	0; 		
		img_Cb_r0	<=	0; 		
		img_Cr_r0	<=	0; 	
		end
	else
		begin
		img_Y_r0	<=	img_red_r0 	+ 	img_green_r0 	+ 	img_blue_r0; 		
		img_Cb_r0	<=	img_blue_r1 - 	img_red_r1 		- 	img_green_r1	+	16'd32768; 		
		img_Cr_r0	<=	img_red_r2 	+ 	img_green_r2 	+ 	img_blue_r2		+	16'd32768; 		
		end
end

//--------------------------------------------------
//Step 3
reg	[7:0]	img_Y_r1;	
reg	[7:0]	img_Cb_r1; 
reg	[7:0]	img_Cr_r1; 
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		img_Y_r1	<=	0; 		
		img_Cb_r1	<=	0; 		
		img_Cr_r1	<=	0; 	
		end
	else
		begin
		img_Y_r1	<=	img_Y_r0[15:8];
		img_Cb_r1	<=	img_Cb_r0[15:8];
		img_Cr_r1	<=	img_Cr_r0[15:8]; 
		end
end

//------------------------------------------
//lag 3 clocks signal sync  
reg	[2:0]	per_frame_vsync_r;
reg	[2:0]	per_frame_href_r;	
reg	[2:0]	per_frame_clken_r;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		per_frame_vsync_r <= 0;
		per_frame_href_r <= 0;
		per_frame_clken_r <= 0;
		end
	else
		begin
		per_frame_vsync_r 	<= 	{per_frame_vsync_r[1:0], 	per_frame_vsync};
		per_frame_href_r 	<= 	{per_frame_href_r[1:0], 	per_frame_href};
		per_frame_clken_r 	<= 	{per_frame_clken_r[1:0], 	per_frame_clken};
		end
end
assign	post_frame_vsync 	= 	per_frame_vsync_r[2];
assign	post_frame_href 	= 	per_frame_href_r[2];
assign	post_frame_clken 	= 	per_frame_clken_r[2];
assign	post_img_Y 	= 	post_frame_href ? img_Y_r1 : 8'd0;
assign	post_img_Cb =	post_frame_href ? img_Cb_r1: 8'd0;
assign	post_img_Cr = 	post_frame_href ? img_Cr_r1: 8'd0;

endmodule
