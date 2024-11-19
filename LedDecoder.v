/*@bief 将显示的数字编码成二进制
  @bcdCoder_in:  输入的bcd码
  @dp_in: 是否显示小数点
  @seg_data_out: 输出的段选信号
  @*/
module LedDecoder(
    input   wire [3:0]  bcdCoder_in,    
    input   wire [0:0]  dp_in,          
    
    output  wire  [7:0]  seg_data_out    
    );

 localparam     ZERO    =   7'b011_1111,
                ONE     =   7'b000_0110,
                TWO     =   7'b101_1011,
                THREE   =   7'b100_1111,
                FOUR    =   7'b110_0110,
                FIVE    =   7'b110_1101,
                SIX     =   7'b111_1101,
                SEVEN   =   7'b000_0111,
                EIGHT   =   7'b111_1111,
                NINE    =   7'b110_1111,
                SIGN    =   7'b100_0000,
                ERR     =   7'b111_1001;

reg [6:0]   seg_num;

always@(*) begin
    case(bcdCoder_in)
        4'h0:       seg_num <= ZERO;
        4'h1:       seg_num <= ONE;
        4'h2:       seg_num <= TWO;
        4'h3:       seg_num <= THREE;
        4'h4:       seg_num <= FOUR;
        4'h5:       seg_num <= FIVE;
        4'h6:       seg_num <= SIX;
        4'h7:       seg_num <= SEVEN;
        4'h8:       seg_num <= EIGHT;
        4'h9:       seg_num <= NINE;
        4'hA:       seg_num <= SIGN;
        default:    seg_num <= 'b0;
    endcase
end

assign seg_data_out = {dp_in, seg_num};

endmodule
