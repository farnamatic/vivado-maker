#######################################################################################################
# AUTHOR: FARNAM KHALILI MAYBODI
# DATE: 2022/02/05
# The environment variables, and processes are defined here
#######################################################################################################

namespace eval ::FM {

	variable VIVADO_PROJECT
	variable PART_NAME
	variable BOARD_NAME
	variable HDL_LANGUAGE
	variable OOC_MAX_JOBS

	proc print_gvars {} {
      		put $FM::VIVADO_PROJECT
      		put $FM::PART_NAME
      		put $FM::BOARD_NAME
      		put $FM::HDL_LANGUAGE
      		put $FM::OOC_MAX_JOBS
	}

	 # Process to import xci files to the project, and generate
	 # Out of Context (OOC) output products for each IP that is used in the bd design.
	proc run_ooc_ips {} {
	    
	    if {[file exists $FM::VIVADO_PROJECT/$FM::BOARD_NAME-vivado.srcs/sources_1/bd/main_design/ip]} {
	        update_compile_order -fileset sources_1
	        catch {set ip_names [get_ips]}
	        set i 0
	         foreach ip $ip_names {
		           ## gets IPs name as they are instantiated, and the corresponding *.xci files are generated. 
		           if {[file exists $FM::VIVADO_PROJECT/$FM::BOARD_NAME-vivado.srcs/sources_1/bd/main_design/ip/${ip}/${ip}.xci] && 
		               ![file exists $FM::VIVADO_PROJECT/$FM::BOARD_NAME-vivado.runs/${ip}_synth_1/runme.log]  } {
		           	put "Run OOC (Out of Context) IP for: $ip"
		             if {[get_property generate_synth_checkpoint [get_files ${ip}.xci]] == 1 && [get_property is_enabled [get_files ${ip}.xci]] == 1} {
		               create_ip_run [get_files -of_objects [get_fileset sources_1] $FM::VIVADO_PROJECT/$FM::BOARD_NAME-vivado.srcs/sources_1/bd/main_design/ip/${ip}/${ip}.xci]  
		               # it is important to reset the synth_1 before launching the run.
			       reset_run ${ip}_synth_1
			       launch_run -jobs 8 ${ip}_synth_1  
		               if {$i eq ($FM::OOC_MAX_JOBS-1)} {
		               	wait_on_run  ${ip}_synth_1
		               	set i 0	
		               } else {
		               	incr i
		               }
		             }
		           }
	         }
	    }
	}

	proc read_xci {} {
                if {[file exists $FM::VIVADO_PROJECT/$FM::BOARD_NAME-vivado.srcs/sources_1/bd/main_design/ip]} {
                        update_compile_order -fileset sources_1
                        catch {set ip_names [get_ips]}
                        foreach ip $ip_names {
                                put ${ip}
                                read_ip $FM::VIVADO_PROJECT/$FM::BOARD_NAME-vivado.srcs/sources_1/bd/main_design/ip/${ip}/${ip}.xci
                        }
                }
        }



	proc read_user_lib_1 {} {
        	
        	if {[file exists srcs/libs/user_lib_1]} {

        		set vhd_files [glob srcs/libs/user_lib_1/*.vhd]
        		put $vhd_files
        		catch {$vhd_files}
        		foreach vhd $vhd_files {
        	             add_files -norecurse ${vhd}
        	             set_property library user_lib_1 [get_files ${vhd}]
        		}
        	 	update_compile_order -fileset sources_1
        	}

        }


}

set FM::VIVADO_PROJECT $::env(VIVADO_WORK_DIR)
set FM::PART_NAME $::env(XILINX_PART)
set FM::BOARD_NAME $::env(BOARD)
set FM::HDL_LANGUAGE $::env(HDL_LANGUAGE) 
set FM::OOC_MAX_JOBS $::env(OOC_JOBS) 



#######################################################################################################


