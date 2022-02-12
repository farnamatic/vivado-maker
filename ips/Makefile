#############################################################
# Date: 2021/01/15
# AUTHOR: FARNAM KHALILI MAYBODI
# Description: Universal Makefile for the XSMLL IPs targeting various 
# FPGA boards including the AXIOM, GLUON and the GENESYS2 with various Vivado
# Versions 


BOARD          ?= board1
#BOARD          ?= board2
#BOARD          ?= board3
 

VIVADO_VERSION  ?=2016.3
# VIVADO_VERSION  ?=2020.2

include .make_ip_list.env
 
HLS_IP_DIR := hls-ips
VHD_IP_DIR := vhd-ips

FPGA_WORK_DIR := work-fpga

export HLS_IP_DIR
export VHD_IP_DIR
export FPGA_WORK_DIR


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


hls_ips := $(addprefix $(FPGA_WORK_DIR)/, $(hls_ips))
hls-ips-target := $(join $(addsuffix /ip/, $(addprefix $(HLS_IP_DIR)/, $(basename $(hls_ips)))), $(hls_ips))

vhd_ips := $(addprefix $(FPGA_WORK_DIR)/, $(vhd_ips))
vhd-ips-target := $(join $(addsuffix /ip/, $(addprefix $(VHD_IP_DIR)/, $(basename $(vhd_ips)))), $(vhd_ips))

all: $(vhd_ips) $(hls_ips)
 
$(hls_ips): %.vhd : $(vhd_ips)
	mkdir -p $(FPGA_WORK_DIR)
	@echo Generating $(@F) with Vivado Version $(VIVADO_VERSION)
	@cd $(HLS_IP_DIR)/$(basename $(@F)) && make clean && make BOARD=$(BOARD) XILINX_PART=$(XILINX_PART) CLK_PERIOD_NS=$(CLK_PERIOD_NS) VIVADO_VERSION=$(VIVADO_VERSION)
	@cp $(HLS_IP_DIR)/$(basename $(@F))/$(basename $(@F))/rtl/impl/ip/hdl/vhdl/$(@F:hls_%=%) $@ 


$(vhd_ips): %.vhd : 
	mkdir -p $(FPGA_WORK_DIR)
	@echo Generating $(@F) with Vivado Version $(VIVADO_VERSION)
	@cd $(VHD_IP_DIR)/$(basename $(@F)) && make clean && make BOARD=$(BOARD) XILINX_PART=$(XILINX_PART) CLK_PERIOD_NS=$(CLK_PERIOD_NS) VIVADO_VERSION=$(VIVADO_VERSION)
	@cp $(VHD_IP_DIR)/$(basename $(@F))/$(basename $(@F)).srcs/sources_1/imports/src/$(@F) $@

clean:
	@echo Clean work-fpga 
	@rm -rf $(FPGA_WORK_DIR)
	@rm -f *.log *.jou *.str

