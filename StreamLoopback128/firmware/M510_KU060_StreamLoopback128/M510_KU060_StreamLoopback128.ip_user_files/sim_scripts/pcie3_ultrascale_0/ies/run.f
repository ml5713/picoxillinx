-makelib ies/xil_defaultlib -sv \
  "/opt/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "/opt/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_memory/hdl/xpm_memory_base.sv" \
  "/opt/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_memory/hdl/xpm_memory_dpdistram.sv" \
  "/opt/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_memory/hdl/xpm_memory_dprom.sv" \
  "/opt/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_memory/hdl/xpm_memory_sdpram.sv" \
  "/opt/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_memory/hdl/xpm_memory_spram.sv" \
  "/opt/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_memory/hdl/xpm_memory_sprom.sv" \
  "/opt/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_memory/hdl/xpm_memory_tdpram.sv" \
-endlib
-makelib ies/xpm \
  "/opt/Xilinx/Vivado/2016.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies/gtwizard_ultrascale_v1_5_4 \
  "../../../ipstatic/gtwizard_ultrascale_v1_5_4/hdl/verilog/gtwizard_ultrascale_v1_5_bit_synchronizer.v" \
  "../../../ipstatic/gtwizard_ultrascale_v1_5_4/hdl/verilog/gtwizard_ultrascale_v1_5_gthe3_cpll_cal.v" \
  "../../../ipstatic/gtwizard_ultrascale_v1_5_4/hdl/verilog/gtwizard_ultrascale_v1_5_gthe3_cpll_cal_freq_counter.v" \
  "../../../ipstatic/gtwizard_ultrascale_v1_5_4/hdl/verilog/gtwizard_ultrascale_v1_5_gtwiz_buffbypass_rx.v" \
  "../../../ipstatic/gtwizard_ultrascale_v1_5_4/hdl/verilog/gtwizard_ultrascale_v1_5_gtwiz_buffbypass_tx.v" \
  "../../../ipstatic/gtwizard_ultrascale_v1_5_4/hdl/verilog/gtwizard_ultrascale_v1_5_gtwiz_reset.v" \
  "../../../ipstatic/gtwizard_ultrascale_v1_5_4/hdl/verilog/gtwizard_ultrascale_v1_5_gtwiz_userclk_rx.v" \
  "../../../ipstatic/gtwizard_ultrascale_v1_5_4/hdl/verilog/gtwizard_ultrascale_v1_5_gtwiz_userclk_tx.v" \
  "../../../ipstatic/gtwizard_ultrascale_v1_5_4/hdl/verilog/gtwizard_ultrascale_v1_5_gtwiz_userdata_rx.v" \
  "../../../ipstatic/gtwizard_ultrascale_v1_5_4/hdl/verilog/gtwizard_ultrascale_v1_5_gtwiz_userdata_tx.v" \
  "../../../ipstatic/gtwizard_ultrascale_v1_5_4/hdl/verilog/gtwizard_ultrascale_v1_5_reset_synchronizer.v" \
-endlib
-makelib ies/xil_defaultlib \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/ip_0/sim/gtwizard_ultrascale_v1_5_gthe3_channel.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/ip_0/sim/pcie3_ultrascale_0_gt_gthe3_channel_wrapper.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/ip_0/sim/gtwizard_ultrascale_v1_5_gthe3_common.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/ip_0/sim/pcie3_ultrascale_0_gt_gthe3_common_wrapper.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/ip_0/sim/pcie3_ultrascale_0_gt_gtwizard_gthe3.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/ip_0/sim/pcie3_ultrascale_0_gt_gtwizard_top.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/ip_0/sim/pcie3_ultrascale_0_gt.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_tph_tbl.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_pipe_lane.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_bram_16k.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_bram_rep_8k.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_bram_req_8k.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_gt_channel.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_pipe_pipeline.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_pipe_misc.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_init_ctrl.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_gt_common.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_bram_8k.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_bram_rep.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_bram_req.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_phy_sync.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_bram_cpl.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_sys_clk_gen.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_phy_rst.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_phy_txeq.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_phy_clk.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_bram.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_phy_rxeq.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_gtwizard_top.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_phy_wrapper.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_pcie3_uscale_wrapper.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_pcie3_uscale_top.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_phy_sync_cell.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_rxcdrhold.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0_pcie3_uscale_core_top.v" \
  "../../../../M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/sim/pcie3_ultrascale_0.v" \
-endlib
-makelib ies/xil_defaultlib \
  glbl.v
-endlib

