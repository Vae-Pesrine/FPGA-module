//选择数码管显示的信号
module LedDataSelect(
    input   wire    [3:0]   select_in,
    input   wire    [15:0]  ledData_in,
    input   wire    [3:0]   ledDot_in,
    
    output  reg     [3:0]   ledDataSelected_out,
    output  reg             ledDotSelected_out
    );

 wire   [3:0]   inter_ledData [3:0];
 
 assign inter_ledData[0] = ledData_in[15:12];
 assign inter_ledData[1] = ledData_in[11:8]; 
 assign inter_ledData[2] = ledData_in[7:4];
 assign inter_ledData[3] = ledData_in[3:0];

always@(*) begin
    case(select_in)
        4'b0001 : begin
            ledDataSelected_out <= inter_ledData[0];
            ledDotSelected_out <= ledDot_in[3];
        end
        4'b0010 : begin
            ledDataSelected_out <= inter_ledData[1];
            ledDotSelected_out <= ledDot_in[2];
        end
        4'b0100 : begin
            ledDataSelected_out <= inter_ledData[2];
            ledDotSelected_out <= ledDot_in[1];
        end
        4'b1000 : begin
            ledDataSelected_out <= inter_ledData[3];
            ledDotSelected_out <= ledDot_in[0];
        end
        default : begin
            ledDataSelected_out <= 4'hF;
            ledDotSelected_out <= 'b0;
        end
    endcase
end
    
endmodule
