################################################
# AUTHOR: FARNAM KHALILI MAYBODI
# DATE: 2021/10/20
# COMPANY: UNISI 
#
################################################
export XILINX_PART=xczu9eg-ffvc900-1-i-es1	
export VIVADO_VERSION=2016.3
echo chosen fpga part number = $XILINX_PART
echo Vivado Version = $VIVADO_VERSION
export HLS_CLK_PERIOD=20
export HDL=verilog

echo set clock period for hls ips = $HLS_CLK_PERIOD ns
echo set generated rtl language for hls ips = $HDL

