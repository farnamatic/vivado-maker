######################################################
# TCL (HLS)
# AUTHOR: FARNAM KHALILI MAYBODI (FKHM)
# COMPANY: UNISI 
# DATE: 2021/10/19
######################################################
set vivado_version $::env(VIVADO_VERSION)
set partNumber $::env(XILINX_PART)
set ip_name "$::env(PROJECT)"
set module_name "$::env(MODULE)"
set clk_period $::env(CLK_PERIOD_NS)
set hdl $::env(HDL_LANGUAGE)


open_project  $ip_name
set_top $module_name
add_files src/$vivado_version/$ip_name.cpp -cflags "-I ../include"
open_solution "rtl" 
set_part $partNumber
create_clock -period $clk_period -name default
config_rtl -reset_level low
csynth_design
export_design -rtl $hdl -format ip_catalog -version "1.0.0"

exit
