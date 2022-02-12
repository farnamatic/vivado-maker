# Compress bitstream

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]


# put your constraints here
# these constraints are just for example. they are not necessary proper pins numbers
 
set_property PACKAGE_PIN U2 [get_ports {rstn_i}]
set_property IOSTANDARD LVCMOS18 [get_ports {rstn_i}]

set_property PACKAGE_PIN W1 [get_ports clk_i]
set_property IOSTANDARD LVCMOS18 [get_ports clk_i]

set_property PACKAGE_PIN D11 [get_ports {d_i}]
set_property IOSTANDARD LVCMOS33 [get_ports {d_i}]

set_property PACKAGE_PIN A10 [get_ports {d_o[0]}]
set_property PACKAGE_PIN A11 [get_ports {d_o[1]}]
set_property PACKAGE_PIN A12 [get_ports {d_o[2]}]
set_property PACKAGE_PIN A13 [get_ports {d_o[3]}]
set_property PACKAGE_PIN A14 [get_ports {d_o[4]}]
set_property PACKAGE_PIN A15 [get_ports {d_o[5]}]
set_property PACKAGE_PIN B10 [get_ports {d_o[6]}]
set_property PACKAGE_PIN B11 [get_ports {d_o[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {d_o[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {d_o[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {d_o[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {d_o[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {d_o[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {d_o[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {d_o[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {d_o[7]}]
 
