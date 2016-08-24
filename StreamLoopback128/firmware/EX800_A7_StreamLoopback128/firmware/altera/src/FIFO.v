// FIFO.v
// Copyright 2014, Pico Computing, Inc.

module FIFO # (
    parameter SYNC = 1,
    parameter DATA_WIDTH = 128,
    parameter DATA_DEPTH = 512,
    parameter USE_BLOCK_RAM = 1,
    parameter ALMOST_FULL = 13'h100,
    parameter ALMOST_EMPTY = 13'h10
) (
    input  wire                     clk,
    input  wire                     rst,

    input  wire                     wr_clk,
    input  wire                     wr_rst,
    input  wire                     wr_en,
    input  wire  [DATA_WIDTH-1:0]   din,
    output wire                     full,
    output wire                     almostfull,

    input  wire                     rd_clk,
    input  wire                     rd_rst,
    input  wire                     rd_en,
    output wire  [DATA_WIDTH-1:0]   dout,
    output wire                     empty,
    output wire                     almostempty
    
);

    function integer clogb2;
        input [31:0] value;
        begin
            value = value - 1;
            for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) begin
                value = value >> 1;
            end
        end
    endfunction

    localparam LPM_HINT = USE_BLOCK_RAM ? "RAM_BLOCK_TYPE=M20K,MAXIMUM_DEPTH=512" : "RAM_BLOCK_TYPE=MLAB,MAXIMUM_DEPTH=32";
    localparam INT_ALMOST_FULL = DATA_DEPTH > ALMOST_FULL ? ALMOST_FULL : DATA_DEPTH >> 2;
    localparam INT_ALMOST_EMPTY = DATA_DEPTH > ALMOST_EMPTY ? ALMOST_EMPTY : DATA_DEPTH >> 2;

    generate if (SYNC) begin
        scfifo # (
            .add_ram_output_register    ("ON"),
            .intended_device_family     ("Stratix V"),
            .almost_empty_value         (INT_ALMOST_EMPTY),
            .almost_full_value          (INT_ALMOST_FULL),
            .lpm_hint                   (LPM_HINT),
            .lpm_numwords               (DATA_DEPTH),
            .lpm_showahead              ("ON"),
            .lpm_type                   ("scfifo"),
            .lpm_width                  (DATA_WIDTH),
            .lpm_widthu                 (clogb2(DATA_DEPTH)),
            .overflow_checking          ("ON"),
            .underflow_checking         ("ON"),
            .use_eab                    ("ON")
        ) __sync_fifo__ (
            .clock                      (clk),
            .aclr                       (rst),
            .data                       (din),
            .rdreq                      (rd_en),
            .wrreq                      (wr_en),
            .usedw                      (),
            .empty                      (empty),
            .almost_empty               (almostempty),
            .full                       (full),
            .almost_full                (almostfull),
            .q                          (dout)
        );
    end else begin
            wire [8:0] rdusedw, wrusedw;
            reg ae=1, af=0;
            assign almostfull = af;
            assign almostempty = ae;

            always @(posedge rd_clk) begin
                if (rd_rst) begin
                    ae <= 1;
                end else begin
                    ae <= rdusedw <= INT_ALMOST_EMPTY;
                end
            end

            always @(posedge wr_clk) begin
                if (wr_rst) begin
                    af <= 0;
                end else begin
                    af <= wrusedw >= INT_ALMOST_FULL;
                end
            end

            dcfifo # (
                .add_ram_output_register("ON"),
                .intended_device_family ("Stratix V"),
                .lpm_numwords           (512),
                .lpm_showahead          ("ON"),
                .lpm_type               ("dcfifo"),
                .lpm_width              (DATA_WIDTH),
                .lpm_widthu             (9),
                .overflow_checking      ("ON"),
                .rdsync_delaypipe       (4),
                .underflow_checking     ("ON"),
                .use_eab                ("ON"),
                .wrsync_delaypipe       (4)
            ) __async_fifo__ (
                .data                   (din),
                .rdclk                  (rd_clk),
                .rdreq                  (rd_en),
                .wrclk                  (wr_clk),
                .wrreq                  (wr_en),
                .wrfull                 (full),
                .q                      (dout),
                .rdempty                (empty),
                .aclr                   (wr_rst | rd_rst),
                .rdfull                 (),
                .rdusedw                (rdusedw),
                .wrempty                (),
                .wrusedw                (wrusedw)
            );
    end endgenerate

endmodule

