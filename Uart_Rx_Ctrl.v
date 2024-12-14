module Uart_Rx_Ctrl #(
    parameter FREQUENCY_IN = 100_000_000,
    parameter BAUD_RATE    = 9600,
    parameter RX_DATA_LEN  = 8           //发送数据的长度
)   
(
    input  wire                           clk,
    input  wire                           rst,
    input  wire                           rx_in,
    input  wire [8 * RX_DATA_LEN - 1 : 0] rxData_out,
    output wire                           rxOK_out
);

localparam TIME_OUT_NUM = (FREQUENCY_IN / BAUD_RATE) * 15;
reg [31:0] timeOutCnt = 32'h0;

localparam IDLE      = 3'b001,
           RECEIVING = 3'b010,
           THE_END       = 3'b100;

reg [2:0] state = IDLE;

reg  [7:0] cnt;
reg        uartRxOK;
wire [7:0] uartRxBuf;

reg  [7:0] inter_rxData[RX_DATA_LEN-1:0];

generate
    genvar i;
    for(i = 0; i < RX_DATA_LEN; i = i + 1) begin
        assign rxData_out[(i+1)*8 - 1 : i*8] = inter_rxData[i];
    end
endgenerate

always @(posedge clk) begin
    if(rst) begin
        state      <= IDLE;
        cnt        <= 8'h00;
        timeOutCnt <= 32'h0;
    end else
    case (state)
        IDLE: begin
            cnt <= 8'h00;
            timeOutCnt <= 32'h0;
            state <= RECEIVING;
        end
        RECEIVING: begin
            if(cnt == RX_DATA_LEN)
                state <= IDLE;
            else if(uartRxOK) begin
                inter_rxData[cnt] <= uartRxBuf;
                cnt <= cnt + 1'b1;
                timeOutCnt <= 32'h0;
            end
            else if(timeOutCnt >= TIME_OUT_NUM)
                state <= IDLE;
            else
                timeOutCnt <= timeOutCnt + 1'b1;
        end
        THE_END: 
            state <= IDLE;
        default: state <= IDLE;       
    endcase
end
assign rxOK_out = (state == THE_END);

Uart_RX #(
    .FREQUENCY_IN        (FREQUENCY_IN),
    .BAUD_RATE           (BAUD_RATE)
)Uart_Rx_ISR0
(
    .clk                 (clk),
    .rst                 (rst),
    .rx_in               (rx_in),
    .rxData_out          (uartRxBuf),
    .rxOK_out            (uartRxOK)
);

endmodule