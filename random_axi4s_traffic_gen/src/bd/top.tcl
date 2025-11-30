
################################################################
# This is a generated script based on design: top
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2025.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source top_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg400-1
   set_property BOARD_PART tul.com.tw:pynq-z2:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name top

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:vio:3.0\
xilinx.com:inline_hdl:ilconstant:1.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:axi_traffic_gen:3.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: DUT
proc create_hier_cell_DUT { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_DUT() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Monitor -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_LITE_CH1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_MASTER


  # Create pins
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property CONFIG.NUM_SI {1} $smartconnect_0


  # Create instance: diver, and set properties
  set diver [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_traffic_gen:3.0 diver ]
  set_property -dict [list \
    CONFIG.C_ATG_MODE {AXI4-Lite} \
    CONFIG.C_ATG_SYSINIT_MODES {System_Init} \
    CONFIG.C_ATG_SYSTEM_INIT_ADDR_MIF {/home/sam/FPGA/test_projects/random_axi4s_traffic_gen/random_axi4s_traffic_gen.srcs/sources_1/imports/random_axi4s_traffic_gen/addr.coe} \
    CONFIG.C_ATG_SYSTEM_INIT_DATA_MIF {/home/sam/FPGA/test_projects/random_axi4s_traffic_gen/random_axi4s_traffic_gen.srcs/sources_1/imports/random_axi4s_traffic_gen/data.coe} \
  ] $diver


  # Create instance: axi_traffic_gen_0, and set properties
  set axi_traffic_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_traffic_gen:3.0 axi_traffic_gen_0 ]
  set_property -dict [list \
    CONFIG.C_ATG_MODE {AXI4-Stream} \
    CONFIG.C_AXIS_SPARSE_EN {false} \
    CONFIG.C_AXIS_TDATA_WIDTH {24} \
    CONFIG.C_AXIS_TDEST_WIDTH {0} \
    CONFIG.C_AXIS_TID_WIDTH {0} \
    CONFIG.C_AXIS_TUSER_WIDTH {0} \
    CONFIG.C_S_AXI_ARUSER_WIDTH {0} \
    CONFIG.C_S_AXI_AWUSER_WIDTH {0} \
  ] $axi_traffic_gen_0


  # Create interface connections
  connect_bd_intf_net -intf_net axi_traffic_gen_0_M_AXIS_MASTER [get_bd_intf_pins M_AXIS_MASTER] [get_bd_intf_pins axi_traffic_gen_0/M_AXIS_MASTER]
  connect_bd_intf_net -intf_net diver_M_AXI_LITE_CH1 [get_bd_intf_pins diver/M_AXI_LITE_CH1] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net [get_bd_intf_nets diver_M_AXI_LITE_CH1] [get_bd_intf_pins diver/M_AXI_LITE_CH1] [get_bd_intf_pins M_AXI_LITE_CH1]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins axi_traffic_gen_0/S_AXI]

  # Create port connections
  connect_bd_net -net Net1  [get_bd_pins s_axi_aresetn] \
  [get_bd_pins axi_traffic_gen_0/s_axi_aresetn] \
  [get_bd_pins diver/s_axi_aresetn] \
  [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net clk_wiz_0_clk_out1  [get_bd_pins s_axi_aclk] \
  [get_bd_pins diver/s_axi_aclk] \
  [get_bd_pins axi_traffic_gen_0/s_axi_aclk] \
  [get_bd_pins smartconnect_0/aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set sysclk [ create_bd_port -dir I -type clk -freq_hz 125000000 sysclk ]

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [list \
    CONFIG.C_DATA_DEPTH {2048} \
    CONFIG.C_INPUT_PIPE_STAGES {1} \
    CONFIG.C_MON_TYPE {INTERFACE} \
    CONFIG.C_NUM_MONITOR_SLOTS {2} \
    CONFIG.C_SLOT {1} \
    CONFIG.C_SLOT_0_APC_EN {0} \
    CONFIG.C_SLOT_0_AXI_DATA_SEL {1} \
    CONFIG.C_SLOT_0_AXI_TRIG_SEL {0} \
    CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
    CONFIG.C_SLOT_1_APC_EN {0} \
    CONFIG.C_SLOT_1_AXI_AR_SEL_DATA {1} \
    CONFIG.C_SLOT_1_AXI_AR_SEL_TRIG {0} \
    CONFIG.C_SLOT_1_AXI_AW_SEL_DATA {1} \
    CONFIG.C_SLOT_1_AXI_AW_SEL_TRIG {0} \
    CONFIG.C_SLOT_1_AXI_B_SEL_DATA {1} \
    CONFIG.C_SLOT_1_AXI_B_SEL_TRIG {0} \
    CONFIG.C_SLOT_1_AXI_R_SEL_DATA {1} \
    CONFIG.C_SLOT_1_AXI_R_SEL_TRIG {0} \
    CONFIG.C_SLOT_1_AXI_W_SEL_DATA {1} \
    CONFIG.C_SLOT_1_AXI_W_SEL_TRIG {0} \
    CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:aximm_rtl:1.0} \
  ] $system_ila_0


  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT1_JITTER {119.348} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125.000} \
    CONFIG.CLK_IN1_BOARD_INTERFACE {sys_clock} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000} \
    CONFIG.USE_LOCKED {false} \
    CONFIG.USE_RESET {false} \
  ] $clk_wiz_0


  # Create instance: reset, and set properties
  set reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 reset ]
  set_property -dict [list \
    CONFIG.C_NUM_PROBE_IN {0} \
    CONFIG.C_PROBE_OUT0_INIT_VAL {0x0} \
  ] $reset


  # Create instance: DUT
  create_hier_cell_DUT [current_bd_instance .] DUT

  # Create instance: sink, and set properties
  set sink [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant:1.0 sink ]

  # Create interface connections
connect_bd_intf_net -intf_net axi_traffic_gen_0_M_AXIS_MASTER [get_bd_intf_pins DUT/M_AXIS_MASTER] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets axi_traffic_gen_0_M_AXIS_MASTER]
connect_bd_intf_net -intf_net diver_M_AXI_LITE_CH1 [get_bd_intf_pins system_ila_0/SLOT_1_AXI] [get_bd_intf_pins DUT/M_AXI_LITE_CH1]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets diver_M_AXI_LITE_CH1]

  # Create port connections
  connect_bd_net -net Net1  [get_bd_pins reset/probe_out0] \
  [get_bd_pins system_ila_0/resetn] \
  [get_bd_pins DUT/s_axi_aresetn]
  connect_bd_net -net clk_wiz_0_clk_out1  [get_bd_pins clk_wiz_0/clk_out1] \
  [get_bd_pins system_ila_0/clk] \
  [get_bd_pins reset/clk] \
  [get_bd_pins DUT/s_axi_aclk]
  connect_bd_net -net sink_dout  [get_bd_pins sink/dout] \
  [get_bd_pins DUT/M_AXIS_MASTER_tready]
  connect_bd_net -net sysclk_1  [get_bd_ports sysclk] \
  [get_bd_pins clk_wiz_0/clk_in1]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces DUT/diver/Reg1] [get_bd_addr_segs DUT/axi_traffic_gen_0/S_AXI/Reg0] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


