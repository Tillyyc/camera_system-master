// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Sun Mar 24 18:33:30 2024
// Host        : pc running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ shift_reg_ram_1Bit_sim_netlist.v
// Design      : shift_reg_ram_1Bit
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tsbg484-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "shift_reg_ram_1Bit,c_shift_ram_v12_0_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_shift_ram_v12_0_12,Vivado 2018.3" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_c_shift_ram_v12_0_12 U0
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
(* C_XDEVICEFAMILY = "artix7" *) (* downgradeipidentifiedwarnings = "yes" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_c_shift_ram_v12_0_12
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_c_shift_ram_v12_0_12_viv i_synth
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
VsAGHZu3P7RYC8tLrEZhR48RWnrShUuvPXRiKKlcxJMwHy44Xi9eqQoagU7PofK1fC6Vax2r0qul
QgTzkKos7lprx/jUuKYIccGd+AsrYbTjLkXRZYKqlH2gvo5UA3KOQoXYFMq3WpvhBmShV38md0Us
Ytg0QytymN9MMNmhKNAOAMvarEeyzbznicvNBDlGwG15pkdE5F8AQXsqJ9Ef1YBLeNSlOaL1H1kY
5dpQ6ujkhrHuh/68G03lo79TifL4pYgQDWQWhXJUwacDbnneDA2W31Jg41fHeAFMv1llP91rqbL4
FJC5CnfzeC2C0OZusEP2qgb6P+mXI/ISv2fHig==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
mmrbn0zbKMgkLzrHrKJOKrgC3HtsZgIpkLjZVcrtvws4wntrdi83uCCueHaxIQ6bXFM54jo+YFAn
Z1k2/quHoQHyyep8a7k4uPk8wUe2UlLn2KCZ8TMFLB+HaIYJ93/rw9droawKlw5IsvonN4hkFVp7
Q3JU9g7BFsSUm2glAL8IGU/Jo+KclhmTG+UmOM6F+ywOHJyXJ5uOSQxn7UVozNkI2PHxX1vh5bsc
IyLIJMJrqHkCCp9QvWhNo7k31DoSfgkzqiUcpyBy7HRwgq57AKgLCZlKm4ovDslhu209ZlJ4YzLw
raM4Q8TAGH8ppftyMfb4l0OJYe8Y9SlT+v/0hw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 21392)
`pragma protect data_block
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
+DfLRelCvTrucVo+eEkn5v4=
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
