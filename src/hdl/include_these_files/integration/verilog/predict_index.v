`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ���ǰ���������
// 
// Create Date: 2024/01/02 17:31:06
// Design Name: 
// Module Name: predict_index
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
//ȫ���Ӳ������10����������ת�ɴ������ݲ��ұȽϴ�С��Ϊ����ֵ
module predict_index(
    input                   clk,
    input                   rst_n,

    input  [32*3-1:0]      data_in,
    input                   data_in_valid,

    output [3:0]            data_out    //����ֵ��� 0~9
    );

//�Ĵ����������
reg  [31:0] data_in_reg[0:2];
integer i;

always @(posedge clk or negedge rst_n)begin
     if(!rst_n)begin
        for(i=0;i<3;i=i+1)begin
            data_in_reg[i] <= 'd0;
        end
    end
    else if(data_in_valid)begin //data_in_valid���߾ͱ仯һ��data_in
        for(i=0;i<3;i=i+1)begin
            data_in_reg[i] <= data_in[(i)*32+:32];
        end      
    end
end

//data_out cnt�����������
reg [3:0] data_in_cnt;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        data_in_cnt <= 0;
    else if(data_in_cnt == 4'd3)
        data_in_cnt <= 0;
    else if(data_in_cnt != 0)
        data_in_cnt <= data_in_cnt + 1'b1;
    else if(data_in_valid)
        data_in_cnt <= data_in_cnt + 1'b1;   
    else
        data_in_cnt <= data_in_cnt;
end

//���10��ֵ,ʵ�ֲ�ת��
wire [31:0] serial_data;
wire        serial_data_valid;

assign serial_data = data_in_reg[data_in_cnt-1]; //����߼���ֵ
assign serial_data_valid = (data_in_cnt != 0) ? 1'b1:1'b0;


reg         data_in_valid_d1;
reg  [31:0] max_data;
reg  [3:0]  max_data_index;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        data_in_valid_d1 <= 1'b0;
    else
        data_in_valid_d1 <= data_in_valid;
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n || data_in_valid)begin
        max_data       <= 'd0;
        max_data_index <= 'd0;
    end
    else if(data_in_valid_d1)begin  //��һ����ֵ��Ϊ���ֵ
        max_data       <= serial_data;
        max_data_index <= 4'd0;
    end
    else if(serial_data_valid)begin
        if(max_data[31] == 0 && serial_data[31] == 0)begin //ͬΪ����
            if(max_data > serial_data)begin
                max_data       <= max_data;
                max_data_index <= max_data_index;
            end
            else begin
                max_data       <= serial_data;
                max_data_index <= data_in_cnt - 1'b1;
            end
        end
        else if(max_data[31] == 1 && serial_data[31] == 0)begin  //һ��һ��
                max_data       <= serial_data;
                max_data_index <= data_in_cnt - 1'b1;
        end
        else if(max_data[31] == 0 && serial_data[31] == 1)begin  //һ��һ��
                max_data       <= max_data;
                max_data_index <= max_data_index;
        end 
        else begin  //ͬΪ����
            if(max_data > serial_data)begin
                max_data       <= max_data;
                max_data_index <= max_data_index;
            end
            else begin
                max_data       <= serial_data;
                max_data_index <= data_in_cnt - 1'b1;
            end
        end
    end
    else begin
        max_data       <= max_data;
        max_data_index <= max_data_index;
    end
end

assign data_out = max_data_index;

endmodule
