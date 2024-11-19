module AdjustableTimerHMS #(
    parameter FREQUENCY_IN = 100_000_000
)
(
    input  wire       clk,
    input  wire       rst,
    input  wire       en_in,
    input  wire       adjustCmd_in,
    inout  wire [7:0] bcdSecond_io,
    inout  wire [7:0] bcdMinute_io,
    inout  wire [7:0] bcdHour_io
);  

wire clk1HzPulse;
FrequencyDivisionPulse #(
    .FREQUENCY_IN    (FREQUENCY_IN),
    .FREQUENCY_OUT   (32'd1)
)
To_1HzPulse_ISR0
(
    .clk     (clk),
    .rst     (rst),
    .clk_out (clk1HzPulse)
);

wire        tc_hour;
wire        tc_min;
wire [31:0] hours;
wire [31:0] minutes;
wire [31:0] seconds;

wire [7:0] hours_bcd;
wire [7:0] minutes_bcd;
wire [7:0] seconds_bcd;
wire [7:0] hourTmp;
wire [7:0] minuteTmp;
wire [7:0] secondTmp;

assign hourTmp   = {1'b0, bcdHour_io[7:4],   3'b0} + {3'b0, bcdHour_io[7:4],   1'b0} + bcdHour_io[3:0];
assign minuteTmp = {1'b0, bcdMinute_io[7:4], 3'b0} + {3'b0, bcdMinute_io[7:4], 1'b0} + bcdMinute_io[3:0];
assign secondTmp = {1'b0, bcdSecond_io[7:4], 3'b0} + {3'b0, bcdSecond_io[7:4], 1'b0} + bcdSecond_io[3:0];

UniversalCounter #(
    .MAX_NUM         (60)
)Counter_ISR0
(
    .clk             (clk),
    .rst             (rst),
    .en_in           (clk1HzPulse & en_in),
    .dir_in          (1'b1),
    .loadCmd_in      (adjustCmd_in),
    .loadValue_in    ({24'h0, secondTmp}),
    .counter_out     (seconds),
    .tc_out          (tc_min)
);

UniversalCounter #(
    .MAX_NUM         (60)
)Counter_ISR1
(
    .clk             (clk),
    .rst             (rst),
    .en_in           (tc_min & en_in),
    .dir_in          (1'b1),
    .loadCmd_in      (adjustCmd_in),
    .loadValue_in    ({24'h0, minuteTmp}),
    .counter_out     (minutes),
    .tc_out          (tc_hour)
);

UniversalCounter #(
    .MAX_NUM         (24)
)Counter_ISR2
(
    .clk             (clk),
    .rst             (rst),
    .en_in           (tc_hour & en_in),
    .dir_in          (1'b1),
    .loadCmd_in      (adjustCmd_in),
    .loadValue_in    ({24'h0, hourTmp}),
    .counter_out     (hours),
    .tc_out          ()
);

Bin2bcd_6bit Bin2bcd_6bit_ISR0
(
    .i_data  (seconds[5:0]),
    .o_bcd   (seconds_bcd)
);

Bin2bcd_6bit Bin2bcd_6bit_ISR1
(
    .i_data  (minutes[5:0]),
    .o_bcd   (minutes_bcd)
);

Bin2bcd_6bit Bin2bcd_6bit_ISR2
(
    .i_data  (hours[5:0]),
    .o_bcd   (hours_bcd)
);

assign bcdHour_io   = adjustCmd_in ? 8'hzz : hours_bcd;
assign bcdMinute_io = adjustCmd_in ? 8'hzz : minutes_bcd;
assign bcdSecond_io = adjustCmd_in ? 8'hzz : seconds_bcd;

endmodule
