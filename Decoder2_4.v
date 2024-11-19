module Decoder2_4
(
    input   wire [1:0]  coder_in,
    output  reg  [3:0]  decoder_out
);
    always @(*)
        case(coder_in)
            2'd0:   decoder_out <= 4'b0001;
            2'd1:   decoder_out <= 4'b0010;
            2'd2:   decoder_out <= 4'b0100;
            2'd3:   decoder_out <= 4'b1000;
        endcase
endmodule