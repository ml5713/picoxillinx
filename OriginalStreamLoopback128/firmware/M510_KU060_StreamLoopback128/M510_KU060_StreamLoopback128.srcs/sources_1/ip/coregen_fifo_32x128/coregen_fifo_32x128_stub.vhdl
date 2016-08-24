-- Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2016.2 (lin64) Build 1577090 Thu Jun  2 16:32:35 MDT 2016
-- Date        : Fri Aug 19 18:23:56 2016
-- Host        : micron-ubuntu running 64-bit Ubuntu 14.04.2 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/micron/OriginalStreamLoopback128/firmware/M510_KU060_StreamLoopback128/M510_KU060_StreamLoopback128.srcs/sources_1/ip/coregen_fifo_32x128/coregen_fifo_32x128_stub.vhdl
-- Design      : coregen_fifo_32x128
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xcku060-ffva1156-2-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity coregen_fifo_32x128 is
  Port ( 
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    din : in STD_LOGIC_VECTOR ( 127 downto 0 );
    wr_en : in STD_LOGIC;
    rd_en : in STD_LOGIC;
    dout : out STD_LOGIC_VECTOR ( 127 downto 0 );
    full : out STD_LOGIC;
    empty : out STD_LOGIC
  );

end coregen_fifo_32x128;

architecture stub of coregen_fifo_32x128 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,rst,din[127:0],wr_en,rd_en,dout[127:0],full,empty";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "fifo_generator_v13_1_1,Vivado 2016.2";
begin
end;