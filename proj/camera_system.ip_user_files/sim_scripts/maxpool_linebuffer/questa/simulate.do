onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib maxpool_linebuffer_opt

do {wave.do}

view wave
view structure
view signals

do {maxpool_linebuffer.udo}

run -all

quit -force
