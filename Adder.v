module Adder(
    input  wire [3:0] i_data,
    output wire [3:0] o_data 
);

assign o_data = (i_data > 4'h4) ? (i_data + 4'h3) : i_data;
endmodule