`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ���ǰ���������
// 
// Create Date: 2024/01/01 20:56:52
// Design Name: 
// Module Name: Mini_LeNet
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
module Mini_LeNet(
    input               clk,
    input               rst_n,

    input  [7:0]        data_in,
    input               data_in_valid,

    output [3:0]        data_out    //Ԥ������ֵ
    );


//��������
reg  [9:0] wr_addr;
reg  [9:0] rd_addr;
wire [7:0] ram_data;
reg        net_busy;  //���緱æ�ź�,��������һ֡ͼ��ʱ����,�ȴ�Ԥ����������

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        wr_addr <= 10'd0;
    else if(wr_addr == 784 - 1 && data_in_valid)    //д��һ֡�����һ��������Ч�����ַ
        wr_addr <= 10'd0;
    else if(data_in_valid)
        wr_addr <= wr_addr + 1'b1;
    else
        wr_addr <= wr_addr;
end

//�ϵ��ȴ�һ֡д�����
reg  wait_flag;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        wait_flag <= 1'b0;
    else if(wr_addr == 10)
        wait_flag <= 1'b1;
    else
        wait_flag <= wait_flag;
end
 

//�����ϸ���Ҫ����ƹ�Ҳ���,��Ϊ��ȡ���ٶ�Ҫ����д����ٶ�
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        rd_addr <= 10'd0;
    else if(wait_flag)begin
        if(rd_addr == 800)
            rd_addr <= 10'd0;
        else if(net_busy == 0)  //��ǰ���粻��æ
            rd_addr <= rd_addr + 1'b1;
        else 
            rd_addr <= rd_addr;
    end
    // else if(rd_addr == 800)
    //     rd_addr <= 10'd0;
    // else if(net_busy == 0)  //��ǰ���粻��æ
    //     rd_addr <= rd_addr + 1'b1;
    // else 
    //     rd_addr <= rd_addr;
end

wire linear_out_valid;  //ȫ���Ӳ��������
reg  [9:0] busy_cnt; //����600��ʱ��

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        busy_cnt <= 'd0;
    else if(busy_cnt == 600)
        busy_cnt <= 'd0;
    else if(net_busy)
        busy_cnt <= busy_cnt + 1'b1;
    else
        busy_cnt <= busy_cnt;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        net_busy <= 1'b0;
    else if(linear_out_valid) //��ǰ֡Ԥ�����,���Խ�����һ֡
    // else if(busy_cnt == 600)
        net_busy <= 1'b0;
    else if(rd_addr == 800) //����һ֡ͼ��
        net_busy <= 1'b1;
    else 
        net_busy <= net_busy;
end

ram_data_in ram_data_in_inst0(
    .clka           (clk),    // input wire clka
    .wea            (data_in_valid),      // input wire [0 : 0] wea
    .addra          (wr_addr),  // input wire [9 : 0] addra
    .dina           (data_in),    // input wire [7 : 0] dina
    .clkb           (clk),    // input wire clkb
    .addrb          (rd_addr),  // input wire [9 : 0] addrb
    .doutb          (ram_data)  // output wire [7 : 0] doutb
);

wire ram_data_valid;
// wire ram_data_temp;
// reg  ram_data_temp_d1;
assign ram_data_valid = (rd_addr >= 1 && rd_addr <= 784) ? 1 : 0;
// assign ram_data_valid = ram_data_temp || ram_data_temp_d1;  //784����������

// always @(posedge clk or negedge rst_n)begin
//     if(!rst_n)
//         ram_data_temp_d1 <= 1'b0;
//     else
//         ram_data_temp_d1 <= ram_data_temp;
// end

//��һ������
wire [23:0] conv1_out_1;
wire [23:0] conv1_out_2;
wire [23:0] conv1_out_3;
wire        conv1_out_valid;

conv1 conv1(
    .clk            (clk                ),
    .rst_n          (rst_n              ),

    .data_in        (ram_data           ),
    .data_in_valid  (ram_data_valid     ),

    .data_out_1     (conv1_out_1        ),
    .data_out_2     (conv1_out_2        ),
    .data_out_3     (conv1_out_3        ),
    .data_out_valid (conv1_out_valid    )
    );

//��һ�����ػ���
wire [23:0] maxpool1_out_1;
wire [23:0] maxpool1_out_2;
wire [23:0] maxpool1_out_3;
wire        maxpool1_out_valid;

maxpool #(
    .DATA_WIDTH     (24                 ),
    .DISP_WIDTH     (26                 )
)maxpool1(
    .clk            (clk                ),
    .rst_n          (rst_n              ),

    .data_in_1      (conv1_out_1        ),
    .data_in_2      (conv1_out_2        ),
    .data_in_3      (conv1_out_3        ),
    .data_in_valid  (conv1_out_valid    ),

    .data_out_1     (maxpool1_out_1     ),
    .data_out_2     (maxpool1_out_2     ),
    .data_out_3     (maxpool1_out_3     ),
    .data_out_valid (maxpool1_out_valid )
    );

//�ڶ�������
wire [31:0] conv2_out_1;
wire [31:0] conv2_out_2;
wire [31:0] conv2_out_3;
wire        conv2_out_valid;

conv2 conv2(
    .clk            (clk                ),
    .rst_n          (rst_n              ),
    .predict_end    (linear_out_valid   ),  //fifo��λ

    .data_in_1      (maxpool1_out_1     ),
    .data_in_2      (maxpool1_out_2     ),
    .data_in_3      (maxpool1_out_3     ),
    .data_in_valid  (maxpool1_out_valid ),

    .data_out_1     (conv2_out_1        ),
    .data_out_2     (conv2_out_2        ),
    .data_out_3     (conv2_out_3        ),
    .data_out_valid (conv2_out_valid    )
    );

//�ڶ������ػ���
wire [31:0] maxpool2_out_1;
wire [31:0] maxpool2_out_2;
wire [31:0] maxpool2_out_3;
wire        maxpool2_out_valid;
maxpool #(
    .DATA_WIDTH     (32                 ),
    .DISP_WIDTH     (10                 )
)maxpool2(
    .clk            (clk                ),
    .rst_n          (rst_n              ),

    .data_in_1      (conv2_out_1        ),
    .data_in_2      (conv2_out_2        ),
    .data_in_3      (conv2_out_3        ),
    .data_in_valid  (conv2_out_valid    ),

    .data_out_1     (maxpool2_out_1     ),
    .data_out_2     (maxpool2_out_2     ),
    .data_out_3     (maxpool2_out_3     ),
    .data_out_valid (maxpool2_out_valid )
    );

//reshape��
wire [31:0] reshape_data_out;
wire        reshape_data_out_valid;
reshape reshape(
    .clk            (clk                ),
    .rst_n          (rst_n              ),
    .predict_end    (linear_out_valid   ),

    .data_in_1      (maxpool2_out_1     ),  //����5*5
    .data_in_2      (maxpool2_out_2     ),
    .data_in_3      (maxpool2_out_3     ),
    .data_in_valid  (maxpool2_out_valid ),

    .data_out       (reshape_data_out   ),
    .data_out_valid (reshape_data_out_valid)
    );

//ȫ���Ӳ�
wire [32*10-1:0] linear_out;

linear linear(
    .clk            (clk                ),
    .rst_n          (rst_n              ),

    .data_in        ((reshape_data_out >> 16)),
    .data_in_valid  (reshape_data_out_valid),

    .data_out       (linear_out         ),
    .data_out_valid (linear_out_valid   )
    );

//ila_0 ila_0 (
//	.clk(clk), // input wire clk
	
//	.probe0(ram_data_valid), // input wire [0:0]  probe0  
//	.probe1(ram_data), // input wire [7:0]  probe1 
//	.probe2(linear_out_valid), // input wire [9:0]  probe2 
//	.probe3(predict_index_inst0.serial_data),
//	.probe4(rd_addr)
//);

//ȫ���Ӳ�������ݱȽϴ�С�����Ԥ������ֵ
predict_index predict_index_inst0(
    .clk            (clk                ),
    .rst_n          (rst_n              ),

    .data_in        (linear_out         ),
    .data_in_valid  (linear_out_valid   ),

    .data_out       (data_out           )   //����ֵ��� 0~9
    );

endmodule
