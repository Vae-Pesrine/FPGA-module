//按键检测
module KeyProcess #(
    parameter FREQUENCY_IN = 100
)
(
    input wire clk,
    input wire rst,
    input wire btn_in,
    output wire btn_LH_out,
    output wire btn_HL_out
);

localparam H_LEVEL = 6'b000_001,
           CHK_L   = 6'b000_010,
           L_VALID = 6'b000_100,
           L_LEVEL = 6'b001_000,
           CHK_H   = 6'b010_000,
           H_VALID = 6'b100_000;
reg [5:0] btn_state = H_LEVEL;

reg timerClr = 1'b0;
wire [31:0] timerCnt;

localparam TIME_DELAY_VALUE = 32'd12;
wire clk_1ms;

FrequencyDivisionPulse #(
    .FREQUENCY_IN     (FREQUENCY_IN),
    .FREQUENCY_OUT    (1000)
)To_xHzPulse_ISR0
(
    .clk              (clk),
    .rst              (rst),
    .clk_out          (clk_1ms)
);

UniversalCounter #(
    .MAX_NUM          (256)
)UniversalCounter_ISR0
(
    .clk              (clk),
    .rst              (rst | timerClr),
    .en_in            (clk_1ms),
    .dir_in           (1'b1),
    .loadCmd_in       (1'b0),
    .loadValue_in     (32'h0),
    .counter_out      (timerCnt),
    .tc_out           ()
);

always @(posedge clk) begin
    if(rst)
        btn_state <= H_LEVEL;
    else begin
        case (btn_state)
            H_LEVEL: if(btn_in == 1'b0) begin
                btn_state <= CHK_L;
                timerClr <= 1'b1;
            end 
            CHK_L: begin
                timerClr <= 1'b0;
                if(timerCnt == TIME_DELAY_VALUE) begin
                    if(btn_in == 1'b0)
                        btn_state <= L_VALID;
                    else
                        btn_state <= H_LEVEL;     
                end
            end
            L_VALID:
                btn_state <= L_LEVEL;
            L_LEVEL: 
                if(btn_in == 1'b1) begin
                    timerClr <= 1'b1;
                    btn_state <= CHK_H;
                end
            CHK_H: begin
                timerClr <= 1'b0;
                if(timerCnt == TIME_DELAY_VALUE) begin
                    if(btn_in == 1'b1)
                        btn_state <= H_VALID;
                    else
                        btn_state <= L_LEVEL;      
                end
            end
            H_VALID:
                btn_state <= H_LEVEL;
            default: btn_state <= H_LEVEL;
        endcase
    end
end

//output
assign btn_HL_out = (btn_state == L_VALID) ? 1'b1 : 1'b0;
assign btn_LH_out = (btn_state == H_VALID) ? 1'b1 : 1'b0;

endmodule