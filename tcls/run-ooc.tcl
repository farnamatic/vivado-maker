##############################################################################
# DATE:  2022/01/18
# AUTHOR: FARNAM KHALILI MAYBODI
# DESCRIPTION: 
# This tcl file is responsible to generate the output products of the 
# included IPs into the Block Design of the vivado project. Their
# appropriate report files based on the specified board (i.e., BOARD)
# will be generated consequently, into the $BOARD-vivado.runs/$(ip) folder
##############################################################################
source tcls/settings.tcl

# check if the project is not opened, then open it
set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
    open_project $FM::VIVADO_PROJECT/$FM::BOARD_NAME-vivado.xpr
}

set_param general.maxThreads 8
set_property target_language $FM::HDL_LANGUAGE [current_project]

set_msg_config -id {[Synth 8-5858]} -new_severity "info"
set_msg_config -id {[Synth 8-4480]} -limit 1000
 
FM::print_gvars
FM::run_ooc_ips

exit
##############################################################################