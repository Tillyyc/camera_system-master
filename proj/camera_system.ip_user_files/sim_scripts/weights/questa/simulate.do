onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib weights_opt

do {wave.do}

view wave
view structure
view signals

do {weights.udo}

run -all

quit -force
