##-----------------------------------------------------------------------------
##
## (c) Copyright 2010-2011 Xilinx, Inc. All rights reserved.
##
## This file contains confidential and proprietary information
## of Xilinx, Inc. and is protected under U.S. and
## international copyright and other intellectual property
## laws.
##
## DISCLAIMER
## This disclaimer is not a license and does not grant any
## rights to the materials distributed herewith. Except as
## otherwise provided in a valid license issued to you by
## Xilinx, and to the maximum extent permitted by applicable
## law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
## WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
## AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
## BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
## INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
## (2) Xilinx shall not be liable (whether in contract or tort,
## including negligence, or under any other theory of
## liability) for any loss or damage of any kind or nature
## related to, arising under or in connection with these
## materials, including for any direct, or any indirect,
## special, incidental, or consequential loss or damage
## (including loss of data, profits, goodwill, or any type of
## loss or damage suffered as a result of any action brought
## by a third party) even if such damage or loss was
## reasonably foreseeable or Xilinx had been advised of the
## possibility of the same.
##
## CRITICAL APPLICATIONS
## Xilinx products are not designed or intended to be fail-
## safe, or for use in any application requiring fail-safe
## performance, such as life-support or safety devices or
## systems, Class III medical devices, nuclear facilities,
## applications related to the deployment of airbags, or any
## other applications that could lead to death, personal
## injury, or severe property or environmental damage
## (individually and collectively, "Critical
## Applications"). Customer assumes the sole risk and
## liability of any use of Xilinx products in Critical
## Applications, subject only to applicable laws and
## regulations governing limitations on product liability.
##
## THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
## PART OF THIS FILE AT ALL TIMES.
##
##-----------------------------------------------------------------------------
## Project    : Series-7 Integrated Block for PCI Express
## File       : pcie_7x_0-PCIE_X0Y0.xdc
## Version    : 2.2
#
###############################################################################
# Extra Clock
###############################################################################
create_clock -period 5.000 -name extra_clk_p [get_ports extra_clk_p]
#set_propagated_clock extra_clk_p

# PadFunction: IO_L13P_T2_MRCC_12
set_property IOSTANDARD LVDS_25 [get_ports extra_clk_p]
set_property PACKAGE_PIN AF22 [get_ports extra_clk_p]
set_property DIFF_TERM TRUE [get_ports extra_clk_p]

# PadFunction: IO_L13N_T2_MRCC_12
set_property IOSTANDARD LVDS_25 [get_ports extra_clk_n]
set_property PACKAGE_PIN AG23 [get_ports extra_clk_n]
set_property DIFF_TERM TRUE [get_ports extra_clk_n]

###############################################################################
# User Physical Constraints
###############################################################################
create_pblock pblock_PicoFramework
add_cells_to_pblock [get_pblocks pblock_PicoFramework] [get_cells -quiet [list PicoFramework]]
resize_pblock [get_pblocks pblock_PicoFramework] -add {SLICE_X114Y151:SLICE_X145Y249}
resize_pblock [get_pblocks pblock_PicoFramework] -add {DSP48_X4Y62:DSP48_X5Y99}
resize_pblock [get_pblocks pblock_PicoFramework] -add {RAMB18_X4Y62:RAMB18_X5Y99}
resize_pblock [get_pblocks pblock_PicoFramework] -add {RAMB36_X4Y31:RAMB36_X5Y49}

###############################################################################
# Pinout and Related I/O Constraints
###############################################################################

# sys_reset_n
set_property PACKAGE_PIN V26 [get_ports sys_reset_n]
set_property IOSTANDARD LVCMOS25 [get_ports sys_reset_n]
set_property PULLUP true [get_ports sys_reset_n]
#set_property NODELAY TRUE [get_ports sys_reset_n]

# sys_clk_p sys_clk_n
set_property PACKAGE_PIN L7 [get_ports sys_clk_n]


