// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.2 (lin64) Build 1577090 Thu Jun  2 16:32:35 MDT 2016
// Date        : Fri Aug 19 18:23:56 2016
// Host        : micron-ubuntu running 64-bit Ubuntu 14.04.2 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/M510_KU060_StreamLoopback128.srcs/sources_1/ip/coregen_fifo_32x128/coregen_fifo_32x128_stub.v
// Design      : coregen_fifo_32x128
// Purpose     : Stub declaration of top-level module interface
// Device      : xcku060-ffva1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_1_1,Vivado 2016.2" *)
module coregen_fifo_32x128(clk, rst, din, wr_en, rd_en, dout, full, empty)
/* synthesis syn_black_box black_box_pad_pin="clk,rst,din[127:0],wr_en,rd_en,dout[127:0],full,empty" */;
  input clk;
  input rst;
  input [127:0]din;
  input wr_en;
  input rd_en;
  output [127:0]dout;
  output full;
  output empty;
endmodule
