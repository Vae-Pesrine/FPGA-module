module Reset_Inner(
    input   wire    clk,
    output  reg     rst_out
    );
    
localparam  INNER_CNT_END   =   16'hA5;
reg [7:0]   rst_inner_cnt   =   16'h00;

always@(posedge clk) begin
    if(rst_inner_cnt != INNER_CNT_END) begin
        rst_inner_cnt <= rst_inner_cnt + 1'b1;
    end
end

always@(posedge clk) begin
    if(rst_inner_cnt != INNER_CNT_END) begin
        rst_out <= 1'b1;
    end else begin
        rst_out <= 1'b0;
    end
end
    
endmodule
