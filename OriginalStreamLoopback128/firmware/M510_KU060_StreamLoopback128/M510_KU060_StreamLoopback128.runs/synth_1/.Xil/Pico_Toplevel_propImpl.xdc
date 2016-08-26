set_property SRC_FILE_INFO {cfile:/home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/firmware/m510/src/M510_KU060_FFVA1156_E.xdc rfile:../../../firmware/m510/src/M510_KU060_FFVA1156_E.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:78 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AK31 [get_ports extra_clk_p]
set_property src_info {type:XDC file:1 line:80 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AK32 [get_ports extra_clk_n]
set_property src_info {type:XDC file:1 line:85 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN D11 [get_ports {led_r[0]}]
set_property src_info {type:XDC file:1 line:87 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN B11 [get_ports {led_g[0]}]
set_property src_info {type:XDC file:1 line:89 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN B10 [get_ports {led_b[0]}]
set_property src_info {type:XDC file:1 line:101 export:INPUT save:INPUT read:READ} [current_design]
create_pblock pblock_PicoFramework
add_cells_to_pblock [get_pblocks pblock_PicoFramework] [get_cells -quiet [list PicoFramework]]
resize_pblock [get_pblocks pblock_PicoFramework] -add {SLICE_X124Y0:SLICE_X142Y110}
resize_pblock [get_pblocks pblock_PicoFramework] -add {RAMB18_X15Y0:RAMB18_X17Y43}
resize_pblock [get_pblocks pblock_PicoFramework] -add {RAMB36_X15Y0:RAMB36_X17Y21}
set_property src_info {type:XDC file:1 line:111 export:INPUT save:INPUT read:READ} [current_design]
set_property LOC PCIE_3_1_X0Y0 [get_cells PicoFramework/core/pcie3_ultrascale_0_i/inst/pcie3_uscale_top_inst/pcie3_uscale_wrapper_inst/PCIE_3_1_inst]
set_property src_info {type:XDC file:1 line:112 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN K22 [get_ports sys_reset_n]
set_property src_info {type:XDC file:1 line:117 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AB5 [get_ports sys_clk_n]
set_property src_info {type:XDC file:1 line:118 export:INPUT save:INPUT read:READ} [current_design]
set_property LOC BUFG_GT_X1Y36 [get_cells PicoFramework/core/pcie3_ultrascale_0_i/inst/gt_top_i/phy_clk_i/bufg_gt_pclk]
set_property src_info {type:XDC file:1 line:119 export:INPUT save:INPUT read:READ} [current_design]
set_property LOC BUFG_GT_X1Y37 [get_cells PicoFramework/core/pcie3_ultrascale_0_i/inst/gt_top_i/phy_clk_i/bufg_gt_userclk]
set_property src_info {type:XDC file:1 line:120 export:INPUT save:INPUT read:READ} [current_design]
set_property LOC BUFG_GT_X1Y38 [get_cells PicoFramework/core/pcie3_ultrascale_0_i/inst/gt_top_i/phy_clk_i/bufg_gt_coreclk]