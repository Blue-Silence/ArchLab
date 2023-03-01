# Clock signal
set_property PACKAGE_PIN W5 [get_ports FPGACLK]
set_property IOSTANDARD LVCMOS33 [get_ports FPGACLK]
create_clock -period 10 -waveform {0 5} [get_ports FPGACLK]

# Push button for reset
set_property PACKAGE_PIN U18 [get_ports RESET]
set_property IOSTANDARD LVCMOS33 [get_ports RESET]

# 7 segment cathodes
# A
set_property PACKAGE_PIN W7 [get_ports LED[0]]
# B
set_property PACKAGE_PIN W6 [get_ports LED[1]]
# C
set_property PACKAGE_PIN U8 [get_ports LED[2]]
# D
set_property PACKAGE_PIN V8 [get_ports LED[3]]
# E
set_property PACKAGE_PIN U5 [get_ports LED[4]]
# F
set_property PACKAGE_PIN V5 [get_ports LED[5]]
# G
set_property PACKAGE_PIN U7 [get_ports LED[6]]
set_property IOSTANDARD LVCMOS33 [get_ports LED]

# 7 segment anodes (active low)
set_property PACKAGE_PIN U2 [get_ports AN[0]]
# AN0
set_property PACKAGE_PIN U4 [get_ports AN[1]]
# AN1
set_property PACKAGE_PIN V4 [get_ports AN[2]]
# AN2
set_property PACKAGE_PIN W4 [get_ports AN[3]]
# AN3
set_property IOSTANDARD LVCMOS33 [get_ports AN]

# TODO PART II for Lab 8
# add input port to read the switch value for speed control of the snake
