// PicoDefines.v - here we configure the base firmware for our project

// This includes a placeholder "user" module that you will replace with your code.
// To use your own module, just change the name from PicoBus128_counter to your
//   module's name, and then add the file to your ISE project.
`define USER_MODULE_NAME StreamLoopback128
`define XILINX_FPGA

`define STREAM1_IN_WIDTH 128
`define STREAM1_OUT_WIDTH 128

// We define the type of FPGA and card we're using.
`define PICO_MODEL_M510
`define PICO_FPGA_KU060

`include "BasePicoDefines.v"
