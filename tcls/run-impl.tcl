#########################################################################################################################
# DATE:  2022/01/18
# AUTHOR: FARNAM KHALILI MAYBODI
# DESCRIPTION: 
# This tcl file is responsible to implement (placement, optimization, route, and bitstream generation) the design that 
# is already synthesized. The command to issue this tcl is "make impl".
##########################################################################################################################
source tcls/settings.tcl

# check if the project is not opened, then open it
set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
    open_project $FM::VIVADO_PROJECT/$FM::BOARD_NAME-vivado.xpr
}

set_param general.maxThreads 8
set_property target_language $FM::HDL [current_project]


reset_run impl_1

set_property "steps.place_design.args.directive" "RuntimeOptimized" [get_runs impl_1]
set_property "steps.route_design.args.directive" "RuntimeOptimized" [get_runs impl_1]

launch_runs impl_1
wait_on_run impl_1

launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

open_run impl_1

#output Verilog netlist + SDC for timing simulation
write_verilog -force -mode funcsim $FM::VIVADO_PROJECT/$FM::BOARD_NAME.funcsim.v
write_verilog -force -mode timesim $FM::VIVADO_PROJECT/$FM::BOARD_NAME.timesim.v
write_sdf     -force $FM::VIVADO_PROJECT/$FM::BOARD_NAME.timesim.sdf
#
# # reports
exec mkdir -p reports/
exec rm -rf reports/*
check_timing                                                              -file reports/$FM::BOARD_NAME.check_timing.rpt
report_timing -max_paths 100 -nworst 100 -delay_type max -sort_by slack   -file reports/$FM::BOARD_NAME.timing_WORST_100.rpt
report_timing -nworst 1 -delay_type max -sort_by group                    -file reports/$FM::BOARD_NAME.timing.rpt
report_utilization -hierarchical                                          -file reports/$FM::BOARD_NAME.utilization.rpt

exit
#############################################################################################################################