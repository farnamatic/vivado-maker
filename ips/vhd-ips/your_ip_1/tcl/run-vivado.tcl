###############################################################################################
# TCL (VIVADO)
# AUTHOR: FARNAM KHALILI MAYBODI (FKHM)
# DATE: 2021/10/20
###############################################################################################
set partNumber $::env(XILINX_PART)
set ipName $::env(PROJECT)
set moduleName $::env(MODULE)

create_project $ipName . -force -part $partNumber
set_property target_language VHDL [current_project]
import_files -norecurse src/$ipName.vhd  

update_compile_order -fileset sources_1

ipx::package_project -root_dir $ipName  -vendor xilinx.com -library user -taxonomy /UserIP
set_property core_revision 2 [ipx::current_core]

ipx::add_file_group -type utility {} [ipx::current_core]
ipx::add_file ../../unisi.png [ipx::get_file_groups xilinx_utilityxitfiles -of_objects [ipx::current_core]]
set_property type image [ipx::get_files ../../unisi.png -of_objects [ipx::get_file_groups xilinx_utilityxitfiles -of_objects [ipx::current_core]]]
set_property type LOGO [ipx::get_files ../../unisi.png -of_objects [ipx::get_file_groups xilinx_utilityxitfiles -of_objects [ipx::current_core]]]


# if your IP does have an AXI port, it is mandatory to associate the proper clock of IP to that 
# interface, otherwise the FREQ_HZ parameter is not propagated to that interface. 
# Assuming the name of interface is "s_axi_registers" and the clock port is "ap_clk" we have:
#ipx::associate_bus_interfaces -busif s_axi_registers -clock ap_clk [ipx::current_core]

ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property  ip_repo_paths  $ipName [current_project]

update_ip_catalog
###############################################################################################
