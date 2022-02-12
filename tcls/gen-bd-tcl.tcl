####################################################################################################
# AUTHOR: FARNAM KHALILI MAYBODI
# DATE: 2022/01/21
# This tcl is sourced from the main Makefile, and 
# The main purpose of it is to open the block design, create 
# a tcl file from the latest block design (should be verified before by the 
# user) then close it. This tcl should be issued when
# the user wants to issue "git push" , becuase in the 
# .gitignore we have ignored to push all generated output files as 
# well as $BOARD-vivado.src/source_1/bd/main_design folder!
# So, this is a must procedure before doing git push,  otherwise you loose latest updates of your .bd 
####################################################################################################
source tcls/settings.tcl

# check if the project is not opened, then open it
set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
    open_project $FM::VIVADO_PROJECT/$FM::BOARD_NAME-vivado.xpr
}

open_bd_design $FM::VIVADO_PROJECT/$FM::BOARD_NAME-vivado.srcs/sources_1/bd/main_design/main_design.bd

# before generting the block design it is required that the design validated.
validate_bd_design -force

# generate equivalent tcl scripts of the block design. (overwrite the existing tcl file)
write_bd_tcl tcls/design-bd-src.tcl -force

save_bd_design  [current_bd_design]
close_bd_design  [current_bd_design] 

exit 
#####################################################################################################