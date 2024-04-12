// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Sun Mar 24 18:33:30 2024
// Host        : pc running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/nuha/Desktop/ece532_project/camera-system-top/camera_system-master/proj/camera_system.srcs/sources_1/ip/shift_reg_ram_1Bit/shift_reg_ram_1Bit_sim_netlist.v
// Design      : shift_reg_ram_1Bit
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tsbg484-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "shift_reg_ram_1Bit,c_shift_ram_v12_0_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_shift_ram_v12_0_12,Vivado 2018.3" *) 
(* NotValidForBitStream *)
module shift_reg_ram_1Bit
   (D,
    CLK,
    CE,
    Q);
  (* x_interface_info = "xilinx.com:signal:data:1.0 d_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME d_intf, LAYERED_METADATA undef" *) input [0:0]D;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF q_intf:sinit_intf:sset_intf:d_intf:a_intf, ASSOCIATED_RESET SCLR, ASSOCIATED_CLKEN CE, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:clockenable:1.0 ce_intf CE" *) (* x_interface_parameter = "XIL_INTERFACENAME ce_intf, POLARITY ACTIVE_LOW" *) input CE;
  (* x_interface_info = "xilinx.com:signal:data:1.0 q_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME q_intf, LAYERED_METADATA undef" *) output [0:0]Q;

  wire CE;
  wire CLK;
  wire [0:0]D;
  wire [0:0]Q;

  (* c_addr_width = "4" *) 
  (* c_ainit_val = "0" *) 
  (* c_default_data = "0" *) 
  (* c_depth = "640" *) 
  (* c_elaboration_dir = "./" *) 
  (* c_has_a = "0" *) 
  (* c_has_ce = "1" *) 
  (* c_has_sclr = "0" *) 
  (* c_has_sinit = "0" *) 
  (* c_has_sset = "0" *) 
  (* c_mem_init_file = "no_coe_file_loaded" *) 
  (* c_opt_goal = "0" *) 
  (* c_parser_type = "0" *) 
  (* c_read_mif = "0" *) 
  (* c_reg_last_bit = "1" *) 
  (* c_shift_type = "0" *) 
  (* c_sinit_val = "0" *) 
  (* c_sync_enable = "0" *) 
  (* c_sync_priority = "1" *) 
  (* c_verbosity = "0" *) 
  (* c_width = "1" *) 
  (* c_xdevicefamily = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  shift_reg_ram_1Bit_c_shift_ram_v12_0_12 U0
       (.A({1'b0,1'b0,1'b0,1'b0}),
        .CE(CE),
        .CLK(CLK),
        .D(D),
        .Q(Q),
        .SCLR(1'b0),
        .SINIT(1'b0),
        .SSET(1'b0));
endmodule

(* C_ADDR_WIDTH = "4" *) (* C_AINIT_VAL = "0" *) (* C_DEFAULT_DATA = "0" *) 
(* C_DEPTH = "640" *) (* C_ELABORATION_DIR = "./" *) (* C_HAS_A = "0" *) 
(* C_HAS_CE = "1" *) (* C_HAS_SCLR = "0" *) (* C_HAS_SINIT = "0" *) 
(* C_HAS_SSET = "0" *) (* C_MEM_INIT_FILE = "no_coe_file_loaded" *) (* C_OPT_GOAL = "0" *) 
(* C_PARSER_TYPE = "0" *) (* C_READ_MIF = "0" *) (* C_REG_LAST_BIT = "1" *) 
(* C_SHIFT_TYPE = "0" *) (* C_SINIT_VAL = "0" *) (* C_SYNC_ENABLE = "0" *) 
(* C_SYNC_PRIORITY = "1" *) (* C_VERBOSITY = "0" *) (* C_WIDTH = "1" *) 
(* C_XDEVICEFAMILY = "artix7" *) (* ORIG_REF_NAME = "c_shift_ram_v12_0_12" *) (* downgradeipidentifiedwarnings = "yes" *) 
module shift_reg_ram_1Bit_c_shift_ram_v12_0_12
   (A,
    D,
    CLK,
    CE,
    SCLR,
    SSET,
    SINIT,
    Q);
  input [3:0]A;
  input [0:0]D;
  input CLK;
  input CE;
  input SCLR;
  input SSET;
  input SINIT;
  output [0:0]Q;

  wire CE;
  wire CLK;
  wire [0:0]D;
  wire [0:0]Q;

  (* c_addr_width = "4" *) 
  (* c_ainit_val = "0" *) 
  (* c_default_data = "0" *) 
  (* c_depth = "640" *) 
  (* c_elaboration_dir = "./" *) 
  (* c_has_a = "0" *) 
  (* c_has_ce = "1" *) 
  (* c_has_sclr = "0" *) 
  (* c_has_sinit = "0" *) 
  (* c_has_sset = "0" *) 
  (* c_mem_init_file = "no_coe_file_loaded" *) 
  (* c_opt_goal = "0" *) 
  (* c_parser_type = "0" *) 
  (* c_read_mif = "0" *) 
  (* c_reg_last_bit = "1" *) 
  (* c_shift_type = "0" *) 
  (* c_sinit_val = "0" *) 
  (* c_sync_enable = "0" *) 
  (* c_sync_priority = "1" *) 
  (* c_verbosity = "0" *) 
  (* c_width = "1" *) 
  (* c_xdevicefamily = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  shift_reg_ram_1Bit_c_shift_ram_v12_0_12_viv i_synth
       (.A({1'b0,1'b0,1'b0,1'b0}),
        .CE(CE),
        .CLK(CLK),
        .D(D),
        .Q(Q),
        .SCLR(1'b0),
        .SINIT(1'b0),
        .SSET(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2015"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
R80NnScBgIZD14acGTeYZyZzlDoMDRJH97QvrM1z3/BPxjYOI5xO+RmLRE3ogivikKxeQqDB3hYo
CtT6MXJE8w==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
pzFf5UkhQCihEthT9/vXIu9qyyEco3ugn72RSG7p68vod9TXq7nS9azLrnGkzXHs3PQFBkq+3+ZG
PNN41vDN58/lK8pIjiAlp2V0xXr8ZRf/QoS3nU9pnZ3CEwxt9CGwUMks2MBnm+VSjWWRxbkUaTxZ
+kjzVWvQpUuyFFsOEs8=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
xDcafb3KrEW7vk1Eyiww/9CKbzlKF9C0uKrVBz5bHy5+6GMNsnwfCSkgxU14+VriR3jhdDN7viwB
M3a2pKPouTEOz066rknyw5X/sQ4hniBD3iUl4NQWkHTGym3kv31ZUeZYdl5ODPvzfUJOWUvkAXp/
gf4rtgV5FBbGm8qJS4jxuFSsv4rhcb7t+cae5sULvX9h7Uh0lEoAlNX3YmEW0fWj4bhIgTdzT2gk
C1ytdGU/UAnitwmujc/k+32KWV0i/o3dHRhIc31iawLLSmuBJYefDEaLG6KE8nGHeuho45Se0dhe
7kIaZp4SW1wGf7C0xxqwh1cgZ7+6eWgYBqVY1g==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
OrzITnToGC+ryHZVkpDHCj6CgE4vEVrPZ7Z829783FsE2zjugDCdpipuFZ7ikbeX4Bc52TEJ4mFm
0OxylPcCXPIE74pJ186gBXkmldW4bGFMhTmUHJ94bRAsyJjr329fm+j77y2NmfbHMVOsljahWWK4
OMppytgOrZcnsnsORsbXvvikZALiCB2t+Qc4RdHc3/98o+DDvRf+gwTZNX0GMOitJmVVvqxqw6No
K3aHL26WS+5291/TUz7aF7ySSp+k84h+0omwPrcy0Xc3URWaoYbqLrWiEi22RgQYitI1tEsa+afh
tv3h9WNr+65gWTbdbwWyOz1NeXJSaNV/mc+/Lg==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2017_05", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
riYGAyaVfIXieMgcJVFsucQ9kUNBkyzgx5CLlDibSmqSJjCaDvK63ymwoZpsGDT9Rugub8H1Y8xX
XUpLlzZGCXrlWs6NgjXfNxVpLlkmz7GswYkQ6KhUkZhRuPh0HrpJPt1ne+1pTM6fzi5LXsyTv6sn
TisWpJPdsnmBDHgM6jupb4Iv3OG7/q/NPck9K59oFLN+AyKeQ/8pEy2j7xpMiFTRlE1OTJj2mjHF
yWQWyURMafr1KK5t9Wu7YuocfKiTo0f6okHNafEo/nNpObW1D/liUJlS5GVguNNbnFjSuun9SM4T
MXhUoU0rVPqSkeCGnTpMMYK0MY5IwmbyZXn/fQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
HyAIbEI1uxEAA90t6+VWFTmyUje1JDZQZoMv6A5VyFWA8tJ80b/Pwhc93aHby8xZos0WjlEANrxF
3hJ/l8XJYMVZWlVytBIRAZYGbhnMBOGo/5sjE6O2Ap0308iwfA50rb1ZITdKRqNiW+PlWkaGC+3R
QMUfNUa7cSm841V7mmc=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
GUEL70ZQ78wO25wq2V+5JNZcUKzj485nYHAlIxulC+dFYZ1T3bS7X0juNGn/cdIyRbeWgA5z1viA
KyiSR064Z0BmWFsIYHfLEP1CENE6B/DkEgUM//4pBnGxH0CUe8wWHQBcyJQAxQHemECYQ5/QfTqT
96OTv0jwZ8yRjX1vKXS1qZKREGwNAsV3Kgrd9M5oaNz3PuISlyOOLoxPx9Qvu0Z0QYAzZbksLAI6
oekHTbR7CXs/P7+GCnbyf0lD6RFUyKASz8PAAvPi/+knG0A5BGQv9W8rEQ1GlCyJMbWqS7UMYIM5
Aany0Gd6zUtHqzCJMTpR0Gv6o8IS9bMCD8CICQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
gTP9H4+JA54hY6xYbWL7Eh29WRk52QnruHmN44Sl854A9O3eUO+FdlXHJ9yAlSEv1D8bksqWWEl+
HMr4ANVuDk5+C4cuaV9GSCJgs9qcP6CvWtxASyaXvC1wgt+p93wEGA9mCZj6FRYS1gnaZTpVeHlQ
T8aTbjrsToA+OPULYz3YCj+6Zrylx6KcUOFHgHqI922YYwEhKxQdL3Z2abEVpzM8NHpMBk1ZqAXg
r3QI8eQPBA6RajMCSr9W85oRBxJbQ0MNc4CKOlxyX/Wki3ndhTAabNEQqATfPxuiRMLeb/JkhZEx
gV/OJEozlupESCjl494uu7TBlxZFhfDeEBSiYg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
6Dpb+jFvTO9anNUJA8zyrjB+8FPdEonyrKu4TaVlE4kwQJAHg4d5K7tk9Pxpegvq1ahGuVQ1XRgy
T5BlB2VYyKEG8mmqHEpP5y1c40t36L9P4N1ymE+KCPRzVMyNRR+pCOkEQHBBxR5OxI8U6i2sRw8M
oF63lwikjTxJOILChS9U+SwbK3djsTj52BaNYOIVVL8yXveBIKKBfOwC6He8HUE9++BaZsK+u9r2
1g2py4f6C0a0+nkRWbd/HkISrJbJyMWTfCTHmGZyU7FKeX297MfOfTwIOhG5Van5/EklGVD0LmCp
jUJqU3cxuJaSwNkmWaaoRZ/egq+vXGYweQ6cVw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 21424)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
