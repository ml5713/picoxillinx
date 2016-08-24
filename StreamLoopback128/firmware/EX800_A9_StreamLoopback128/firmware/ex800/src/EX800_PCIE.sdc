
#Create 100 Mhz 10ns clock
create_clock -period 10 -name sys_clk_p [get_ports sys_clk_p]

#Create 200 Mhz 10ns clock
create_clock -period 5 -name extra_clk_p [get_ports extra_clk_p]

# derive_pll_clock is used to calculate all clock derived from PCIe refclk
#  the derive_pll_clocks and derive clock_uncertainty should only
# be applied once across all of the SDC files used in a project
derive_pll_clocks -create_base_clocks
derive_clock_uncertainty

##############################################################################
# PHY IP reconfig controller constraints
# Set reconfig_xcvr clock
# this line will likely need to be modified to match the actual clock pin name
# used for this clock, and also changed to have the correct period set for the actually used clock
#create_clock -period "125 MHz" -name {reconfig_xcvr_clk} {*reconfig_xcvr_clk*}

######################################################################
# HIP Soft reset controller SDC constraints
set_false_path -to   [get_registers *altpcie_rs_serdes|fifo_err_sync_r[0]]
set_false_path -from [get_registers *sv_xcvr_pipe_native*] -to [get_registers *altpcie_rs_serdes|*]

# HIP testin pins SDC constraints
#set_false_path -from [get_pins -compatibility_mode *hip_ctrl*]

######################################################################
# Constraints for CV SIG asynchonous logic
set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_ltssm|altpcie_hip_vecsync:altpcie_hip_vecsync2|data_in_d0[*]}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_ltssm|altpcie_hip_vecsync:altpcie_hip_vecsync2|data_out[*]}]

set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_ltssm|altpcie_hip_vecsync:altpcie_hip_vecsync2|req_wr_clk}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_ltssm|altpcie_hip_vecsync:altpcie_hip_vecsync2|altpcie_hip_bitsync:u_req_rd_clk|sync_regs[*]}]

set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_tls|altpcie_hip_vecsync:altpcie_hip_vecsync2|req_rd_clk_d0}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_tls|altpcie_hip_vecsync:altpcie_hip_vecsync2|altpcie_hip_bitsync:u_ack_wr_clk|sync_regs[*]}]

set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_tls|altpcie_hip_vecsync:altpcie_hip_vecsync2|req_wr_clk}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_tls|altpcie_hip_vecsync:altpcie_hip_vecsync2|altpcie_hip_bitsync:u_req_rd_clk|sync_regs[*]}]

set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_tls|altpcie_hip_vecsync:altpcie_hip_vecsync2|data_in_d0[*]}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_tls|altpcie_hip_vecsync:altpcie_hip_vecsync2|data_out[*]}]

set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_ltssm|altpcie_hip_vecsync:altpcie_hip_vecsync2|req_rd_clk_d0}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_ltssm|altpcie_hip_vecsync:altpcie_hip_vecsync2|altpcie_hip_bitsync:u_ack_wr_clk|sync_regs[*]}]


set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip~SYNC_DATA_REG122}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|test_out[*]}]

set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip~SYNC_DATA_REG122}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hd_altpe3_hip_eq_bypass_ph3:sigtesten.ep_eq_bypass_ph3_inst|test_dbg_eqout[*]}]
                                                                                                                                                
set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip~SYNC_DATA_REG122}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hd_altpe3_hip_eq_bypass_ph3:sigtesten.ep_eq_bypass_ph3_inst|test_dbg_eqber[*]}]

set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip~SYNC_DATA_REG122}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hd_altpe3_hip_eq_bypass_ph3:sigtesten.ep_eq_bypass_ph3_inst|test_dbg_farend_lf[*]}]

set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip~SYNC_DATA_REG122}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hd_altpe3_hip_eq_bypass_ph3:sigtesten.ep_eq_bypass_ph3_inst|test_dbg_farend_fs[*]}]

# +---------------------------------------------------
# | Cut the async clear paths
# +---------------------------------------------------
set aclr_counter 0
set clrn_counter 0
set aclr_collection [get_pins -compatibility_mode -nocase -nowarn *|altera_reset_synchronizer_int_chain*|aclr]
set clrn_collection [get_pins -compatibility_mode -nocase -nowarn *|altera_reset_synchronizer_int_chain*|clrn]
foreach_in_collection aclr_pin $aclr_collection {
    set aclr_counter [expr $aclr_counter + 1]
}
foreach_in_collection clrn_pin $clrn_collection {
    set clrn_counter [expr $clrn_counter + 1]
}
if {$aclr_counter > 0} {
    set_false_path -to [get_pins -compatibility_mode -nocase *|altera_reset_synchronizer_int_chain*|aclr]
}

if {$clrn_counter > 0} {
    set_false_path -to [get_pins -compatibility_mode -nocase *|altera_reset_synchronizer_int_chain*|clrn]
}

#Altera JTAG Constraints
create_clock -name altera_reserved_tck [get_ports {altera_reserved_tck}] -period "24 MHz"
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdo]

