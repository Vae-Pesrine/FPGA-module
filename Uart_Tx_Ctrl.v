module Uart_Tx_Ctrl #(
    parameter FREQUENCY_IN = 100_000_000,
    parameter BAUD_RATE    = 9600,
    parameter TX_DATA_LEN  = 8           //发送数据的长度
)   
(
    input  wire                           clk,
    input  wire                           rst,
    input  wire                           startTx_in,
    input  wire [8 * TX_DATA_LEN - 1 : 0] txData_in,
    output wire                           txIsBusying_out,
    output wire                           tx_out
);

localparam IDLE    = 3'b001,
           SEND_TX = 3'b010,
           CHK_LEN = 3'b100;
reg [2:0] state = IDLE;

wire        uartTxBusying;                //状态指示
reg [7:0]   cnt;                          //计数器
reg         uartTx_start;                 //开始发送指令
reg [7:0]   uartTxBuf;                    //数据接口变量
reg [7:0]   txBufArray[TX_DATA_LEN-1:0];  //二位数组定义

integer i;
always @(posedge clk) begin
    if(rst) begin
        state        <= IDLE;
        cnt          <= 8'h00;
        uartTx_start <= 1'b0;
    end else
    case (state)
        IDLE: 
            if(startTx_in) begin
                cnt <= 8'h00;
                state <= SEND_TX;

                for(i = 0; i < TX_DATA_LEN; i = i + 1)
                    txBufArray[i] <= txData_in[i*8 +: 8];
            end
        SEND_TX:
            if(uartTxBusying == 1'b0) begin
                uartTxBuf <= txBufArray[cnt];
                cnt <= cnt + 1'b1;
                uartTx_start <= 1'b1;
                state  <= CHK_LEN;
            end    
        CHK_LEN: begin
            uartTx_start <= 1'b0;
            if(cnt == TX_DATA_LEN)
                state <= IDLE;
            else
                state <= SEND_TX;
        end
        default: state <= IDLE;
    endcase
end

Uart_Tx #(
    .FREQUENCY_IN       (FREQUENCY_IN),
    .BAUD_RATE          (BAUD_RATE)
)Uart_Tx_ISR0
(
    .clk                (clk),
    .rst                (rst),
    .startTx_in         (uartTx_start),
    .txData_in          (uartTxBuf),
    .isBusying_out      (uartTxBusying),
    .tx_out             (tx_out)
);
assign txIsBusying_out = (state != IDLE);

endmodule