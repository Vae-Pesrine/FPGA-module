//脉冲分频
module FrequencyDivisionPulse#(
    parameter FREQUENCY_IN       = 100_000_000,
    parameter FREQUENCY_OUT      = 100        
)(
    input   wire        clk,    
    input   wire        rst,    
    
    output  reg         clk_out 
);

localparam  DIVISION_NUM = (FREQUENCY_IN / FREQUENCY_OUT) - 1'b1;

reg [31:0]  cnt;

always@(posedge clk or posedge rst) begin
    if(rst) begin
        cnt     <= 32'b0;
        clk_out <= 1'b0;
    end
    else if(cnt == DIVISION_NUM) begin
        cnt     <= 32'h0;
        clk_out <= 1'b1;
    end else begin
        cnt     <= cnt + 1'b1;
        clk_out <= 1'b0;
    end
end

endmodule
