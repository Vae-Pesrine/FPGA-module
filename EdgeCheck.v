module EdgeCheck
(
    input   wire      clk_in,
    input   wire      rst_in,
    input   wire      data_in,
    output  wire      posPuls_out,   //上升沿输出
    output  wire      negPuls_out    //下降沿输出
);

    reg [1:0]  shiftData;

    always @(posedge clk_in)
    begin
        if(rst_in)
            shiftData <= 2'b00;
        else
            shiftData <= {shiftData[0], data_in};
    end           

    assign posPuls_out = (shiftData == 2'b01) ? 1'b1:1'b0;
    assign negPuls_out = (shiftData == 2'b10) ? 1'b1:1'b0;

endmodule

/*
	   EdgeCheck   edgecheck_0
	   (
	       .clk_in   (sys_clk_in),
	       .rst_in   (~sys_rst_in),
	       .data_in   (),
	       .posPuls_out(),
	       .negPuls_out()
	   );
*/