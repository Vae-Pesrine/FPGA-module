module Bin2bcd_6bit(
    input  wire [5:0] i_data,
    output wire [7:0] o_bcd
);

wire [3:0] o1, o2, o3, o4;
Adder Adder1(
    .i_data ({1'b0, i_data[5:3]}),
    .o_data  (o1)
);
Adder Adder2(
    .i_data ({o1[2:0], i_data[2]}),
    .o_data  (o2)
);
Adder Adder3(
    .i_data ({o2[2:0], i_data[1]}),
    .o_data (o3)
);
assign o_bcd = {1'b0, o1[3], o2[3], o3, i_data[0]};

endmodule