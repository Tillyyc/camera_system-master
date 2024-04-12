`timescale 1ns / 1ps

module tb_conv(

    );

reg  clk;
reg  rst_n;

reg  [7:0] data_in;
reg  data_in_valid;
integer file,i;

initial begin
    clk = 1'b0;
    forever begin
        #10 clk = ~clk;
    end
end

initial begin
    rst_n = 1'b0;
    data_in_valid = 0;
    data_in = 0;
    #100
    rst_n = 1'b1;
    #100
    
    file = $fopen("rpsRock1.txt","rb"); //MODIFY the path!!
    if(file == 0)begin
        $display("[-] error");
        $stop;
    end
    for(i=0;i<785;i=i+1)begin
        @(posedge clk);
        $fscanf(file,"%b",data_in);
        data_in_valid <= 1;
    end
    data_in_valid <= 1'b0;
    $fclose(file);
end

 wire [3:0] predict_index;
Mini_LeNet Mini_LeNet(
    .clk            (clk    ),
    .rst_n          (rst_n  ),

    .data_in        (data_in),
    .data_in_valid  (data_in_valid),

    .data_out       (predict_index)
    );

// wire [23:0] conv1_out_1;
// wire [23:0] conv1_out_2;
// wire [23:0] conv1_out_3;
// wire        conv1_out_valid;
// conv1 conv1(
//     .clk            (clk    ),
//     .rst_n          (rst_n  ),

//     .data_in        (data_in),
//     .data_in_valid  (data_in_valid),

//     .data_out_1     (conv1_out_1), 
//     .data_out_2     (conv1_out_2),
//     .data_out_3     (conv1_out_3),
//     .data_out_valid (conv1_out_valid)
//     );

////    // Output display
////    always @(posedge clk) begin
////        if (conv1_out_valid) begin
////            $display("conv1_out_1 = %d\n conv1_out_2 = %d\n conv1_out_3 = %d\n", conv1_out_1, conv1_out_2, conv1_out_3);
////        end
////    end

// wire [23:0] maxpool1_out_1;
// wire [23:0] maxpool1_out_2;
// wire [23:0] maxpool1_out_3;
// wire        maxpool1_out_valid;
// maxpool #(
//     .DATA_WIDTH     (24     ),
//     .DISP_WIDTH     (26     )
// )maxpool1(
//     .clk            (clk    ),
//     .rst_n          (rst_n  ),

//     .data_in_1      (conv1_out_1),
//     .data_in_2      (conv1_out_2),
//     .data_in_3      (conv1_out_3),
//     .data_in_valid  (conv1_out_valid),

//     .data_out_1     (maxpool1_out_1),
//     .data_out_2     (maxpool1_out_2),
//     .data_out_3     (maxpool1_out_3),
//     .data_out_valid (maxpool1_out_valid)
//     );

// wire [31:0] conv2_out_1;
// wire [31:0] conv2_out_2;
// wire [31:0] conv2_out_3;
// wire        conv2_out_valid;
// conv2 conv2(
//     .clk            (clk    ),
//     .rst_n          (rst_n  ),

//     .data_in_1      (maxpool1_out_1),  //è¾“å…¥13*13
//     .data_in_2      (maxpool1_out_2),
//     .data_in_3      (maxpool1_out_3),
//     .data_in_valid  (maxpool1_out_valid),

//     .data_out_1     (conv2_out_1    ),
//     .data_out_2     (conv2_out_2    ),
//     .data_out_3     (conv2_out_3    ),
//     .data_out_valid (conv2_out_valid)
//     );

// wire [31:0] maxpool2_out_1;
// wire [31:0] maxpool2_out_2;
// wire [31:0] maxpool2_out_3;
// wire        maxpool2_out_valid;
// maxpool #(
//     .DATA_WIDTH     (32     ),
//     .DISP_WIDTH     (10     )
// )maxpool2(
//     .clk            (clk    ),
//     .rst_n          (rst_n  ),

//     .data_in_1      (conv2_out_1    ),
//     .data_in_2      (conv2_out_2    ),
//     .data_in_3      (conv2_out_3    ),
//     .data_in_valid  (conv2_out_valid),

//     .data_out_1     (maxpool2_out_1),
//     .data_out_2     (maxpool2_out_2),
//     .data_out_3     (maxpool2_out_3),
//     .data_out_valid (maxpool2_out_valid)
//     );

// wire [31:0] reshape_data_out;
// wire        reshape_data_out_valid;
// reshape reshape(
//     .clk            (clk    ),
//     .rst_n          (rst_n  ),

//     .data_in_1      (maxpool2_out_1),  //è¾“å…¥5*5
//     .data_in_2      (maxpool2_out_2),
//     .data_in_3      (maxpool2_out_3),
//     .data_in_valid  (maxpool2_out_valid),

//     .data_out       (reshape_data_out),
//     .data_out_valid (reshape_data_out_valid)
//     );

// wire [160-1:0] data_out;
// wire           data_out_valid;
// linear linear(
//     .clk            (clk    ),
//     .rst_n          (rst_n  ),

//     .data_in        ((reshape_data_out >> 16)),
//     .data_in_valid  (reshape_data_out_valid),

//     .data_out       (),
//     .data_out_valid ()
//     );

endmodule
