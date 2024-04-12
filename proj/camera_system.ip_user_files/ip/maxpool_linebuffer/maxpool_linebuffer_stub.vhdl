-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
-- Date        : Sun Mar 24 18:41:42 2024
-- Host        : pc running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/nuha/Desktop/ece532_project/camera-system-top/camera_system-master/proj/camera_system.srcs/sources_1/ip/maxpool_linebuffer/maxpool_linebuffer_stub.vhdl
-- Design      : maxpool_linebuffer
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a200tsbg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity maxpool_linebuffer is
  Port ( 
    clka : in STD_LOGIC;
    wea : in STD_LOGIC_VECTOR ( 0 to 0 );
    addra : in STD_LOGIC_VECTOR ( 4 downto 0 );
    dina : in STD_LOGIC_VECTOR ( 31 downto 0 );
    clkb : in STD_LOGIC;
    addrb : in STD_LOGIC_VECTOR ( 4 downto 0 );
    doutb : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );

end maxpool_linebuffer;

architecture stub of maxpool_linebuffer is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,wea[0:0],addra[4:0],dina[31:0],clkb,addrb[4:0],doutb[31:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_2,Vivado 2018.3";
begin
end;