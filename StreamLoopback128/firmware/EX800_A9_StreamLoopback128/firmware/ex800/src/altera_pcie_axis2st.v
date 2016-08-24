// altera_pcie_axis2st.v
// Copyright 2014 Pico Computing, Inc.

module altera_pcie_axis2st (
    input  wire                     clk,
    input  wire                     rst,
    
    output wire                     s_axis_tx_tready,
    input  wire [127:0]             s_axis_tx_tdata,
    input  wire [15:0]              s_axis_tx_tstrb,
    input  wire [3:0]               s_axis_tx_tuser,
    input  wire                     s_axis_tx_tlast,
    input  wire                     s_axis_tx_tvalid,

    output reg             [255:0]  tx_st_data = 0,
    output reg                      tx_st_sop = 0,
    output reg                      tx_st_eop = 0,
    input  wire                     tx_st_ready,
    output reg                      tx_st_valid = 0,
    output reg               [1:0]  tx_st_empty = 0
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

    // we need to infer sop from tlast
    reg tfirst = 1;
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            tfirst <= 1;
        end else begin
            if (s_axis_tx_tvalid && s_axis_tx_tready) begin
                tfirst <= s_axis_tx_tlast;
            end
        end
    end

    reg tready = 0;
    reg [127:0] tdata_q [2:0];
    reg [2:0] tvalid_q = 0;
    reg [31:0] dw1;
    reg [2:0] tsop_q = 0, teop_q = 0;
    reg [3:0] tstrb_q [2:0];
    reg halt_next = 0;
    reg hold_ready = 0;
    reg has_payload = 0;
    reg long_hdr = 0;
    reg unaligned = 0;
    reg shift = 0, shift_q = 0;
    reg extra_data = 0, extra_data_q = 0;
    reg tempty = 0;
    assign s_axis_tx_tready = tready & ~hold_ready;

    integer i;
    initial begin
        for (i=0;i<3;i=i+1) begin
            tdata_q[i] <= 0;
            tstrb_q[i] <= 0;
        end
    end 

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            tvalid_q <= 0;
            tsop_q <= 0;
            teop_q <= 0;
            halt_next <= 0;
            hold_ready <= 0;
            has_payload <= 0;
            long_hdr <= 0;
            unaligned <= 0;
            shift <= 0;
            shift_q <= 0;
            extra_data <= 0;
            extra_data_q <= 0;
            tempty <= 0;
        end else begin
            tdata_q[0]  <= s_axis_tx_tdata;
            tvalid_q[0] <= s_axis_tx_tvalid & s_axis_tx_tready;
            tsop_q[0]   <= tfirst & s_axis_tx_tvalid & s_axis_tx_tready;
            teop_q[0]   <= s_axis_tx_tlast & s_axis_tx_tvalid & s_axis_tx_tready;
            tstrb_q[0]  <= {s_axis_tx_tstrb[12], s_axis_tx_tstrb[8], s_axis_tx_tstrb[4], s_axis_tx_tstrb[0]};

            // insert one cycle after receiving a packet with 4-DW header and unaligned address and greater than 3DW payload 
            // or 3-DW header and aligned address and 1DW payload
            // b/c we need to use an extra 128-bit chunk to store shifted data.
            // in our framework, the lenght can only be either 1 or multiple of 4, therefore we don't have to check the entire lenght field
            hold_ready <= 0;
            if (s_axis_tx_tvalid & s_axis_tx_tready) begin
                if (tfirst) begin
                    halt_next  <= s_axis_tx_tdata[30] & // has payload
                        s_axis_tx_tdata[29] &  s_axis_tx_tdata[96+2] & ~s_axis_tx_tdata[0]; // 4-DW header, unaligned address and multiple of 4DW payload
                    hold_ready <= s_axis_tx_tdata[30] & // has payload
                        s_axis_tx_tlast & ~s_axis_tx_tdata[29] & ~s_axis_tx_tdata[64+2] &  s_axis_tx_tdata[0]; // 3-DW header, aligned address and 1DW payload
                end else if (s_axis_tx_tlast) begin
                    hold_ready <= halt_next;
                end
            end

            has_payload <= s_axis_tx_tdata[30] & tfirst;
            long_hdr    <= s_axis_tx_tdata[29] & tfirst;
            unaligned   <= (s_axis_tx_tdata[29] ? s_axis_tx_tdata[96+2] : s_axis_tx_tdata[64+2]) & tfirst;
            if (tfirst && s_axis_tx_tvalid && s_axis_tx_tready) begin
                shift <= s_axis_tx_tdata[30] & (s_axis_tx_tdata[29] ? s_axis_tx_tdata[96+2] : ~s_axis_tx_tdata[64+2]);
            end

            // TLP data/payload re-alignment pipeline
            tdata_q[1][95:0]  <= tsop_q[0] ? tdata_q[0][95:0] : swizzle(tdata_q[0][95:0]);
            tdata_q[1][96+:32] <= long_hdr ? tdata_q[0][96+:32] : swizzle(tdata_q[0][96+:32]);
            tvalid_q[1] <= tvalid_q[0];
            tsop_q[1] <= tsop_q[0];
            teop_q[1] <= teop_q[0];
            tstrb_q[1] <= tstrb_q[0];
            shift_q <= ~tsop_q[0] & shift;
            extra_data <= 0;
            if (teop_q[0]) begin
                extra_data <= halt_next | hold_ready;
            end

            tdata_q[2] <= shift_q ? {tdata_q[1][0+:96], dw1} : tdata_q[1];
            tempty <= extra_data_q | (~extra_data & teop_q[1] & ~tstrb_q[1][2]);
            dw1 <= tdata_q[1][96+:32];
            tsop_q[2] <= tsop_q[1];
            tvalid_q[2] <= tvalid_q[1] | extra_data_q;
            teop_q[2] <= extra_data_q | (~extra_data & teop_q[1]);
            extra_data_q <= extra_data;
        end
    end

    reg  fifo_wren;
    wire fifo_rden;
    wire fifo_empty;
    wire fifo_almostfull;
    reg [127:0] fifo_in_tdata0, fifo_in_tdata1;
    reg fifo_in_sop, fifo_in_eop;
    reg [1:0] fifo_in_empty;
    wire [255:0] fifo_out_tdata;
    wire fifo_out_sop, fifo_out_eop;
    wire [1:0] fifo_out_empty;

    FIFO # (
        .DATA_WIDTH(256+4),
        .USE_BLOCK_RAM (0),
        .DATA_DEPTH(32),
        .ALMOST_FULL(16)
    ) fifo (
        .clk (clk),
        .rst (rst),
        .wr_en (fifo_wren),
        .rd_en (fifo_rden),
        .empty (fifo_empty),
        .almostfull (fifo_almostfull),
        .din ({fifo_in_empty, fifo_in_eop, fifo_in_sop, fifo_in_tdata1, fifo_in_tdata0}),
        .dout ({fifo_out_empty, fifo_out_eop, fifo_out_sop, fifo_out_tdata})
    );
    
    reg dsel = 0;
    reg fifo_ready = 0;
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            dsel <= 0;
            fifo_ready <= 0;
        end else begin
            fifo_ready <= ~fifo_almostfull;
            // make sure we don't deassert ready signal in the middle of a packet
            if (s_axis_tx_tready) begin
                if (s_axis_tx_tvalid && s_axis_tx_tlast) tready <= fifo_ready;
            end else begin
                tready <= fifo_ready;
            end

            if (tvalid_q[2]) begin
                dsel <= teop_q[2] ? 0 : ~dsel;
            end

            fifo_wren <= tvalid_q[2] & (dsel | teop_q[2]);

            fifo_in_eop <= teop_q[2];
            if (dsel) begin
                fifo_in_tdata1 <= tdata_q[2];
                fifo_in_empty <= {1'b0, tempty};
            end else begin
                fifo_in_tdata0 <= tdata_q[2];
                fifo_in_sop <= tsop_q[2];
                fifo_in_empty <= {1'b1, tempty};
            end
        end
    end

    reg [4:0] seq, last_seq, last_seq_q, last_seq_q1, last_seq_q2;
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            seq <= 0;
            last_seq <= 0;
        end else begin
            if (fifo_wren && fifo_in_eop) begin
                last_seq <= last_seq + 1;
            end
            last_seq_q <= last_seq;
            last_seq_q1 <= last_seq_q;
            last_seq_q2 <= last_seq_q1;

            if (fifo_rden && fifo_out_eop) begin
                seq <= seq + 1;
            end
        end
    end

    wire fc_ok = seq != last_seq_q2;

    reg tx_st_ready_q;

    assign fifo_rden = fc_ok && tx_st_ready_q;

    always @ (posedge clk) begin
        tx_st_ready_q   <= tx_st_ready;
        tx_st_data      <= fifo_out_tdata;
        if (fifo_rden) begin
            tx_st_sop   <= fifo_out_sop;
            tx_st_eop   <= fifo_out_eop;
            tx_st_empty <= fifo_out_empty;
            tx_st_valid <= 1'b1;
        end else begin
            tx_st_valid <= 1'b0;
            tx_st_sop   <= 1'b0;
            tx_st_eop   <= 1'b0;
        end
    end

endmodule

