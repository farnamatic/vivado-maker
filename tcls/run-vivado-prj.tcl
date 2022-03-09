##################################################################################
# DATE:  2022/01/18
# AUTHOR: FARNAM KHALILI MAYBODI
# DESCRIPTION: 
# This tcl file is responsible to create a vivado project, select the part number 
# based on the specified board (i.e., BOARD) by the user during the "make vivado"
# command. It is also respnsible to source the stored tcl of "*.bd", and 
# eventually, wrap it based on selected default hdl language
##################################################################################
source tcls/settings.tcl

set project $FM::BOARD_NAME-vivado 
create_project $project $FM::VIVADO_PROJECT/ -force -part $FM::PART_NAME
set_param general.maxThreads 8
set_property target_language $FM::HDL [current_project]

set_msg_config -id {[Synth 8-5858]} -new_severity "info"
set_msg_config -id {[Synth 8-4480]} -limit 1000

reset_run synth_1
reset_run impl_1
reset_project


put $FM::PART_NAME
put $FM::BOARD_NAME

if {$FM::BOARD_NAME == "board1"} {
      add_files -fileset constrs_1 -norecurse constraints/board1_constraints.xdc
} elseif {$FM::BOARD_NAME == "board2"} {
      add_files -fileset constrs_1 -norecurse constraints/board2_constraints.xdc
} else {
	exit 1
}      	        
			     		       
# you should put all your custom IPs into the folder "ips"
set_property  ip_repo_paths  { \
                              ips \
                              } [current_fileset]
update_ip_catalog

# if your poroject has a block design, please add 
# its tcl file here:
#building the block design. 
source tcls/design-bd-src.tcl


#if your project has HDL libraries please add here with the specific tcl proc that we defined: 
#example:
#FM::read_user_lib_1
#FM::read_user_lib_2


#if there are source files
#please add your *.vhd *.sv, *.v sources 
#here. 
# source add_sources.tcl
#if your design does not include block design, you must specify the top module of your design here:
# set_property top <the entity name of your top module hdl code> [current_fileset]

# if your design contains block design, it is better to automatically create the wrapper for it and make it top module:
make_wrapper -files [get_files $FM::VIVADO_PROJECT/$FM::BOARD_NAME-vivado.srcs/sources_1/bd/main_design/main_design.bd] -top
if {[get_property target_language [current_project]] eq "VHDL"} {
      add_files -norecurse  $FM::VIVADO_PROJECT/$FM::BOARD_NAME-vivado.srcs/sources_1/bd/main_design/hdl/main_design_wrapper.vhd
} else {
      add_files -norecurse  $FM::VIVADO_PROJECT/$FM::BOARD_NAME-vivado.srcs/sources_1/bd/main_design/hdl/main_design_wrapper.v
}
update_compile_order -fileset sources_1

exit
##################################################################################
