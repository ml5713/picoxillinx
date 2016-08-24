// altera_pcie.v
// Copyright 2014 Pico Computing, Inc.

`include "PicoDefines.v"

module altera_pcie # (
    parameter C_DATA_WIDTH = 128,            // RX/TX interface data width

    // Do not override parameters below this line
    parameter STRB_WIDTH = C_DATA_WIDTH / 8               // TSTRB width
    ) (
    output wire                     user_clk,
    output wire                     user_reset,
    output wire                     user_lnk_up,

    output wire                     s_axis_tx_tready,
    input  wire [C_DATA_WIDTH-1:0]  s_axis_tx_tdata,
    input  wire [STRB_WIDTH-1:0]    s_axis_tx_tstrb,
    input  wire [3:0]               s_axis_tx_tuser,
    input  wire                     s_axis_tx_tlast,
    input  wire                     s_axis_tx_tvalid,

    output wire [C_DATA_WIDTH-1:0]  m_axis_rx_tdata,
    output wire [STRB_WIDTH-1:0]    m_axis_rx_tstrb,
    output wire                     m_axis_rx_tlast,
    output wire                     m_axis_rx_tvalid,
    input  wire                     m_axis_rx_tready,
    output wire [21:0]              m_axis_rx_tuser,

    input  wire                     interrupt_req,
    output wire                     interrupt_rdy,

    output wire [15:0]              cfg_completer_id,
    output wire [7:0]               cfg_bus_number,
    output wire [4:0]               cfg_device_number,
    output wire [2:0]               cfg_function_number,
    output wire [15:0]              cfg_dcommand,

    output wire [7:0]               pci_exp_txp,
    input  wire [7:0]               pci_exp_rxp,

    input  wire                     sys_clk,
    input  wire                     sys_reset_n
);


    wire                            rx_st_sop;
    wire                            rx_st_eop;
    wire                            rx_st_err;
    wire                            rx_st_valid;
    wire [1:0]                      rx_st_empty;
    wire                            rx_st_ready;
    wire [255:0]                    rx_st_data;
    wire [7:0]                      rx_st_bar;
    wire                            rx_st_mask;

    wire                            tx_st_sop;
    wire                            tx_st_eop;
    wire                            tx_st_err;
    wire                            tx_st_valid;
    wire [1:0]                      tx_st_empty;
    wire [255:0]                    tx_st_data;
    wire                            tx_st_ready;

    wire                    [11:0]  tx_cred_datafccp;
    wire                    [11:0]  tx_cred_datafcnp;
    wire                    [11:0]  tx_cred_datafcp;
    wire                     [5:0]  tx_cred_fchipcons;
    wire                     [5:0]  tx_cred_fcinfinite;
    wire                     [7:0]  tx_cred_hdrfccp;
    wire                     [7:0]  tx_cred_hdrfcnp;
    wire                     [7:0]  tx_cred_hdrfcp;

    wire                     [7:0]  temp;
    wire                            temp_valid;

 
    //------------------------------------------------------
    // Wire for Altera PCIe
    //------------------------------------------------------
    // Reset and Link Status
    wire                            npor;
    wire                            dlup_exit;
    wire                            l2_exit;
    wire [4:0]                      ltssmstate;
    wire [1:0]                      currentspeed;
    wire                            reset_status;
    wire                            serdes_pll_locked;
    wire                            pld_clk_inuse;

    wire                            app_rstn;
    wire                            rs_hip_reset_status;
    wire                            rs_hip_reset_status_n;

    wire [3:0]                      tl_cfg_add;
    wire [31:0]                     tl_cfg_ctl;
    wire [52:0]                     tl_cfg_sts;
    wire [4:0]                      hpg_ctrler;

    wire [6:0]                      cpl_err;
    wire                            cpl_pending;

    wire                            pm_auxpwr;
    wire [9:0]                      pm_data;
    wire                            pme_to_cr;
    wire                            pm_event;

    wire                     [7:0]  ko_cpl_spc_header;
    wire                    [11:0]  ko_cpl_spc_data;

    wire [46*11-1:0]                reconfig_from_xcvr;
    wire [70*11-1:0]                reconfig_to_xcvr;

    wire                            app_int_sts;
    wire [4:0]                      app_msi_num;
    wire                            app_msi_req;
    wire [2:0]                      app_msi_tc;
    wire                            app_int_ack;
    wire                            app_msi_ack;

    wire [11:0]                     lmi_addr;
    wire [31:0]                     lmi_din;
    wire                            lmi_rden;
    wire                            lmi_wren;
    wire                            lmi_ack;
    wire [31:0]                     lmi_dout;


    localparam PCIE_DEVICE_ID            = 16'h0800;
    localparam PCIE_SUBSYSTEM_DEVICE_ID  = `ifdef PICO_FPGA_A9 16'h20a9; 
                                           `elsif PICO_FPGA_A7 16'h20a7;
                                           `else               16'h0;
                                           `endif

    localparam REV_ID                    = 5;
    //----------------------------------------------------------------------//
    // Altera Stratix V PCIe Core
    //----------------------------------------------------------------------//
    pcie_s5_v13_0_8lane_gen3 #(
        .DEVICE_ID(PCIE_DEVICE_ID),
        .SUBSYSTEM_DEVICE_ID(PCIE_SUBSYSTEM_DEVICE_ID),
        .REV_ID(REV_ID)
    ) core (
        
        // Reset and Link Status
        .npor                       (npor),
        .pin_perst                  (sys_reset_n),
        //.dlup                       (), 
        .dlup_exit                  (dlup_exit),
        //.ev128ns                    (),     
        //.ev1us                      (),     
        //.hotrst_exit                (),     
        .l2_exit                    (l2_exit),
        //.lane_act                   (),     
        .ltssmstate                 (ltssmstate),
        .currentspeed               (currentspeed),
        .reset_status               (reset_status),
        .serdes_pll_locked          (serdes_pll_locked),
        .pld_clk_inuse              (pld_clk_inuse),
        .pld_core_ready             (serdes_pll_locked),
        
        // Clocks
        .pld_clk                    (user_clk),
        .coreclkout_hip             (user_clk),
        .refclk                     (sys_clk),

        // Test Interface
        .test_in                    (32'h0),

        .hpg_ctrler                 (hpg_ctrler),
        .tl_cfg_add                 (tl_cfg_add),
        .tl_cfg_ctl                 (tl_cfg_ctl),
        .tl_cfg_sts                 (tl_cfg_sts),

        .cpl_err                    (cpl_err),
        .cpl_pending                (cpl_pending),

        .pm_auxpwr                  (pm_auxpwr),
        .pm_data                    (pm_data),
        .pme_to_cr                  (pme_to_cr),
        .pm_event                   (pm_event),
        //.pme_to_sr                  (pme_to_sr),

        .rx_st_sop                  (rx_st_sop),
        .rx_st_eop                  (rx_st_eop),
        .rx_st_err                  (rx_st_err),
        .rx_st_valid                (rx_st_valid),
        .rx_st_empty                (rx_st_empty),
        .rx_st_ready                (rx_st_ready),
        .rx_st_data                 (rx_st_data),
        .rx_st_bar                  (rx_st_bar),
        .rx_st_mask                 (rx_st_mask),

        .tx_st_sop                  (tx_st_sop),
        .tx_st_eop                  (tx_st_eop),
        .tx_st_err                  (tx_st_err),
        .tx_st_valid                (tx_st_valid),
        .tx_st_empty                (tx_st_empty),
        .tx_st_ready                (tx_st_ready),
        .tx_st_data                 (tx_st_data),

        .tx_cred_datafccp           (tx_cred_datafccp),
        .tx_cred_datafcnp           (tx_cred_datafcnp),
        .tx_cred_datafcp            (tx_cred_datafcp),
        .tx_cred_fchipcons          (tx_cred_fchipcons),
        .tx_cred_fcinfinite         (tx_cred_fcinfinite),
        .tx_cred_hdrfccp            (tx_cred_hdrfccp),
        .tx_cred_hdrfcnp            (tx_cred_hdrfcnp),
        .tx_cred_hdrfcp             (tx_cred_hdrfcp),
        .ko_cpl_spc_header          (ko_cpl_spc_header),
        .ko_cpl_spc_data            (ko_cpl_spc_data),


        .reconfig_to_xcvr           (reconfig_to_xcvr),
        .reconfig_from_xcvr         (reconfig_from_xcvr),

        .app_int_sts                (app_int_sts),
        .app_msi_num                (app_msi_num),
        .app_msi_req                (app_msi_req),
        .app_msi_tc                 (app_msi_tc),
        .app_int_ack                (app_int_ack),
        .app_msi_ack                (app_msi_ack),

        .lmi_addr                   (lmi_addr),
        .lmi_din                    (lmi_din),
        .lmi_rden                   (lmi_rden),
        .lmi_wren                   (lmi_wren),
        .lmi_ack                    (lmi_ack),
        .lmi_dout                   (lmi_dout),
                                    
        // RX Pins                  
        .rx_in0                     (pci_exp_rxp[0]),
        .rx_in1                     (pci_exp_rxp[1]),
        .rx_in2                     (pci_exp_rxp[2]),
        .rx_in3                     (pci_exp_rxp[3]),
        .rx_in4                     (pci_exp_rxp[4]),
        .rx_in5                     (pci_exp_rxp[5]),
        .rx_in6                     (pci_exp_rxp[6]),
        .rx_in7                     (pci_exp_rxp[7]),
                                    
        // TX Pins                  
        .tx_out0                    (pci_exp_txp[0]),
        .tx_out1                    (pci_exp_txp[1]),
        .tx_out2                    (pci_exp_txp[2]),
        .tx_out3                    (pci_exp_txp[3]),
        .tx_out4                    (pci_exp_txp[4]),
        .tx_out5                    (pci_exp_txp[5]),
        .tx_out6                    (pci_exp_txp[6]),
        .tx_out7                    (pci_exp_txp[7])
    ); 
    //-------------------------------------------------------
    // Reset Module for application
    //-------------------------------------------------------   

    altpcierd_hip_rs rs_hip (
        .npor               (rs_hip_reset_status_n & pld_clk_inuse),
        .pld_clk            (user_clk),
        .dlup_exit          (dlup_exit),
        .hotrst_exit        (rs_hip_reset_status_n),
        .l2_exit            (l2_exit),
        .ltssm              (ltssmstate),
        .app_rstn           (app_rstn),
        .test_sim           (1'b0)
    );

    assign user_reset    = ~app_rstn;
    assign user_lnk_up   =  app_rstn;

    altera_reset_synchronizer # (
        .ASYNC_RESET        (1'b1),
        .DEPTH              (2'h2)
    ) rs_status (
        .reset_in           (reset_status),
        .clk                (user_clk),
        .reset_out          (rs_hip_reset_status)
    );

    assign rs_hip_reset_status_n = ~rs_hip_reset_status;

    //-------------------------------------------------------
    // Reset Module for PCIe Hard Core
    //      - Use this module to generate npor
    //-------------------------------------------------------   
   
    altera_reset_synchronizer # (
        .ASYNC_RESET        (1'b1),
        .DEPTH              (2'h2)
    ) rs_pcie (
        .reset_in           (sys_reset_n & serdes_pll_locked),
        .clk                (sys_clk),
        .reset_out          (npor)
    );

    // core tie-offs
    
    // Transaction Layer Configuration
    assign hpg_ctrler       = 5'h0;

    // Completion Interface,
    assign cpl_err          = 8'h0;
    assign cpl_pending      = 1'b0;

    // Power Management,
    assign pm_auxpwr        = 1'b0;
    assign pm_data          = 10'h0;
    assign pme_to_cr        = 1'b0;
    assign pm_event         = 1'b0;

    
    // RX Port
    assign rx_st_mask       = 1'b0;

    // TX Port,
    assign tx_st_err        = 1'b0;


    // Transceiver Configuration,
    assign reconfig_to_xcvr = 770'h0;

    // Interrupt for Endpoints,
    assign app_int_sts      = 1'b0;
    assign app_msi_num      = 5'h0;
    assign app_msi_req      = interrupt_req;
    assign app_msi_tc       = 3'h0;
    assign interrupt_rdy    = app_msi_ack;

    // LMI,
    assign lmi_addr         = 12'h0;
    assign lmi_din          = 32'h0;
    assign lmi_rden         = 1'b0;
    assign lmi_wren         = 1'b0;

    // get the bus/device number & the content of device control
    // register from PCIe capability structure
    reg [12:0]              cfg_busdev = 0;
    reg [15:0]              cfg_devctrl = 0;
    // pld_clk is tied to user_clk, thus no cross clock domain problem
    always @ (posedge user_clk) begin 
        if (tl_cfg_add == 4'h0) cfg_devctrl <= tl_cfg_ctl[31:16];
        if (tl_cfg_add == 4'hF) cfg_busdev  <= tl_cfg_ctl[12:0];
    end

    assign cfg_bus_number[7:0]      = cfg_busdev[12:5];
    assign cfg_device_number[4:0]   = cfg_busdev[4:0];
    assign cfg_function_number[2:0] = 3'h0;
    assign cfg_completer_id         = { cfg_bus_number, cfg_device_number, cfg_function_number };
    assign cfg_dcommand             = cfg_devctrl;



    altera_pcie_axis2st axis2st (
        .clk                ( user_clk          ),
        .rst                ( user_reset        ),

        .s_axis_tx_tready   ( s_axis_tx_tready  ),
        .s_axis_tx_tdata    ( s_axis_tx_tdata   ),
        .s_axis_tx_tstrb    ( s_axis_tx_tstrb   ),
        .s_axis_tx_tuser    ( s_axis_tx_tuser   ),
        .s_axis_tx_tlast    ( s_axis_tx_tlast   ),
        .s_axis_tx_tvalid   ( s_axis_tx_tvalid  ),

        .tx_st_data         ( tx_st_data        ),
        .tx_st_sop          ( tx_st_sop         ),
        .tx_st_eop          ( tx_st_eop         ),
        .tx_st_empty        ( tx_st_empty       ),
        .tx_st_valid        ( tx_st_valid       ),
        .tx_st_ready        ( tx_st_ready       )
    );

    altera_pcie_st2axis st2axis (
        .clk                ( user_clk          ),
        .rst                ( user_reset        ),

        .m_axis_rx_tdata    ( m_axis_rx_tdata   ),
        .m_axis_rx_tstrb    ( m_axis_rx_tstrb   ),
        .m_axis_rx_tlast    ( m_axis_rx_tlast   ),
        .m_axis_rx_tvalid   ( m_axis_rx_tvalid  ),
        .m_axis_rx_tready   ( m_axis_rx_tready  ),
        .m_axis_rx_tuser    ( m_axis_rx_tuser   ),

        .rx_st_data         ( rx_st_data        ),
        .rx_st_sop          ( rx_st_sop         ),
        .rx_st_eop          ( rx_st_eop         ),
        .rx_st_valid        ( rx_st_valid       ),
        .rx_st_bar          ( rx_st_bar         ),
        .rx_st_ready        ( rx_st_ready       ),
        .rx_st_empty        ( rx_st_empty       )
    );



endmodule

