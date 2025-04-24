Vivado Project Handler (maker) 

==============================================================================
## Introduction
After years of working with FPGA products, I always wanted to have an automated project handler through which I can stay away from the GUI as much as possible. 
This may increase the development efficiency expecially when it comes to working with remote servers. However, it is almost impossible to fully ignore the GUI for those projects including block designs. This repository offers a minimalistic Vivado project handler created by TCLs and Makefiles GNU. It has a specific structure in which the user should respect. The IPs are assumed to be in the "ips" folder and it is added as the main path of IP repositories during the Vivado Project creation. it is to be mentioned that the flow and scripts have been inspired from the cva6 project.

The Vivado project creation, Out of Contex (OOC) IP output products generation, synthesize, implementation, bitstream generation, and the reports for each stage,
is considered to be fully automated through the "make" commands. The intention is the user keeps working with the terminal through the "make" commands, and only whenever a block design updates invoked, the GUI can be opened. Then, when the block design is updated, with a particular command ("i.e., make update\_tcl"), the dedicated tcl file as the tcl file of the main design is going to be regenerated, and ready to be git pushed into the repository.






## Feature 

  - This vivado project as an example targets the FPGA used on the **Trenz TE0808-04** (**xczu9eg-ffvc900-1-i-es1**) SoM (System on Module) board, which is deployed in the Gluon board. The Gluon board is a low power carrier board that is designed and built by the Computer Architecture Labratory (lab223) of UNISI (University of Siena).  

## Prerequisite 
  - The Vivado version for this repository is **2016.3**. 
  - Since the target platform (**xczu9eg-ffvc900-1-i-es1**) is not introduced during the version of this project (i.e., 2016), it is important to 
  activate the beta devices for the **Vivado 2016.3** before running the Vivado tool. Otherwise, the current Vivado project with the (**xczu9eg-ffvc900-1-i-es1**) cannot be opened in Vivado 2016.3. 
  - If you run it on the Ubuntu your .bashrc file should be looked like:

```
  export PATH=<your_installation_dir>/Xilinx/Vivado/2016.3/bin:<your_installation_dir>/Xilinx/Vivado_HLS/2016.3/bin
  source /opt/Xilinx/Vivado/2016.3/settings64.sh
``` 

  - If you run it on the Windows 10 OS, the GNU packages are a must! For this purpose, I suggest to use Cygwin, which is a POSIX-compatible programming and runtime environment. As an example: I used MobaXterm, which its terminal is running based on Cygwin, and I installed the required packages (GNU packages) on it to make it working for the Vivado and Makefile ecosystem used in this repository. Then in the running terminal of Cygwin, the .bashrc file should be like:

```
  PATH=/drives/c/Xilinx/Vivado_HLS/2016.3/bin/:/drives/c/Xilinx/Vivado/2016.3/bin:$PATH
  source /drives/c/Xilinx/Vivado/2016.3/settings64.sh
```

### How to enable Beta Devices for the Vivado 2016.3?
  - Linux: create exactly the **init.tcl** file into the `$HOME/.Xilinx/Vivado/2016.3/` with the following command put inside: 

```
  enable_beta_device xczu*
```

  - Windows: follow the above step, just change the destination directory where the **init.tcl** file is put to:

```
  %APPDATA%\Roaming\Xilinx\Vivado\2016.3\init.tcl
```

### How to enable Beta Devices for the HLS 2016.3?

  - Linux: put the above **init.tcl** file into $HOME/.Xilinx/init.tcl
  - Windows: put the above **init.tcl** file into  %APPDATA%\Roaming\Xilinx\init.tcl

## Version Control

  - **v1.0** - initial release:



 
## The Structure

### Generating the IPs 

  - Before generating \*.bit file and exporting the \*.hdf file, we need to generate all the custom IPs used in this vivado project. For this purpose, 
  we follow up the following steps:
    * If we want to generate all the IPs (including HLS and HDL IPs  i.e., hls-ips and vhd-ips), we go to the directory of "ips" then:

