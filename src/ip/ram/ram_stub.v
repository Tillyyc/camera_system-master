// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Sun Mar 24 17:57:51 2024
// Host        : pc running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/nuha/Desktop/ece532_project/camera-system-top/camera_system-master/src/ip/ram/ram_stub.v
// Design      : ram
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tsbg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_2,Vivado 2018.3" *)
module ram(clka, wea, addra, dina, douta, clkb, web, addrb, dinb, 
  doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[18:0],dina[4:0],douta[4:0],clkb,web[0:0],addrb[18:0],dinb[4:0],doutb[4:0]" */;
  input clka;
  input [0:0]wea;
  input [18:0]addra;
  input [4:0]dina;
  output [4:0]douta;
  input clkb;
  input [0:0]web;
  input [18:0]addrb;
  input [4:0]dinb;
  output [4:0]doutb;
endmodule
