module FrequencyDivisionSquare #(
    parameter FREQUENCY_IN        = 100_000_000,
    parameter FREQUENCY_OUT       = 100
)
(
    input   wire         clk,
    input   wire         rst,
    output  reg          clk_out
);

    localparam      DIVISION_NUM = FREQUENCY_IN / FREQUENCY_OUT / 2;      
    reg [31:0]      cnt;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            cnt        <= 32'd0;
            clk_out    <= 1'b0;
        end
        else if(cnt < DIVISION_NUM) begin
            cnt        <= cnt + 1'b1;
        end
        else begin
            cnt        <= 32'h0;
            clk_out    <=  ~clk_out;
        end
    end

endmodule

/*
	FrequencyDivisionSquare #
	(
	    .ORIGINAL_FREQUENCY			(100_000_000),	
	    .OUT_FREQUENCY				(10)
	)
	FreS_0
	(
	    .clk		(sys_clk_in),
	    .rst		(~sys_rst_in),
	    .clk_out  	(clk_10hz)
	);
*/