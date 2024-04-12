onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fifo_data_buffer_opt

do {wave.do}

view wave
view structure
view signals

do {fifo_data_buffer.udo}

run -all

quit -force
