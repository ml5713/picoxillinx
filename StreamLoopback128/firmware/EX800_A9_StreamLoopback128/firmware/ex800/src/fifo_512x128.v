// fifo_512x128.v
// Copyright 2014, Pico Computing, Inc.

module fifo_512x128 #(
    parameter ALMOST_FULL_OFFSET = 13'h10
    ) (
    input  wire             clk,
    input  wire             rst,
    input  wire [127:0]     din,
    input  wire [15:0]      dinp,
    input  wire             wr_en,
    input  wire             rd_en,
    output wire [127:0]     dout,
    output wire [15:0]      doutp,
    output wire             full,
    output wire             empty_direct,
    output reg              empty = 1,
    output wire             prog_full,
    output wire             prog_empty
);
    // this empty logic has to be kept. if we directly connect 'empty' to 
    // FIFO's empty, some logic in framework won't work (e.g. system picobus)
    always @(posedge clk) begin
        empty       <= prog_empty && (empty_direct || rd_en);
    end

    FIFO #(.DATA_WIDTH(128 + 16),
        .DATA_DEPTH(512),
        .ALMOST_FULL (512 - ALMOST_FULL_OFFSET)
    ) fifo (
        .clk            (clk),
        .rst            (rst),
        .din            ({dinp, din}),
        .wr_en          (wr_en),
        .rd_en          (rd_en),
        .dout           ({doutp, dout}),
        .full           (full),
        .almostfull     (prog_full),
        .empty          (empty_direct),
        .almostempty    (prog_empty)
    );

endmodule

