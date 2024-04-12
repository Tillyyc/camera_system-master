# ECE 532 Project - Rock, Paper, Scissors 
## Project Overview
In the digital domain, hand gesture recognition plays a vital role in conveying diverse messages, facilitated by advancements in imaging technology and image processing algorithms. Real-time identification of hand gestures has become feasible, with applications extending into various domains, including gaming. Rock Paper Scissors is a timeless and universally recognised game, serving as a go-to choice for decision-making scenarios where fairness and unpredictability are key. This zero-sum game is characterized by hand gestures representing rock, paper, and scissors. <br>
**Our design includes 5 parts: **
1. vga camera
2. hdmi ouput
3. image compressor and grayscaler
4. CNN accelerator module
5. rock paper scissor game logic v.s computer
## Resources and equipment
- **Hardware:**<br>
1. Nexys Video Board 
2. Ov7670 Camera Module 
3. HDMI Cable 
4. Vivado 2018.3 <br>
- **Software:**<br>
1. Google Colab <br>
2. Pytorch <br>

## Design Tree & File Description
top.v //top module that instaniate all the following modules
1. divider_2.v //clock divider clk50
2. divider_4.v //clock divider clk23
3. debounce_inputs.v
4. game_master/state_machine.v //game logic
6. hmdi_ctrl.v //for hdmi output
8. uart.v 
9. sccb.v //for camera input
10. cmos_capture_data.v //send data to CNN
11. rgb2bin_process.v //grayscale the image
12. key_debunce.v
13. Mini_LeNet //CNN module
    1. conv1
    2. maxpool1
    3. conv2
    4. maxpool2
    5. reshape
    6. linear
    7. predict 
## How to Run
1. download and open .xpr file in the project folder
2. synthesize
3. implement
4. generate bit stream
5. load to FPGA board
## CNN training (Pytorch) & weights files
[Training file](CNNPythonFiles/rps_v4_pytorch.ipynb) <br>
[Weights](CNNPythonFiles/weights)
## CNN Accelerator Testbench
[CNN testbench](testbenches/tb_conv.v)
The results can be observed in the waveform.
## Related Links
Slides: [FinalDemo_Slides_Group14.pdf](Documents/FinalDemo_Slides_Group14.pdf) <br>
Reports: <br>
Youtube Video Demo: [rps video - gesture detection part](https://www.youtube.com/watch?v=sVDGybcSSL8)

 
