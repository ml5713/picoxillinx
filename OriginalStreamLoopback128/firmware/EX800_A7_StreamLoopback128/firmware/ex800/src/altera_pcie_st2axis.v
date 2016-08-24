// altera_pcie_st2axis.v
// Copyright 2014 Pico Computing, Inc.


module altera_pcie_st2axis (
    input  wire                     clk,
    input  wire                     rst,
    
    input  wire            [255:0]  rx_st_data,
    input  wire                     rx_st_sop,
    input  wire                     rx_st_eop,
    output reg                      rx_st_ready = 1,
    input  wire                     rx_st_valid,
    input  wire              [7:0]  rx_st_bar,
    input  wire              [1:0]  rx_st_empty,

    output reg  [127:0]             m_axis_rx_tdata,
    output reg  [15:0]              m_axis_rx_tstrb = 0,
    output reg                      m_axis_rx_tlast = 0,
    output reg                      m_axis_rx_tvalid = 0,
    input  wire                     m_axis_rx_tready,
    output reg  [21:0]              m_axis_rx_tuser = 0
);

    function [127:0] swizzle;
        input [127:0] data;
        begin
            swizzle = {
                data[96 +: 8],
                data[104+: 8],
                data[112+: 8],
                data[120+: 8],
                data[64 +: 8],
                data[72 +: 8],
                data[80 +: 8],
                data[88 +: 8],
                data[32 +: 8],
                data[40 +: 8],
                data[48 +: 8],
                data[56 +: 8],
                data[0  +: 8],
                data[8  +: 8],
                data[16 +: 8],
                data[24 +: 8]
            };
        end 
    endfunction


    reg fifo_wren = 0;
    wire fifo_rden;
    wire fifo_empty;
    wire fifo_almostfull;
    reg [255:0] fifo_in_data;
    reg [7:0] fifo_in_bar;
    reg fifo_in_sop, fifo_in_eop;
    reg [1:0] fifo_in_empty;
    wire [127:0] fifo_out_data0, fifo_out_data1;
    wire [7:0] fifo_out_bar;
    wire fifo_out_sop, fifo_out_eop;
    wire [1:0] fifo_out_empty;

    FIFO # (
        .DATA_WIDTH(256+8+2+2),
        .ALMOST_FULL(9'h1f0)
    ) fifo (
        .clk (clk),
        .rst (rst),
        .wr_en (fifo_wren),
        .rd_en (fifo_rden),
        .empty (fifo_empty),
        .almostfull (fifo_almostfull),
        .din ({fifo_in_bar, fifo_in_empty, fifo_in_eop, fifo_in_sop, fifo_in_data}),
        .dout ({fifo_out_bar, fifo_out_empty, fifo_out_eop, fifo_out_sop, fifo_out_data1, fifo_out_data0})
    );

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            rx_st_ready <= 0;
            fifo_wren <= 0;
        end else begin
            rx_st_ready <= ~fifo_almostfull;
            fifo_in_data <= rx_st_data;
            fifo_in_sop <= rx_st_sop;
            fifo_in_eop <= rx_st_eop;
            fifo_in_bar <= rx_st_bar;
            fifo_in_empty <= rx_st_empty;
            fifo_wren <= rx_st_valid;
        end
    end

    reg dsel = 0;
    assign fifo_rden = dsel;

    reg [127:0] tdata_q [3:0];
    reg [7:0] tbar_q [3:0];
    reg [3:0] tvalid_q = 0;
    reg [3:0] tsop_q = 0;
    reg [3:0] teop_q = 0;
    reg [3:0] tempty_q = 0;
    reg shift = 0, shift_q = 0, short_shift = 0, suppress = 0, shift_last = 0, shift_lock = 0;
    reg long_hdr = 0, has_payload = 0, unaligned = 0;

    integer i;
    initial begin
        for (i=0;i<4;i=i+1) begin
            tdata_q[i] <= 0;
            tbar_q[i] <= 0;
        end
    end 

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            dsel <= 0;
            tvalid_q <= 0;
            tsop_q <= 0;
            teop_q <= 0;
            tempty_q <= 0;
            m_axis_rx_tuser <= 0;
            m_axis_rx_tvalid <= 0;
            m_axis_rx_tlast <= 0;
            shift <= 0;
            shift_q <= 0;
            short_shift <= 0;
            shift_last <= 0;
            shift_lock <= 0;
            suppress <= 0;
            has_payload <= 0;
            long_hdr <= 0;
            unaligned <= 0;
        end else begin
            if (!fifo_empty) begin
                dsel <= ~dsel;
                if (fifo_rden) begin
                    dsel <= 0;
                end
            end

            tdata_q[0] <= dsel ? fifo_out_data1 : fifo_out_data0;
            tvalid_q[0] <= dsel ? ~fifo_empty & ~fifo_out_empty[1] : ~fifo_empty;
            tsop_q[0] <= dsel ? 0 : fifo_out_sop & ~fifo_empty;
            teop_q[0] <= fifo_out_eop & ~fifo_empty & (dsel ? ~fifo_out_empty[1] : fifo_out_empty[1]);
            tempty_q[0] <= dsel ? fifo_out_empty[0] : fifo_out_empty[1] & fifo_out_empty[0];
            tbar_q[0] <= fifo_out_bar;

            has_payload <= tdata_q[0][30] & tsop_q[0];
            long_hdr    <= tdata_q[0][29] & tsop_q[0];
            unaligned     <= (tdata_q[0][29] ? tdata_q[0][96+2] : tdata_q[0][64+2]) & tsop_q[0];
            shift <= shift & shift_lock;
            if (tvalid_q[0]) begin
                shift_lock <= ~teop_q[0];
                if (tsop_q[0]) shift <= tdata_q[0][30] & (tdata_q[0][29] ? tdata_q[0][96+2] : ~tdata_q[0][64+2]);
            end
            tdata_q[1] <= tdata_q[0];
            tvalid_q[1] <= tvalid_q[0];
            tsop_q[1] <= tsop_q[0];
            teop_q[1] <= teop_q[0];
            tempty_q[1] <= tempty_q[0];
            tbar_q[1] <= tbar_q[0];

            tdata_q[2][0+:96] <= tsop_q[1] ? tdata_q[1][0+:96] : swizzle(tdata_q[1][0+:96]);
            tdata_q[2][96+:32] <= long_hdr ? tdata_q[1][96+:32] : swizzle(tdata_q[1][96+:32]);
            tvalid_q[2] <= tvalid_q[1];
            tsop_q[2] <= tsop_q[1];
            teop_q[2] <= teop_q[1];
            tempty_q[2] <= tempty_q[1];
            tbar_q[2] <= tbar_q[1];
            shift_q <= ~tsop_q[1] & shift;
            shift_last <= tsop_q[1] & has_payload & ~long_hdr & ~unaligned;
            if (tsop_q[1]) begin
                short_shift <= has_payload &
                    (( long_hdr &  unaligned & ~tdata_q[1][0]) | // 4-DW header, unaligned address and multiple of 4DW payload
                     (~long_hdr & ~unaligned &  tdata_q[1][0])); // 3-DW header, aligned address and 1DW payload
            end else if (teop_q[1]) begin
                short_shift <= 0;
            end
            suppress <= teop_q[1] & short_shift;

            tdata_q[3][0 +:96] <= shift_q ? tdata_q[2][32+:96] : tdata_q[2][0+:96];
            tdata_q[3][96+:32] <= (shift_q || shift_last) ? swizzle(tdata_q[1][0+:32]) : tdata_q[2][96+:32];
            tsop_q[3] <= tsop_q[2];
            teop_q[3] <= (short_shift ? teop_q[1] : teop_q[2]) & ~suppress;
            tvalid_q[3] <= (short_shift ? tvalid_q[1] : tvalid_q[2]) & ~suppress;
            tbar_q[3] <= tbar_q[2];

            m_axis_rx_tdata <= tdata_q[3];
            m_axis_rx_tvalid <= tvalid_q[3];
            m_axis_rx_tlast <= teop_q[3];
            m_axis_rx_tuser[14] <= tsop_q[3];
            m_axis_rx_tuser[13] <= 0;
            m_axis_rx_tuser[9:2] <= tbar_q[3];
            m_axis_rx_tuser[21] <= teop_q[3];
        end
    end

endmodule

