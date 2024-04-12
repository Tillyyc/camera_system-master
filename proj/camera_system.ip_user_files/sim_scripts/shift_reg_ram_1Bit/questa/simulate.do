onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib shift_reg_ram_1Bit_opt

do {wave.do}

view wave
view structure
view signals

do {shift_reg_ram_1Bit.udo}

run -all

quit -force
