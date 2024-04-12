`timescale 1ns / 1ps
// Module Name: shift_register_2taps
// Description: 基于RAM的移位寄存器，2行缓存
module shift_register_2taps_1Bit(
    input	  clken,
	input	  clk,
	input	  shiftin,

	output	  shiftout,
	output	  taps0x,
	output	  taps1x
    );
    
shift_reg_ram_1Bit shift_reg_ram_1Bit_inst1 (
  .D(shiftin),      // input wire [0 : 0] D
  .CLK(clk),  // input wire CLK
  .CE(clken),    // input wire CE
  .Q(taps0x)      // output wire [0 : 0] Q
);

shift_reg_ram_1Bit shift_reg_ram_1Bit_inst2 (
  .D(taps0x),      // input wire [0 : 0] D
  .CLK(clk),  // input wire CLK
  .CE(clken),    // input wire CE
  .Q(taps1x)      // output wire [0 : 0] Q
);

endmodule
