// PicoInterfaces.sv
// Copyright 2014 Pico Computing, Inc.

interface pci_exp_ports;

    wire  [7:0]                         txp;
    wire  [7:0]                         txn;
    wire  [7:0]                         rxp;
    wire  [7:0]                         rxn;

    modport i (
        input  rxp, rxn,
        output txp, txn
    );

endinterface

interface flash_ports;
    wire                                busy;
    wire                                byte_mode;
    wire                                ce;
    wire                                oe;
    wire                                reset;
    wire                                we;
    wire   [25:0]                       a;
    wire   [15:0]                       d;
    modport i (
        input   busy,
        output  byte_mode, ce, oe, reset, we, a,
        inout   d
    );
endinterface
/*
import PicoModelParams::nCS_PER_RANK;
import PicoModelParams::BANK_WIDTH;  
import PicoModelParams::ROW_WIDTH;   
import PicoModelParams::CK_WIDTH;    
import PicoModelParams::CS_WIDTH;    
import PicoModelParams::CKE_WIDTH;   
import PicoModelParams::DQ_WIDTH;    
import PicoModelParams::DM_WIDTH;    
import PicoModelParams::DQS_WIDTH;   
import PicoModelParams::ODT_WIDTH;   

interface ddr3_phy_ports;
    wire   [DQ_WIDTH-1:0]               dq;
    wire   [ROW_WIDTH-1:0]              addr;
    wire   [BANK_WIDTH-1:0]             ba;
    wire                                ras_n;
    wire                                cas_n;
    wire                                we_n;
    wire                                reset_n;
    wire   [DM_WIDTH-1:0]               dm;
    wire   [DQS_WIDTH-1:0]              dqs_p;
    wire   [DQS_WIDTH-1:0]              dqs_n;
    wire   [CK_WIDTH-1:0]               ck_p;
    wire   [CK_WIDTH-1:0]               ck_n;
    wire   [CS_WIDTH*nCS_PER_RANK-1:0]  cs_n;
    wire   [ODT_WIDTH-1:0]              odt;
    wire   [CKE_WIDTH-1:0]              cke;
    wire                                mem_refclk;
    wire                                oct_rzqin;
    
    modport i (
        inout   dq, dqs_p, dqs_n,
        output  addr, ba, ras_n, cas_n, we_n, reset_n, dm, ck_p, ck_n, cs_n, odt, cke,
        input   mem_refclk, oct_rzqin
    );

endinterface
*/
interface i2c_ports;
    wire sda, scl;
    modport i (
        inout   sda,
        output  scl
    );
endinterface

// ALTERA AVALON-MM INTERFACE
interface ddr3_core_uif #(
    AVL_ADDR_WIDTH = 27,
    AVL_DATA_WIDTH = 512,
    AVL_SIZE_WIDTH = 9
    );
    wire                                clk;
    wire                                rst;
    logic                               ready;      
    logic   [AVL_ADDR_WIDTH-1:0]        addr;       
    logic                               rdata_valid;
    logic   [AVL_DATA_WIDTH-1:0]        rdata;      
    logic   [AVL_DATA_WIDTH-1:0]        wdata;      
    logic   [AVL_DATA_WIDTH/8-1:0]      be;         
    logic                               read_req;
    logic                               write_req;  
    logic   [AVL_SIZE_WIDTH-1:0]        size;

    modport master (
        input  clk,
        input  rst,

        input  ready,
        output addr,
        input  rdata_valid,
        input  rdata,
        output wdata,
        output be,
        output read_req,
        output write_req,
        output size
    );

    modport slave (
        output clk,
        output rst,

        output ready,
        input  addr,
        output rdata_valid,
        output rdata,
        input  wdata,
        input  be,
        input  read_req,
        input  write_req,
        input  size
    );

endinterface