###############################################################################
# Physical Constraints
###############################################################################
#
# Transceiver instance placement.  This constraint selects the
# transceivers to be used, which also dictates the pinout for the
# transmit and receive differential pairs.  Please refer to the
# Virtex-7 GT Transceiver User Guide (UG) for more information.
#

# PCIe Lane 0
set_property LOC GTXE2_CHANNEL_X0Y7 [get_cells {PicoFramework/core/gt_top_i/pipe_wrapper_i/pipe_lane[0].gt_wrapper_i/gtx_channel.gtxe2_channel_i}]
# PCIe Lane 1
set_property LOC GTXE2_CHANNEL_X0Y6 [get_cells {PicoFramework/core/gt_top_i/pipe_wrapper_i/pipe_lane[1].gt_wrapper_i/gtx_channel.gtxe2_channel_i}]
# PCIe Lane 2
set_property LOC GTXE2_CHANNEL_X0Y5 [get_cells {PicoFramework/core/gt_top_i/pipe_wrapper_i/pipe_lane[2].gt_wrapper_i/gtx_channel.gtxe2_channel_i}]
# PCIe Lane 3
set_property LOC GTXE2_CHANNEL_X0Y4 [get_cells {PicoFramework/core/gt_top_i/pipe_wrapper_i/pipe_lane[3].gt_wrapper_i/gtx_channel.gtxe2_channel_i}]
# PCIe Lane 4
set_property LOC GTXE2_CHANNEL_X0Y3 [get_cells {PicoFramework/core/gt_top_i/pipe_wrapper_i/pipe_lane[4].gt_wrapper_i/gtx_channel.gtxe2_channel_i}]
# PCIe Lane 5
set_property LOC GTXE2_CHANNEL_X0Y2 [get_cells {PicoFramework/core/gt_top_i/pipe_wrapper_i/pipe_lane[5].gt_wrapper_i/gtx_channel.gtxe2_channel_i}]
# PCIe Lane 6
set_property LOC GTXE2_CHANNEL_X0Y1 [get_cells {PicoFramework/core/gt_top_i/pipe_wrapper_i/pipe_lane[6].gt_wrapper_i/gtx_channel.gtxe2_channel_i}]
# PCIe Lane 7
set_property LOC GTXE2_CHANNEL_X0Y0 [get_cells {PicoFramework/core/gt_top_i/pipe_wrapper_i/pipe_lane[7].gt_wrapper_i/gtx_channel.gtxe2_channel_i}]


#
# PCI Express Block placement. This constraint selects the PCI Express
# Block to be used.
#

set_property LOC PCIE_X0Y0 [get_cells PicoFramework/core/pcie_top_i/pcie_7x_i/pcie_block_i]

#
# BlockRAM placement
#
set_property LOC RAMB36_X4Y34 [get_cells {PicoFramework/core/pcie_top_i/pcie_7x_i/pcie_bram_top/pcie_brams_rx/brams[0].ram/use_sdp.ramb36sdp/genblk3_0.bram36_dp_bl.bram36_tdp_bl}]
set_property LOC RAMB36_X4Y33 [get_cells {PicoFramework/core/pcie_top_i/pcie_7x_i/pcie_bram_top/pcie_brams_rx/brams[1].ram/use_sdp.ramb36sdp/genblk3_0.bram36_dp_bl.bram36_tdp_bl}]
set_property LOC RAMB36_X4Y31 [get_cells {PicoFramework/core/pcie_top_i/pcie_7x_i/pcie_bram_top/pcie_brams_tx/brams[0].ram/use_sdp.ramb36sdp/genblk3_0.bram36_dp_bl.bram36_tdp_bl}]
set_property LOC RAMB36_X4Y30 [get_cells {PicoFramework/core/pcie_top_i/pcie_7x_i/pcie_bram_top/pcie_brams_tx/brams[1].ram/use_sdp.ramb36sdp/genblk3_0.bram36_dp_bl.bram36_tdp_bl}]

