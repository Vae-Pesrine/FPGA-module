`define METHOD_COUNTER
module Uart_Rx #(
    parameter FREQUENCY_IN = 100_000_000,
    parameter BAUD_RATE    = 9600
)
(
    input  wire       clk,
    input  wire       rst,
    input  wire       rx_in,
    output wire [7:0] rx_data_out,
    output wire       rxOK_out             //指示正确接收了一个字符，一个时钟周期宽度
);

localparam IDLE      = 4'b0001,
           CHK_START = 4'b0010,
           RECEIVING = 4'b0100,
           CHK_STOP  = 4'b1000;

reg  [3:0]  state = IDLE;
wire        start_bit;          //rx信号下的下降沿指示信号
reg  [19:0] tmpData;
wire        internal_start;
assign internal_start = rst | (state == IDLE);

EdgeCheck EdgeCheck_ISR0(
    .clk            (clk),
    .rst            (rst),
    .data_in        (rx_in),
    .posPlus_out    (),
    .negPlus_out    (start_bit)
);

wire doubleBaudClk;
FrequencyDivisionPulse #(
    .FREQUENCY_IN           (FREQUENCY_IN),
    .BAUD_RATE              (BAUD_RATE)
)T0_baudClk_ISR0
(
    .clk                    (clk),
    .rst                    (rst),
    .clock_out              (doubleBaudClk)
);

`ifdef METHOD_COUNTER
wire [31:0] cnt;
UniversialCounter #(
    .MAX_NUM                (20)
)UniversialCounter_ISR0
(
    .clk                    (clk),
    .rst                    (internal_start),
    .en_in                  (doubleBaudClk),
    .dir_in                 (1'b1),
    .loadCmd_in             (1'b0),
    .loadValue_in           (32'h0),
    .counter_out            (cnt),
    .tc_out                 ()
);

always @(posedge clk) begin
    if(rst)
        state <= IDLE;
    else begin
        case (state)
            IDLE: 
                if(start_bit)
                    state <= CHK_START;
            CHK_START:
                if(doubleBaudClk)
                    if(rx_in == 1'b0)
                        state <= RECEIVING;
                    else
                        state <= IDLE;
            RECEIVING:
                if(cnt == 8'd19)
                    state <= CHK_STOP;
            CHK_STOP:
                state <= IDLE;
            default: state <= IDLE;
        endcase
    end
end


always @(posedge clk) begin
    if(rst)
        tmpData <= 'h0;
    else if(doubleBaudClk && (state == RECEIVING || state == CHK_STOP))
        tmpData[cnt] <= rx_in;
end

assign rx_data_out = {tmpData[16], tmpData[14], tmpData[12], tmpData[10], tmpData[8], tmpData[6], tmpData[4], tmpData[2]};
assign rxOK_out = (state == CHK_STOP) ? tmpData[18] : 1'b0;

`endif
endmodule