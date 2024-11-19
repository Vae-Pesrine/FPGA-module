module DecDecoder(
    input wire [7:0]    bin_in,
    
    output wire [3:0]   OnesPlace_out,
    output wire [3:0]   TensPlace_out
    );
    
assign OnesPlace_out =  (bin_in % 5'd10);
assign TensPlace_out =  (bin_in / 5'd10);
    
endmodule
