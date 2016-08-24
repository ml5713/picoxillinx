// asyncFifoBRAM.v
// a wrapper of new async_fifo.sv for supporting legacy source codes


module asyncFifoBRAM #(
        parameter WIDTH         = 128,      // range = 1 - 360
        parameter OFFSET        = 13'h10    // valid range = 4 to 507
    )
    (
    // ports
    input  wire             wr_clk,
    input  wire             wr_rst,
    input  wire             rd_clk,
    input  wire             rd_rst,
    input  wire [WIDTH-1:0] din,
    input  wire             wr_en,
    input  wire             rd_en,
    output wire [WIDTH-1:0] dout,
    output wire             full,
    output wire             empty
    );

    FIFO # (
        .SYNC(0),
        .DATA_WIDTH(WIDTH),
        .ALMOST_FULL(13'h200 - OFFSET),
        .ALMOST_EMPTY(OFFSET)
    ) _fifo_ (
        .wr_clk(wr_clk),
        .wr_rst(wr_rst),
        .rd_clk(rd_clk),
        .rd_rst(rd_rst),
        .din(din),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .dout(dout),
        .almostfull(full),
        .almostempty(empty)
    );

endmodule
