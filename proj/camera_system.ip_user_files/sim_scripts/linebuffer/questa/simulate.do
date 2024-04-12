onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib linebuffer_opt

do {wave.do}

view wave
view structure
view signals

do {linebuffer.udo}

run -all

quit -force