```
  <dir-where-you-cloned>/vivado-maker/ips/$  make all BOARD=board1 VIVADO_VERSION=2016.3
```  

  * IF we already generated all the IPs, and now we are in the middle of the developement of one or more than IPs. We can simply just re-generate that IPs, by issuing make command in its corresponding directory. Note: For this purpose we need to set the environment variables of the shell by sourcing the "env_variables.sh" file. For instance:

```
  <dir-where-you-cloned>/vivado-maker/ips/hls-ips/hls_your_ip_1$  source ../../env_variables.sh
  <dir-where-you-cloned>/vivado-maker/ips/hls-ips/hls_your_ip_1$  make all
```
 
### Short description to TCLs

Important note: Your created vivado project is untracked and is not pushed into the repository. Only the tcl files are considered to be pushed. So, remember before commiting your updates on the block design (\*.bd) file, you "must" update the corresponding tcl file of it. 


Two tcl files named **run-vivado-prj** and **run-bd.tcl**, the **"src"** and its contents, as well as the **ip** folder are the only files and folders that are pushed into the repository. The **ip** contains all the custom IPs generated and used in the main vivado project. It is important to generate and build these IPs first, before creating and building the main vivado project. In these folders (i.e., **ips**) and the main vivado project folder (i.e., **board1-vivado**) will be many produced files and folders after the build, which are local and are not alowed to be pushed by a well organized **.gitignore** filter. 

  - **run-vivado-prj.tcl**: This is the main tcl of the vivado project, which is already sourced by the vivado tool in batch mode in the main Makefile. This tcl code is responsible to create the Vivado project with the target platform, and add source files (if possibly existed, for the current Vivado template we do not have any hdl source file). This tcl is a static tcl file. 

  - **gen-bd-tcl.tcl**: This is responsible to create a tcl file from the current block design file (\*.bd), which must be the only source file related to the block design and pushed into the repository. Consequently, it is important that this tcl is run before any commits otherwise, the updates on the block design (\*.bd) file are not made visible and pushed into the remote git repository. Note: It is a must to run this command before any pushes. This tcl is a static tcl file.

  - **design-bd-src.tcl**: This is the result of running the **gen-bd-tcl.tcl** file. This tcl file is always updated (over-written), by running the **gen-bd-tcl.tcl**. This tcl is considered a variable tcl file unlike the two other previous tcl files.


### Working with the make commands

User can control the process of the project through an universal Makefile ecosystem. Here we discuss about these make commands. 

Note: Make sure before issuing the following commands (main vivado project control commands), the IPs are already built into the ips/ folder. 
Because, the **design-bd-src.tcl**  uses their path to instantiate them into the block design of the project.


  * The following command launches the vivado tool in batch mode and executes the "run-vivado-prj.tcl file which, in turn creates a vivado project and sets the target platform to the specified BOARD (e.g., here it is the board1). In the run-vivado-prj.tcl, it also includes the "design-bd-src.tcl", to generate the block design (\*.bd) file. If your vivado project is already created, the terminal prints the message, and this is discarded. 


```
  make vivado BOARD=board1     
```

  * If you already have created the viado project locally, during the developement of the project, you can update 
  the **design-bd-src.tcl** (regenerate), by issuing the following command. The following command will regenerate the "design-bd-src.tcl" file based on the current block design, located into the  board1-vivado/board1-vivado.srcs/bd/. Remember if you do not issue this command, after pushing your repository, your updates applied on the block design previously will not be visible for the remote repository. 

```
  make update_tcl BOARD=board1                       
```
 
 
  * Once you have your design created, or updated, you must generate the output products of included IPs. For this purpose, we issue the following command:


```
  make ip_ooc OOC_JOBS=16                
```


  * Once you have generated all the IPs, we can issue following command to generate the bitstream. The reports are created into the folder named **report**.

```
  make synth
  make impl               
```

