`timescale 1ns / 1ps

module top(
        input   wire CLK,
        input   wire RESETn,
        input   wire cam_RESETn,
        
        //recognized gesture 
        output wire [2:0] LED,
        
        //game interface
        output wire [1:0] winner,
        output wire [1:0] computer_gesture,
        input wire valid_input,
        input wire go,
        
        //OV7670
       
        output  wire OV7670_SIOC,
        inout   wire OV7670_SIOD,
        input   wire OV7670_PCLK,
        input   wire OV7670_VSYNC,
        input   wire OV7670_HREF,
        input   wire [7:0]OV7670_D,
        output  wire OV7670_XCLK,
        output  wire OV7670_PWDN, 
        output  wire OV7670_RESET, 
        //HDMI
        output wire [2:0] TMDSp,
        output wire [2:0] TMDSn,
        output wire TMDSp_clk,
        output wire TMDSn_clk,
        //UART
        input  wire usb_uart_rxd,
        output wire usb_uart_txd,
        //SW
        input wire[2:0] SW
        );
        
    wire [15:0]data;
	wire [15:0]douta;
	assign data[5] = 0; // for green we save 5 of 6 bits
	assign douta[5] = 0;
	wire wea;
	wire [18:0]hdmi_index;
	wire [18:0]camera_index;
    wire clk25,clk50,clk250,hdmi_clk25,locked;
	wire [15:0]pixel;
	wire valid,end_frame;
	reg  pwdn=0;
	reg [31:0]nr=0;
	wire siod_oe;
	wire siod_out;
	wire siod_in;
	wire com_done;
	wire [7:0] data_read;
	wire [7:0] addr_rw;
	wire [7:0] data_com;
	wire rreq,wreq;
	wire uart_trans_err;
	wire RESETn_clean;
	wire RESETn,cam_RESETn_clean;
	wire cmos_frame_valid;
	wire init_done;
	wire key_in1;
	wire key_in2;
	wire [3:0] label_index;
	
	assign OV7670_SIOD = (siod_oe) ? (siod_out ? 1'bz : 1'b0) : 1'bz;
	assign siod_in = OV7670_SIOD;
	assign OV7670_XCLK = clk25;
	assign OV7670_PWDN = pwdn;
	assign OV7670_RESET = cam_RESETn_clean;
	

	
	
    
	//for testing
//	assign LED0 = init_done;
//	assign LED1 = 0;
//	assign LED2 = 0;
	
	//clock dividers	
	divider_2 div2(CLK,clk50);
	divider_4 div4(CLK,clk25);
	
	//debounce inputs
	debounce_inputs #(.NR(1))dbi(CLK,~RESETn,RESETn_clean);
	debounce_inputs #(.NR(1))dbi_reset_test(CLK,~cam_RESETn,cam_RESETn_clean);

    wire [2:0] SW_clean;
    wire [2:0] sel_filter;
    debounce_inputs #(.NR(3))dbi_sw(CLK,SW,SW_clean);
    
    assign sel_filter = SW_clean;
    
    
    wire [1:0] computer_gesture_intermediate;
    
    assign computer_gesture = computer_gesture_intermediate & valid_input;
    ///////////game//////////////////
    game_master game(CLK, ~RESETn, valid_input, label_index, go, winner, computer_gesture_intermediate);
    
    
    
    
    //////////////HMDI Control///////////////
    clk_wiz_0 mult_clk ( 
            .clk250(clk250),
            .clk25(hdmi_clk25),
            .reset(1'b0),
            .locked(locked),
            .clk100(CLK)
     );
     
    OBUFDS OBUFDS_clk(
            .I(hdmi_clk25), 
            .O(TMDSp_clk), 
            .OB(TMDSn_clk)
            );
    
    hdmi_ctrl hdmi_ctrl(
            .clk25(hdmi_clk25),
            .clk50(clk50),
            .clk250(clk250),
            .RESETn(RESETn_clean),
            .TMDSp(TMDSp),
            .TMDSn(TMDSn),
            .data(data),
            .index(hdmi_index)
            );
    ////////////////////////////////////////////
    
    
    /////////////UART Control///////////////////        
    uart_ctrl uart
               (.clk(clk25),
                .resetn(RESETn_clean),
                .error(uart_trans_err),
                .com_done(com_done),
                .en(init_done),
                .data(data_read),
                .addr(addr_rw),
                .data_com(data_com),
                .rreq(rreq),
                .wreq(wreq),
                .usb_uart_rxd(usb_uart_rxd),
                .usb_uart_txd(usb_uart_txd)
                );
    /////////////////////////////////////////////
    
    
    ///////////////SCCB Control/////////////////
	sccb_ctrl sccb(
			.clk25(clk25),
			.RESETn(RESETn_clean), 
			.SIOC(OV7670_SIOC),
			.siod_oe(siod_oe),
			.siod_out(siod_out),
			.siod_in(siod_in),
			.init_done(init_done),
			.com_done(com_done),
			.data_read(data_read),
			.data_write(data_com),
			.addr_rw(addr_rw),
			.rreq(rreq),
			.wreq(wreq)
			);
    //////////////////////////////////////////////


    ///////////capture and filter data////////////
    processing process(
             .clk(CLK),
             .RESETn(cam_RESETn_clean),
             //OV7670
             .PCLK(OV7670_PCLK),
             .VSYNC(OV7670_VSYNC),
             .HREF(OV7670_HREF),
             .D(OV7670_D),
             //to be outputed to memory
             .red(pixel[15:11]),
             .green(pixel[10:6]),
             .blue(pixel[4:0]),
             .index(camera_index),
             .valid(valid),
             .init_done(init_done),
             .sel_filter(sel_filter)
        );    
    assign pixel[5] = 0;
    /////////////////////////////////////////////////
	
	
	/////////////////////BRAM////////////////////////	
	ram buffer_r(
		.clka(CLK), 
		.wea(valid), 
		.addra(camera_index), 
		.dina(pixel[15:11]),
		.douta(douta[15:11]), 
		.clkb(clk50), 
		.web(0), 
		.addrb(hdmi_index), 
		.dinb(0), 
		.doutb(data[15:11])
		);
		
		ram buffer_g(
            .clka(CLK), 
            .wea(valid), 
            .addra(camera_index), 
            .dina(pixel[10:6]), 
            .douta(douta[10:6]), 
            .clkb(clk50), 
            .web(0), 
            .addrb(hdmi_index), 
            .dinb(0), 
            .doutb(data[10:6])
            );
        ram buffer_b(
            .clka(CLK), 
            .wea(valid), 
            .addra(camera_index), 
            .dina(pixel[4:0]), 
            .douta(douta[4:0]), 
            .clkb(clk50), 
            .web(0), 
            .addrb(hdmi_index), 
            .dinb(0), 
            .doutb(data[4:0])
            );
    /////////////////////////////////////////////////
    
    
    
    
    /////////////wire/////////////
    wire			cmos_frame_vsync ;
    wire			cmos_frame_href  ;
    wire			cmos_frame_clken ;
    wire [15:0]	    cmos_frame_data  ;// RGB565	
    wire [7:0]      bin_threshod     ;

    wire            lenet_data_valid;
    wire [7:0]      lenet_data;     
    ///////////////////////////////

    ///////////////////////captuure/////////////////
    cmos_capture_data u_cmos_capture_data(
    .rst_n              (RESETn_clean & init_done),
    
    .cam_pclk           (OV7670_PCLK),
    .cam_vsync          (OV7670_VSYNC),
    .cam_href           (OV7670_HREF),
    .cam_data           (OV7670_D),         
    
    .cmos_frame_vsync   (cmos_frame_vsync),
    .cmos_frame_href    (cmos_frame_href ),
    .cmos_frame_valid   (cmos_frame_clken), //
    .cmos_frame_data    (cmos_frame_data )  //
    );
    ///////////////////////////////////////////////////

    ///////////compression & grayscale///////////////////////

    //ram ips needed
    rgb2bin_process rgb2bin_process_inst0(
    .clk                (OV7670_PCLK           ),
    .rst_n              (RESETn_clean              ),
    .lcd_clk            (1'b0            ),
    .bin_threshod       (bin_threshod       ),

    .img_frame_vsync    (cmos_frame_vsync   ),
    .img_frame_hsync    (cmos_frame_href    ),
    .img_data_valid     (cmos_frame_clken   ),
    .img_data           ({{cmos_frame_data[15:11],cmos_frame_data[15:13]},{cmos_frame_data[10:5],cmos_frame_data[10:9]},{cmos_frame_data[4:0],cmos_frame_data[4:2]}}),

    .out_frame_vsync    (     ),
    .out_data_valid     (     ),
    .out_data           (     ),
    .lenet_data_valid   (lenet_data_valid   ),
    .lenet_data         (lenet_data         )
    );
    //////////////////////////////////////////////////////


    ////////////threshod adjestion/////////////
    key_debounce key_debounce(
    .sys_clk            (CLK), 
    .sys_rst_n          (RESETn_clean),
    .key_in1            (key_in1),   //need change
    .key_in2            (key_in2),   //need change
    .bin_threshod       (bin_threshod)
    );
    /////////////////////////////////////////


    /////////////////CNN Model//////////////////////

    //ram ip needed
    assign LED = label_index;
    
    Mini_LeNet Mini_LeNet_inst0(
    .clk                (OV7670_PCLK   ),
    .rst_n              (RESETn_clean      ),

    .data_in            (lenet_data),
    .data_in_valid      (lenet_data_valid),

    .data_out           (label_index)
    );
    /////////////////////////////////////////////////
    
endmodule

