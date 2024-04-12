module imopen(
    input               clk,
    input               rst_n,

    input               per_frame_vsync ,
    input               per_frame_href  ,
    input               per_frame_clken ,
    input               per_img_Bit     ,

    output              post_frame_vsync,
    output              post_frame_href ,
    output              post_frame_clken,
    output              post_img_Bit    
);

wire post0_frame_vsync; 
wire post0_frame_href ; 
wire post0_frame_clken; 
wire post0_img_Bit    ; 

erosion_detector
#(
	.IMG_HDISP          (10'd640            ),	//640*480
	.IMG_VDISP          (10'd480            )
)
erosion_detector_inst0(
	.clk                (clk                ),  				
	.rst_n              (rst_n              ),	

	.per_frame_vsync    (per_frame_vsync    ),	
	.per_frame_href     (per_frame_href     ),		
	.per_frame_clken    (per_frame_clken    ),	
	.per_img_Bit        (per_img_Bit        ),		

	.post_frame_vsync   (post0_frame_vsync  ),	
	.post_frame_href    (post0_frame_href   ),	
	.post_frame_clken   (post0_frame_clken  ),	
	.post_img_Bit       (post0_img_Bit      )		
);

dilation_detector 
#(
	.IMG_HDISP          (10'd640            ),	//640*480
	.IMG_VDISP          (10'd480            )
)
dilation_detector_inst0(
	.clk                 (clk               ),  			
	.rst_n               (rst_n             ),		

	.per_frame_vsync     (post0_frame_vsync ),	
	.per_frame_href      (post0_frame_href  ),		
	.per_frame_clken     (post0_frame_clken ),	
	.per_img_Bit         (post0_img_Bit     ),		

	.post_frame_vsync    (post_frame_vsync  ),	
	.post_frame_href     (post_frame_href   ),	
	.post_frame_clken    (post_frame_clken  ),	
	.post_img_Bit        (post_img_Bit      )		
);

endmodule
