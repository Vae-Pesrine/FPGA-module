module GetFourBtnEdge #(
    parameter FREQUENCY_IN = 100_000_000
)
(
    input  wire clk,
    input  wire rst,
    input  wire [3:0] btns_in,
    output wire [3:0] btnUpEdges_out,
    output wire [3:0] btnDownEdges_out
);

KeyProcess #(
    .FREQUENCY_IN     (FREQUENCY_IN)
)KeyProcess_ISR0
(
    .clk        (clk),
    .rst        (rst),
    .btn_in     (btns_in[0]),
    .btn_LH_out (btnUpEdges_out[0]),
    .btn_HL_out (btnDownEdges_out[0])
);
KeyProcess #(
    .FREQUENCY_IN     (FREQUENCY_IN)
)KeyProcess_ISR1
(
    .clk        (clk),
    .rst        (rst),
    .btn_in     (btns_in[1]),
    .btn_LH_out (btnUpEdges_out[1]),
    .btn_HL_out (btnDownEdges_out[1])
);
KeyProcess #(
    .FREQUENCY_IN     (FREQUENCY_IN)
)KeyProcess_ISR2
(
    .clk        (clk),
    .rst        (rst),
    .btn_in     (btns_in[2]),
    .btn_LH_out (btnUpEdges_out[2]),
    .btn_HL_out (btnDownEdges_out[2])
);
KeyProcess #(
    .FREQUENCY_IN     (FREQUENCY_IN)
)KeyProcess_ISR3
(
    .clk        (clk),
    .rst        (rst),
    .btn_in     (btns_in[3]),
    .btn_LH_out (btnUpEdges_out[3]),
    .btn_HL_out (btnDownEdges_out[3])
);

endmodule