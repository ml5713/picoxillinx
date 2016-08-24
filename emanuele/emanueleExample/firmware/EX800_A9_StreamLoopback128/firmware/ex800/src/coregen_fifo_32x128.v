// coregen_fifo_32x128.v
// Copyright 2014, Pico Computing, Inc.
//
// Altera's version


module coregen_fifo_32x128 (
    input  wire             clk,
    input  wire             rst,
    input  wire [127:0]     din,
    input  wire             wr_en,
    input  wire             rd_en,
    output wire [127:0]     dout,
    output wire             full,
    output wire             empty
);

    FIFO #(.DATA_WIDTH(128),
        .DATA_DEPTH(32),
        .USE_BLOCK_RAM(0)
    ) fifo (
        .clk        (clk),
        .rst        (rst),
        .din        (din),
        .wr_en      (wr_en),
        .rd_en      (rd_en),
        .dout       (dout),
        .full       (full),
        .empty      (empty)
    );

endmodule

