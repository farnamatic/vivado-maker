#####################################################################################################
# DATE: 2021/01/15
# AUTHOR: FARNAM KHALILI MAYBODI
# DESCRIPTION: 
# Universal Makefile for handling a vivado project from IP design, generation,
# packaging IPs, vivado project creation, IP OOC (Out of Context) runs, synthesize
# implementation, bitstream generation, report generation, for target board defined
# by the user through the $BOARD.
# The following environment variable can be set by the user:
BOARD          ?= board1
#BOARD          ?= board2
#BOARD          ?= board3
VIVADO_VERSION  ?=2016.3
# VIVADO_VERSION  ?=2020.2
HDL_LANGUAGE    ?= VHDL
OOC_JOBS        ?= 16
# setting additional xilinx board parameters for the selected board
ifeq ($(BOARD), board1)
	XILINX_PART              := xczu9eg-ffvc900-1-i-es1
	CLK_PERIOD_NS            := 20
else ifeq ($(BOARD), board2)
	XILINX_PART              := xczu9eg-ffvc900-1-e-es2
	CLK_PERIOD_NS            := 20
else ifeq  ($(BOARD), board3)
	XILINX_PART              := xc7k325tffg900-2
	XILINX_BOARD             := digilentinc.com:genesys2:part0:1.1
	CLK_PERIOD_NS            := 20
else
$(error Unknown board - please specify a supported FPGA board)
endif
######################################################################################################


######################################################################################################
# Do not touch from here:
######################################################################################################
HLS_IP_DIR := hls-ips
VHD_IP_DIR := vhd-ips
VIVADO_WORK_DIR := vivado-prj

export HLS_IP_DIR
export VHD_IP_DIR
export XILINX_PART
export BOARD
export VIVADO_WORK_DIR
export HDL_LANGUAGE
export OOC_JOBS

all: impl
 
vivado: custom_ips 
	@echo Creating Vivado Project 
	@mkdir -p ${VIVADO_WORK_DIR}
	@cd ${VIVADO_WORK_DIR} 
	vivado -mode batch -source tcls/run-vivado-prj.tcl  -nolog -nojournal 
	@mkdir -p ${VIVADO_WORK_DIR}/${BOARD}-vivado.srcs/sources_1/bd/main_design/ui
	@cp srcs/stored_ui/* ${VIVADO_WORK_DIR}/${BOARD}-vivado.srcs/sources_1/bd/main_design/ui/

update_tcl:
	@echo Updating the tcls/design-bd-src.tcl
	@cd ${VIVADO_WORK_DIR}
	cp ${VIVADO_WORK_DIR}/${BOARD}-vivado.srcs/sources_1/bd/main_design/main_design.bd srcs/bd_old/
	cp ${VIVADO_WORK_DIR}/${BOARD}-vivado.srcs/sources_1/bd/main_design/ui/* srcs/stored_ui/
	vivado -mode batch -source tcls/gen-bd-tcl.tcl  -nolog -nojournal

ip_ooc: vivado
	@echo Synthesizing the project
	@cd ${VIVADO_WORK_DIR}
	vivado -mode batch -source tcls/run-ooc.tcl -nolog -nojournal 
	wait; 

synth: ip_ooc
	@echo Synthesizing the project
	vivado -mode batch -source tcls/run-synth.tcl -nolog -nojournal 

impl: synth
	@echo Implementating the project
	vivado -mode batch -source tcls/run-impl.tcl -nolog -nojournal



hdf:
	@echo Exporting HDF file ....
	@test -s ${VIVADO_WORK_DIR}/${BOARD}-vivado.runs/impl_1/main_design_wrapper.sysdef || { echo "system definistion file does not exist! Exiting..."; false; } && \
                 mkdir -p ${VIVADO_WORK_DIR}/${BOARD}-vivado.sdk && \
                 cp ${VIVADO_WORK_DIR}/${BOARD}-vivado.runs/impl_1/main_design_wrapper.sysdef ${VIVADO_WORK_DIR}/${BOARD}-vivado.sdk/main_design_wrapper.hdf
	@echo HDF file is created as ${VIVADO_WORK_DIR}/${BOARD}-vivado.sdk/main_design_wrapper.hdf


custom_ips:
	@echo Make IPs which are located into the folder "ips" 
	@cd ips && make all 

clean:
	@echo Clean ...
	rm -rf *.log *.jou .Xil 
	@cd ips && make clean
       	
########################################################################################################
