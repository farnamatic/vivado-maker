##########################################################
# AUTHOR:: FARNAM KHALILI MAYBODI
# DATE: 2021/10/21
#########################################################
all: vivado

vivado:
	mkdir -p ${PROJECT}
	vivado -mode batch -source tcl/run-vivado.tcl


clean:
	@echo "Clean in sub-directory of IP: ${PROJECT}"
	@rm -f hs_err_pid*
	@rm -rf ${PROJECT}*
	@rm -rf xgui
	@rm -rf component.xml
	@rm -rf vivado*.jou
	@rm -rf vivado*.log
	@rm -rf vitis*.log
	@rm -rf vivado*.str
	@rm -rf .Xil
	@rm -rf solution1/.autopilot 
	@rm -rf solution1/.debug
	@rm -rf package_prj
	@rm -rf web*