<!--   * Cleaning the environment: CAUTIOUS! by issuing the following command your vivado project folder entirely will be deleted and only source codes including the tcl files, and the old block design (bd_old), and the actual block design, will remain into the src/* folder. The tracking to the block design is not done through this block designs but only through the **design-bd-src.tcl**. If you forget to issue the **make update_tcl**, and then clean the environment, you do not loose your modifications on the block design file becasue it is put into a separate folder which is the goal of the clean operation. 

```
  make clean
``` 
 -->


Here is the project directory structure tree:

    
      PROJECT_NAME
          ├── .git
          ├── .gitignore
          ├── README.md
          ├── Makefile                             # Main Makefile of the project  
          ├── tcls/                                # tcl scripts to control the flow of the project
          │     │
          │     ├── design-bd-src.tcl                                       
          │     ├── gen-bd-tcl.tcl
          │     ├── run-impl.tcl 
          │     ├── run-ooc.tcl 
          │     ├── run-synth.tcl 
          │     ├── run-vivado-prj.tcl 
          │     └── settings.tcl 
          │
          │
          │
          ├── ips/                     
          │   ├── env_variables.sh                 # Bash environment variables used for the "ips" generation. 
          │   │                                    # If we run "make" into the sub-directories of the  
          │   │                                    # ips (not main "make" in ips/Makefile), we must source this file.                            
          │   │                                                    
          │   │                                                    
          │   ├── Makefile                         # Main Makefile of the "ips" generation.
          │   │
          │   ├── hls-ips                          # The HLS-based generated IPs. 
          │   │    ├── common.mk                   # Common commands that are used to make each IPs including the 
          │   │    │                               # "vivado_hls" run in batch mode.
          │   │    ├── include/                    # All the headers used in the "hls-ips" sub-directories in each 
          │   │    │                               # *.cpp files.
          │   │    ├── hls_*                       # All of the directories of each IP starts with a "hls_" prefix.
          │   │    │    ├── Makefile               # The sub-directories Makefile, which locally also can be executed
          │   │    │    │                          # (before sourcing the env_variables.sh).
          │   │    │    ├── src/                   # C++ source files for each HLS IPs.
          │   │    │    │     ├── 2016.3           # Vivado HLS 2016.3 compatible C++ source code.
          │   │    │    │     └── 2020.2           # Vivado HLS 2020.2 compatible C++ source code.
          │   │    │    │
          │   │    │    └── tcl/                   # Tcl scripts to control the flow of the Vivado and 
          │   │    │          │                    # Vivado HLS IP synthesis
          │   │    │          ├── run-hls.tcl      # Tcl script which manages the vivado_hls tool.       
          │   │    │          └── run-vivado.tcl   # Tcl script which manages the vivado tool. This is not used in generating this IP. 
          │   │    │
          │   │    └── ...     
          │   │
          │   ├── vhd-ips                          # The HDL-based generated IPs (can be any hdl language).
          │   │                                    # The user should consider the IPs that are wrapped as an IP-XACT here.
          │   │                                    
          │   └── work-fpga                        # Untracked generated IPs in vhdl form.                                            
          │                                       
          │   
          ├── srcs/                                # Possible source files: *.v, *.hdl, *.sv, *.bd, the old block design, and UI (the layout of block design)
          │    │                                   # are stored here.
          │    │     
          │    ├──  bd_old/                        # when issuing "make update_tcl", before updateing the "design-bd-src.tcl", 
          │    │                                   # the current bd file is copied to this folder.
          │    │                                    
          │    │                                    
          │    │                                       
          │    │ 
          │    │ 
          │    └──  stored_ui/                     # the saved/ordered *.ui file which defines the layout of the block design. 
          │             │                          # after generating *.bd from the "gen-bd-tcl.tcl", this file is copied into the  
          │             └──  *.ui                  # board1-vivado.srcs/source_1/bd/my_bd/ui/ 
          │     
          ├── constraints/                         # The constraint files (*.xdc) are stored in this folder.     
          │     
          |
          └── vivado-prj/                          # Untracked generated files, but not considered as part of clean.
              ├── board1-vivado.xpr
              ├── board1-vivado.cache/
              ├── board1-vivado.hw/
              ├── board1-vivado.sim/
              ├── board1-vivado.srcs/
              │    ├── sources_1/
              │    │    ├── bd/                                         # BDs are regenerated from script
              │    │    │    ├── bd/hdl/main_design_wrapper.{v,vhd}     # BD wrappers are also regenerated
              │    │    │    └── ...
              │    │    └── ...
              │    └── ...
              └── ...