###############################################################################
# Timing Constraints
###############################################################################
#
create_clock -period 10.000 [get_ports sys_clk_p]
create_clock -period 10.000 [get_pins -hier -filter {NAME =~ */gt_top_i/pipe_wrapper_i/pipe_lane[0].gt_wrapper_i/gtx_channel.gtxe2_channel_i/TXOUTCLK}]
#
#
set_false_path -through [get_pins -hier -filter {NAME =~ */pcie_top_i/pcie_7x_i/pcie_block_i/PLPHYLNKUPN*}]
set_false_path -through [get_pins -hier -filter {NAME =~ */pcie_top_i/pcie_7x_i/pcie_block_i/PLRECEIVEDHOTRST*}]

#NET "sys_reset_n" TIG;
set_false_path -from [get_ports sys_reset_n]
#PIN "*pipe_clock_i/mmcm_i.RST" TIG ;
# TODO: should this be a -to constraint?
set_false_path -to [get_pins -hier -filter {NAME =~ *pipe_clock_i/mmcm_i/RST}]
#NET "*pipe_clock_i/pclk_sel" TIG;
# TODO: why is this now pclk_sel_reg?
# TODO: should this be a -through constraint?
# TODO: should this start at the clock pin of pclk_sel_reg?
set_false_path -from [get_pins -hier -filter {NAME =~ *pipe_clock_i/pclk_sel_reg/C}]
#NET "*pipe_reset_i/cpllreset" TIG;
# TODO: should this be -through?
# TODO: why is this changed to cpllreset_reg?
set_false_path -from [get_pins -hier -filter {NAME =~ */gt_top_i/pipe_wrapper_i/*pipe_reset_i/cpllreset_reg/C}]
#NET "*pipe_clock_i/clk_125mhz" TIG;
# TODO: do we really want to TIG all the 125 MHz clock nets?
set_false_path -through [get_pins -hier -filter {NAME =~ *pipe_clock_i/mmcm_i/CLKOUT0}]


set_false_path -to [get_pins -hier -filter {NAME =~ *pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/S0}]
set_false_path -to [get_pins -hier -filter {NAME =~ *pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/S1}]
#
create_generated_clock -name clk_125mhz_x0y0 [get_pins -hier -filter {NAME =~ *pipe_clock_i/mmcm_i/CLKOUT0}]
create_generated_clock -name clk_250mhz_x0y0 [get_pins -hier -filter {NAME =~ *pipe_clock_i/mmcm_i/CLKOUT1}]
create_generated_clock -name clk_125mhz_mux_x0y0 \
                        -source [get_pins -hier -filter {NAME =~ *pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/I0}] \
                        -divide_by 1 \
                        [get_pins -hier -filter {NAME =~ *pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/O}]
#
create_generated_clock -name clk_250mhz_mux_x0y0 \
                        -source [get_pins -hier -filter {NAME =~ *pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/I1}] \
                        -divide_by 1 -add -master_clock [get_clocks -of [get_pins -hier -filter {NAME =~ *pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/I1}]] \
                        [get_pins -hier -filter {NAME =~ *pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/O}]
#
set_clock_groups -name pcieclkmux -physically_exclusive -group clk_125mhz_mux_x0y0 -group clk_250mhz_mux_x0y0
#
#

#Setting asynchronous clocks between extra_clk and the pcie core clocks
set_clock_groups -group [get_clocks clk_125mhz_mux_x0y0] -group [get_clocks extra_clk_p] -asynchronous
set_clock_groups -group [get_clocks userclk2] -group [get_clocks extra_clk_p] -asynchronous
set_clock_groups -group [get_clocks clk_250mhz_mux_x0y0] -group [get_clocks extra_clk_p] -asynchronous

###############################################################################
# End
###############################################################################

# Flash
set_property IOSTANDARD LVCMOS25 [get_ports flash_busy]
set_property PULLUP true [get_ports flash_busy]
set_property PACKAGE_PIN U25 [get_ports flash_busy]
# /home/stz/workspace2/usr/src/picocomputing-5.2.0.14/samples/DDR3_MovingAverage/firmware/ISE_m505lx325/source/M505_LX325T_PCIe.ucf:200
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flash_byte' has been applied to the port object 'flash_byte'.
set_property IOSTANDARD LVCMOS25 [get_ports flash_byte]
set_property PACKAGE_PIN M23 [get_ports flash_byte]
# /home/stz/workspace2/usr/src/picocomputing-5.2.0.14/samples/DDR3_MovingAverage/firmware/ISE_m505lx325/source/M505_LX325T_PCIe.ucf:202
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flash_ce' has been applied to the port object 'flash_ce'.
set_property IOSTANDARD LVCMOS25 [get_ports flash_ce]
set_property PACKAGE_PIN U19 [get_ports flash_ce]
# /home/stz/workspace2/usr/src/picocomputing-5.2.0.14/samples/DDR3_MovingAverage/firmware/ISE_m505lx325/source/M505_LX325T_PCIe.ucf:204
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flash_oe' has been applied to the port object 'flash_oe'.
set_property IOSTANDARD LVCMOS25 [get_ports flash_oe]
set_property PACKAGE_PIN M24 [get_ports flash_oe]
# /home/stz/workspace2/usr/src/picocomputing-5.2.0.14/samples/DDR3_MovingAverage/firmware/ISE_m505lx325/source/M505_LX325T_PCIe.ucf:206
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flash_reset' has been applied to the port object 'flash_reset'.
set_property IOSTANDARD LVCMOS25 [get_ports flash_reset]
set_property PACKAGE_PIN U30 [get_ports flash_reset]
# /home/stz/workspace2/usr/src/picocomputing-5.2.0.14/samples/DDR3_MovingAverage/firmware/ISE_m505lx325/source/M505_LX325T_PCIe.ucf:208
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flash_we' has been applied to the port object 'flash_we'.
set_property IOSTANDARD LVCMOS25 [get_ports flash_we]
set_property PACKAGE_PIN M25 [get_ports flash_we]
# Pin Group: FLASH_A
set_property PACKAGE_PIN W22 [get_ports {flash_a[0]}]
set_property PACKAGE_PIN W21 [get_ports {flash_a[1]}]
set_property PACKAGE_PIN V24 [get_ports {flash_a[2]}]
set_property PACKAGE_PIN U24 [get_ports {flash_a[3]}]
set_property PACKAGE_PIN V22 [get_ports {flash_a[4]}]
set_property PACKAGE_PIN V21 [get_ports {flash_a[5]}]
set_property PACKAGE_PIN U23 [get_ports {flash_a[6]}]
set_property PACKAGE_PIN W24 [get_ports {flash_a[7]}]
set_property PACKAGE_PIN W23 [get_ports {flash_a[8]}]
set_property PACKAGE_PIN V20 [get_ports {flash_a[9]}]
set_property PACKAGE_PIN V19 [get_ports {flash_a[10]}]
set_property PACKAGE_PIN W26 [get_ports {flash_a[11]}]
set_property PACKAGE_PIN V25 [get_ports {flash_a[12]}]
set_property PACKAGE_PIN V30 [get_ports {flash_a[13]}]
set_property PACKAGE_PIN V29 [get_ports {flash_a[14]}]
set_property PACKAGE_PIN V27 [get_ports {flash_a[15]}]
set_property PACKAGE_PIN P22 [get_ports {flash_a[16]}]
set_property PACKAGE_PIN P21 [get_ports {flash_a[17]}]
set_property PACKAGE_PIN N24 [get_ports {flash_a[18]}]
set_property PACKAGE_PIN N22 [get_ports {flash_a[19]}]
set_property PACKAGE_PIN N21 [get_ports {flash_a[20]}]
set_property PACKAGE_PIN N20 [get_ports {flash_a[21]}]
set_property PACKAGE_PIN N19 [get_ports {flash_a[22]}]
set_property PACKAGE_PIN N26 [get_ports {flash_a[23]}]
set_property PACKAGE_PIN N25 [get_ports {flash_a[24]}]
set_property PACKAGE_PIN N30 [get_ports {flash_a[25]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[10]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[11]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[12]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[13]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[14]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[15]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[16]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[17]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[18]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[19]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[20]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[21]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[22]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[23]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[24]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[25]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[4]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[5]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[6]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[7]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[8]}]
set_property IOSTANDARD LVCMOS25 [get_ports {flash_a[9]}]
# Pin Group: FLASH_D
set_property PACKAGE_PIN P24 [get_ports {flash_d[0]}]
set_property PACKAGE_PIN R25 [get_ports {flash_d[1]}]
set_property PACKAGE_PIN R20 [get_ports {flash_d[2]}]
set_property PACKAGE_PIN R21 [get_ports {flash_d[3]}]
set_property PACKAGE_PIN T20 [get_ports {flash_d[4]}]
set_property PACKAGE_PIN T21 [get_ports {flash_d[5]}]
set_property PACKAGE_PIN T22 [get_ports {flash_d[6]}]
set_property PACKAGE_PIN T23 [get_ports {flash_d[7]}]
set_property PACKAGE_PIN U20 [get_ports {flash_d[8]}]
set_property PACKAGE_PIN P29 [get_ports {flash_d[9]}]
set_property PACKAGE_PIN R29 [get_ports {flash_d[10]}]
set_property PACKAGE_PIN P27 [get_ports {flash_d[11]}]
set_property PACKAGE_PIN P28 [get_ports {flash_d[12]}]
set_property PACKAGE_PIN T30 [get_ports {flash_d[13]}]
set_property PACKAGE_PIN P26 [get_ports {flash_d[14]}]
set_property PACKAGE_PIN R26 [get_ports {flash_d[15]}]
# /home/stz/workspace2/usr/src/picocomputing-5.2.0.14/samples/DDR3_MovingAverage/firmware/ISE_m505lx325/source/M505_LX325T_PCIe.ucf:255
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flash_d[0]' has been applied to the port object 'flash_d[0]'.
set_property IOSTANDARD LVCMOS25 [get_ports {flash_d[0]}]
# /home/stz/workspace2/usr/src/picocomputing-5.2.0.14/samples/DDR3_MovingAverage/firmware/ISE_m505lx325/source/M505_LX325T_PCIe.ucf:255
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flash_d[10]' has been applied to the port object 'flash_d[10]'.
set_property IOSTANDARD LVCMOS25 [get_ports {flash_d[10]}]
# /home/stz/workspace2/usr/src/picocomputing-5.2.0.14/samples/DDR3_MovingAverage/firmware/ISE_m505lx325/source/M505_LX325T_PCIe.ucf:255
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flash_d[11]' has been applied to the port object 'flash_d[11]'.
set_property IOSTANDARD LVCMOS25 [get_ports {flash_d[11]}]
# /home/stz/workspace2/usr/src/picocomputing-5.2.0.14/samples/DDR3_MovingAverage/firmware/ISE_m505lx325/source/M505_LX325T_PCIe.ucf:255
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flash_d[12]' has been applied to the port object 'flash_d[12]'.
set_property IOSTANDARD LVCMOS25 [get_ports {flash_d[12]}]
# /home/stz/workspace2/usr/src/picocomputing-5.2.0.14/samples/DDR3_MovingAverage/firmware/ISE_m505lx325/source/M505_LX325T_PCIe.ucf:255
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flash_d[13]' has been applied to the port object 'flash_d[13]'.
set_property IOSTANDARD LVCMOS25 [get_ports {flash_d[13]}]
# /home/stz/workspace2/usr/src/picocomputing-5.2.0.14/samples/DDR3_MovingAverage/firmware/ISE_m505lx325/source/M505_LX325T_PCIe.ucf:255
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flash_d[14]' has been applied to the port object 'flash_d[14]'.
set_property IOSTANDARD LVCMOS25 [get_ports {flash_d[14]}]
# /home/stz/workspace2/usr/src/picocomputing-5.2.0.14/samples/DDR3_MovingAverage/firmware/ISE_m505lx325/source/M505_LX325T_PCIe.ucf:255
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flash_d[15]' has been applied to the port object 'flash_d[15]'.
set_property IOSTANDARD LVCMOS25 [get_ports {flash_d[15]}]
# /home/stz/workspace2/usr/src/picocomputing-5.2.0.14/samples/DDR3_MovingAverage/firmware/ISE_m505lx325/source/M505_LX325T_PCIe.ucf:255
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flash_d[1]' has been applied to the port object 'flash_d[1]'.
set_property IOSTANDARD LVCMOS25 [get_ports {flash_d[1]}]
# /home/stz/workspace2/usr/src/picocomputing-5.2.0.14/samples/DDR3_MovingAverage/firmware/ISE_m505lx325/source/M505_LX325T_PCIe.ucf:255
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flash_d[2]' has been applied to the port object 'flash_d[2]'.
set_property IOSTANDARD LVCMOS25 [get_ports {flash_d[2]}]
# /home/stz/workspace2/usr/src/picocomputing-5.2.0.14/samples/DDR3_MovingAverage/firmware/ISE_m505lx325/source/M505_LX325T_PCIe.ucf:255
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flash_d[3]' has been applied to the port object 'flash_d[3]'.
set_property IOSTANDARD LVCMOS25 [get_ports {flash_d[3]}]
# /home/stz/workspace2/usr/src/picocomputing-5.2.0.14/samples/DDR3_MovingAverage/firmware/ISE_m505lx325/source/M505_LX325T_PCIe.ucf:255
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flash_d[4]' has been applied to the port object 'flash_d[4]'.
set_property IOSTANDARD LVCMOS25 [get_ports {flash_d[4]}]
# /home/stz/workspace2/usr/src/picocomputing-5.2.0.14/samples/DDR3_MovingAverage/firmware/ISE_m505lx325/source/M505_LX325T_PCIe.ucf:255
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flash_d[5]' has been applied to the port object 'flash_d[5]'.
set_property IOSTANDARD LVCMOS25 [get_ports {flash_d[5]}]
# /home/stz/workspace2/usr/src/picocomputing-5.2.0.14/samples/DDR3_MovingAverage/firmware/ISE_m505lx325/source/M505_LX325T_PCIe.ucf:255
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flash_d[6]' has been applied to the port object 'flash_d[6]'.
set_property IOSTANDARD LVCMOS25 [get_ports {flash_d[6]}]
# /home/stz/workspace2/usr/src/picocomputing-5.2.0.14/samples/DDR3_MovingAverage/firmware/ISE_m505lx325/source/M505_LX325T_PCIe.ucf:255
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flash_d[7]' has been applied to the port object 'flash_d[7]'.
set_property IOSTANDARD LVCMOS25 [get_ports {flash_d[7]}]
# /home/stz/workspace2/usr/src/picocomputing-5.2.0.14/samples/DDR3_MovingAverage/firmware/ISE_m505lx325/source/M505_LX325T_PCIe.ucf:255
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flash_d[8]' has been applied to the port object 'flash_d[8]'.
set_property IOSTANDARD LVCMOS25 [get_ports {flash_d[8]}]
# /home/stz/workspace2/usr/src/picocomputing-5.2.0.14/samples/DDR3_MovingAverage/firmware/ISE_m505lx325/source/M505_LX325T_PCIe.ucf:255
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flash_d[9]' has been applied to the port object 'flash_d[9]'.
set_property IOSTANDARD LVCMOS25 [get_ports {flash_d[9]}]

##########################################################
# Set the write_bistream settings to do 
#   - compression
#   - overtemp protection
#   - Page Mode Read for NOR flash
##########################################################
set_property BITSTREAM.CONFIG.BPI_1ST_READ_CYCLE 4 [current_design]
set_property BITSTREAM.CONFIG.BPI_PAGE_SIZE 8 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS "True" [current_design]
set_property BITSTREAM.CONFIG.OVERTEMPPOWERDOWN "Enable" [current_design]
