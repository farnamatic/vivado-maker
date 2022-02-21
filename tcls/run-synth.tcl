##########################################################################################################################
# DATE:  2022/01/18
# AUTHOR: FARNAM KHALILI MAYBODI
# DESCRIPTION: 
# This tcl file is responsible to synthesize the Vivado project, and open the synthesized design and generate
# appropriate report files based on the specified board (i.e., BOARD) by the user during the "make synth". 
##########################################################################################################################
source tcls/settings.tcl

# check if the project is not opened, then open it
set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
    open_project $FM::VIVADO_PROJECT/$FM::BOARD_NAME-vivado.xpr
}


set_param general.maxThreads 8
set_property target_language $FM::HDL [current_project]

set_msg_config -id {[Synth 8-5858]} -new_severity "info"
set_msg_config -id {[Synth 8-4480]} -limit 1000


FM::read_xci

update_ip_catalog
update_compile_order -fileset sources_1

$synth_design -rtl -name rtl_1 -verbose 

set_property STEPS.SYNTH_DESIGN.ARGS.RETIMING true [get_runs synth_1]
set_property strategy {Vivado Synthesis Defaults} [get_runs synth_1]

reset_run synth_1

launch_runs synth_1
wait_on_run synth_1

open_run synth_1

file mkdir -force reports/
file delete -force reports/*

check_timing -verbose                                                   -file reports/$FM::BOARD_NAME.check_timing.rpt
report_timing -max_paths 100 -nworst 100 -delay_type max -sort_by slack -file reports/$FM::BOARD_NAME.timing_WORST_100.rpt
report_timing -nworst 1 -delay_type max -sort_by group                  -file reports/$FM::BOARD_NAME.timing.rpt
report_utilization -hierarchical                                        -file reports/$FM::BOARD_NAME.utilization.rpt
report_cdc                                                              -file reports/$FM::BOARD_NAME.cdc.rpt
report_clock_interaction  
###########################################################################################################################
