/*=============== discription ====================
1. one start bit
2. 8-bits data               
3. 1 stop bit
4. no parity
5. the first bit sent is the low bit
==================================================*/

module Uart_Tx #(
    parameter FREQUENCY_IN = 100_000_000,
    parameter BAUD_RATE = 9600
)
(
    input  wire          clk,
    input  wire          rst,
    input  wire          startTx_in,     //发送启动命令
    input  wire [7:0]    txData_in,      //待发送的命令
    output wire          isBusying_out,  //模块处于忙碌的标志
    output wire          tx_out          //tx-signal
);

localparam IDLE = 2'b01,
        SENDING = 2'b10;
reg [1:0] state;

reg [3:0]  cnt;
reg [10:0] txBuf;        
reg        m_start;
wire       clrStart;
wire       baudClkPulse;  //波特率时钟

//启动处理信号
always @(posedge clk) begin
    begin
        if(rst | clrStart)
            m_start <= 1'b0;
        else if(startTx_in)
            m_start <= 1'b1;
    end
end

FrequencyDivisionPulse #
(
    .FREQUENCY_IN       (FREQUENCY_IN),
    .FREQUENCY_OUT      (BAUD_RATE)
)
T0_baudClk_ISR0
(
    .clk                (clk),
    .rst                (rst),
    .clk_out            (baudClkPulse)
);

always @(negedge clk ) begin
    if(rst) begin
        state <= IDLE;
        cnt <= 8'd0;
    end
    else if(baudClkPulse) begin
        case (state)
            IDLE: begin
                if(m_start) begin
                    state <= SENDING;
                    cnt <= 8'd0;
                    txBuf <= {1'b1, txData_in, 1'b0};
                end
            end 
            SENDING: begin
                if(cnt == 4'd9)
                    state <= IDLE;
                else
                    cnt <= cnt + 1'b1;
            end
            default: state <= IDLE;
        endcase
    end
end

assign isBusying_out = (state == SENDING) | m_start;
assign tx_out = (state == SENDING) ? txBuf[cnt] : 1'b1;
assign clrStart = (state == SENDING);
endmodule

// Uart_Tx Uart_Tx_ISR0(
//     .clk        (clk),
//     .rst        (~rst),
//     .startTx_in (1'b1),
//     .txData_in  (8'h33),
//     .isBusying_out (led),
//     .tx_out     (tx_out)
// );