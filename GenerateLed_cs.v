//产生位选信号
module GenerateLed_cs # (
    parameter FREQUENCY_IN =   50_000_000
)
(
    input  wire         clk,
    input  wire         rst,
    output wire [3:0]   seg_cs_out
);

wire        refreshClk;
wire [31:0] counterTmp;

FrequencyDivisionPulse # (
    .FREQUENCY_IN         (FREQUENCY_IN),
    .FREQUENCY_OUT        (32'd1000)
)T0_refreshClk_ISRO(
    .clk        (clk),
    .rst        (rst),
    .clk_out    (refreshClk)
);

UniversalCounter#(
    .MAX_NUM        (4),
    .COUNTER_BITS   (1)
)Counter_ISRO(
    .clk            (clk),
    .rst            (rst),
    .en_in          (refreshClk),
    .dir_in         (1'b1),
    .loadCmd_in     (1'b0),
    .loadValue_in   (32'd0),
    .counter_out    (counterTmp),
    .tc_out         ()
);

wire    [3:0]   inter_seg_cs;
Decoder2_4 Decoder_ISRO(
    .coder_in       (counterTmp[1:0]),
    .decoder_out    (inter_seg_cs)
);

assign seg_cs_out = (~rst) ? inter_seg_cs : 4'b0000;

endmodule
