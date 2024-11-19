//八位数码管显示
module EightLedCtrl#(
    parameter   FREQUENCY_IN    =   50_000_000
)
(
    input   wire        clk,
    input   wire        rst,
    input   wire [31:0] bcdCoder_in,
    input   wire [7:0]  hasDot_in,
    
    output  wire [3:0]  high_seg_cs_out,
    output  wire [7:0]  high_seg_data_out,
    output  wire [3:0]  low_seg_cs_out,
    output  wire [7:0]  low_seg_data_out
);

FourLedCtrl#(
    .FREQUENCY_IN       (FREQUENCY_IN)
)FourLedCtrl_ISRHigh(
    .clk                (clk),
    .rst                (rst),
    .bcdCoder_in        (bcdCoder_in[31:16]),
    .hasDot_in          (hasDot_in[7:4]),
    
    .seg_cs_out         (high_seg_cs_out),
    .seg_data_out       (high_seg_data_out)
);

FourLedCtrl#(
    .FREQUENCY_IN       (FREQUENCY_IN)
)FourLedCtrl_ISRLow(
    .clk                (clk),
    .rst                (rst),
    .bcdCoder_in        (bcdCoder_in[15:0]),
    .hasDot_in          (hasDot_in[3:0]),
    
    .seg_cs_out         (low_seg_cs_out),
    .seg_data_out       (low_seg_data_out)
);

endmodule


    //how to use
    // .high_seg_cs_out    (high_seg_cs_out),
    // .high_seg_data_out  (high_seg_data_out),
    // .low_seg_cs_out     (low_seg_cs_out),
    // .low_seg_data_out   (low_seg_data_out)

    // set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {high_seg_cs_out[0]}]
    // set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS33} [get_ports {high_seg_cs_out[1]}]
    // set_property -dict {PACKAGE_PIN C1 IOSTANDARD LVCMOS33} [get_ports {high_seg_cs_out[2]}]
    // set_property -dict {PACKAGE_PIN H1 IOSTANDARD LVCMOS33} [get_ports {high_seg_cs_out[3]}]

    // set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {low_seg_cs_out[0]}]
    // set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports {low_seg_cs_out[1]}]
    // set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports {low_seg_cs_out[2]}]
    // set_property -dict {PACKAGE_PIN G6 IOSTANDARD LVCMOS33} [get_ports {low_seg_cs_out[3]}]

    // set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS33} [get_ports {high_seg_data_out[0]}]
    // set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS33} [get_ports {high_seg_data_out[1]}]
    // set_property -dict {PACKAGE_PIN A3 IOSTANDARD LVCMOS33} [get_ports {high_seg_data_out[2]}]
    // set_property -dict {PACKAGE_PIN B1 IOSTANDARD LVCMOS33} [get_ports {high_seg_data_out[3]}]
    // set_property -dict {PACKAGE_PIN A1 IOSTANDARD LVCMOS33} [get_ports {high_seg_data_out[4]}]
    // set_property -dict {PACKAGE_PIN B3 IOSTANDARD LVCMOS33} [get_ports {high_seg_data_out[5]}]
    // set_property -dict {PACKAGE_PIN B2 IOSTANDARD LVCMOS33} [get_ports {high_seg_data_out[6]}]
    // set_property -dict {PACKAGE_PIN D5 IOSTANDARD LVCMOS33} [get_ports {high_seg_data_out[7]}]

    // set_property -dict {PACKAGE_PIN D4 IOSTANDARD LVCMOS33} [get_ports {low_seg_data_out[0]}]
    // set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports {low_seg_data_out[1]}]
    // set_property -dict {PACKAGE_PIN D3 IOSTANDARD LVCMOS33} [get_ports {low_seg_data_out[2]}]
    // set_property -dict {PACKAGE_PIN F4 IOSTANDARD LVCMOS33} [get_ports {low_seg_data_out[3]}]
    // set_property -dict {PACKAGE_PIN F3 IOSTANDARD LVCMOS33} [get_ports {low_seg_data_out[4]}]
    // set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} [get_ports {low_seg_data_out[5]}]
    // set_property -dict {PACKAGE_PIN D2 IOSTANDARD LVCMOS33} [get_ports {low_seg_data_out[6]}]
    // set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS33} [get_ports {low_seg_data_out[7]}]