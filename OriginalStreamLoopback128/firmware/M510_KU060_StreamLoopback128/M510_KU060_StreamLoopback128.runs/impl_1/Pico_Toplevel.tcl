proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/M510_KU060_StreamLoopback128.cache/wt [current_project]
  set_property parent.project_path /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/M510_KU060_StreamLoopback128.xpr [current_project]
  set_property ip_repo_paths /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/M510_KU060_StreamLoopback128.cache/ip [current_project]
  set_property ip_output_repo /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/M510_KU060_StreamLoopback128.cache/ip [current_project]
  set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
  add_files -quiet /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/M510_KU060_StreamLoopback128.runs/synth_1/Pico_Toplevel.dcp
  add_files -quiet /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/M510_KU060_StreamLoopback128.srcs/sources_1/ip/coregen_fifo_32x128/coregen_fifo_32x128.dcp
  set_property netlist_only true [get_files /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/M510_KU060_StreamLoopback128.srcs/sources_1/ip/coregen_fifo_32x128/coregen_fifo_32x128.dcp]
  add_files -quiet /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/pcie3_ultrascale_0.dcp
  set_property netlist_only true [get_files /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/pcie3_ultrascale_0.dcp]
  read_xdc -mode out_of_context -ref coregen_fifo_32x128 -cells U0 /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/M510_KU060_StreamLoopback128.srcs/sources_1/ip/coregen_fifo_32x128/coregen_fifo_32x128_ooc.xdc
  set_property processing_order EARLY [get_files /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/M510_KU060_StreamLoopback128.srcs/sources_1/ip/coregen_fifo_32x128/coregen_fifo_32x128_ooc.xdc]
  read_xdc -ref coregen_fifo_32x128 -cells U0 /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/M510_KU060_StreamLoopback128.srcs/sources_1/ip/coregen_fifo_32x128/coregen_fifo_32x128/coregen_fifo_32x128.xdc
  set_property processing_order EARLY [get_files /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/M510_KU060_StreamLoopback128.srcs/sources_1/ip/coregen_fifo_32x128/coregen_fifo_32x128/coregen_fifo_32x128.xdc]
  read_xdc -mode out_of_context -ref pcie3_ultrascale_0 -cells inst /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/synth/pcie3_ultrascale_0_ooc.xdc
  set_property processing_order EARLY [get_files /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/synth/pcie3_ultrascale_0_ooc.xdc]
  read_xdc -ref pcie3_ultrascale_0_gt -cells inst /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/ip_0/synth/pcie3_ultrascale_0_gt.xdc
  set_property processing_order EARLY [get_files /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/ip_0/synth/pcie3_ultrascale_0_gt.xdc]
  read_xdc -ref pcie3_ultrascale_0 -cells inst /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0-PCIE_X0Y0.xdc
  set_property processing_order EARLY [get_files /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/M510_KU060_StreamLoopback128.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0-PCIE_X0Y0.xdc]
  read_xdc /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/firmware/m510/src/M510_KU060_FFVA1156_E.xdc
  read_xdc -unmanaged /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/firmware/m510/src/clocks.tcl
  link_design -top Pico_Toplevel -part xcku060-ffva1156-2-e
  write_hwdef -file Pico_Toplevel.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force Pico_Toplevel_opt.dcp
  report_drc -file Pico_Toplevel_drc_opted.rpt
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force Pico_Toplevel_placed.dcp
  report_io -file Pico_Toplevel_io_placed.rpt
  report_utilization -file Pico_Toplevel_utilization_placed.rpt -pb Pico_Toplevel_utilization_placed.pb
  report_control_sets -verbose -file Pico_Toplevel_control_sets_placed.rpt
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force Pico_Toplevel_routed.dcp
  report_drc -file Pico_Toplevel_drc_routed.rpt -pb Pico_Toplevel_drc_routed.pb
  report_timing_summary -warn_on_violation -max_paths 10 -file Pico_Toplevel_timing_summary_routed.rpt -rpx Pico_Toplevel_timing_summary_routed.rpx
  report_power -file Pico_Toplevel_power_routed.rpt -pb Pico_Toplevel_power_summary_routed.pb -rpx Pico_Toplevel_power_routed.rpx
  report_route_status -file Pico_Toplevel_route_status.rpt -pb Pico_Toplevel_route_status.pb
  report_clock_utilization -file Pico_Toplevel_clock_utilization_routed.rpt
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  catch { write_mem_info -force Pico_Toplevel.mmi }
  write_bitstream -force Pico_Toplevel.bit 
  catch { write_sysdef -hwdef Pico_Toplevel.hwdef -bitfile Pico_Toplevel.bit -meminfo Pico_Toplevel.mmi -file Pico_Toplevel.sysdef }
  catch {write_debug_probes -quiet -force debug_nets}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

