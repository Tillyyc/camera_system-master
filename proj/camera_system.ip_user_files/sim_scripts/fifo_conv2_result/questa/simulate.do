onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fifo_conv2_result_opt

do {wave.do}

view wave
view structure
view signals

do {fifo_conv2_result.udo}

run -all

quit -force
