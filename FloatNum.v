//流动数字显示
module FloatNum # (
    parameter   FREQUENCY_IN    =   50_000_000,
    parameter   FLOAT_SPEED      =   500
)
(
    input   wire        clk,
    input   wire        rst,
    
    output  wire [31:0] num_out               
);
    
localparam MAX_CNT  =   FREQUENCY_IN / 1000 * FLOAT_SPEED; 
    
reg [3:0]   num [13:0];
wire    movTemp;

assign num_out = {num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7]};

UniversalCounter # (
    .MAX_NUM        (MAX_CNT),
    .COUNTER_BITS   (31)
)Counter_ISR2(
    .clk            (clk),
    .rst            (rst),
    .en_in          (1'b1),
    .dir_in         (1'b1),
    .loadCmd_in     (1'b0),
    .loadValue_in   ('b0),
    
    .counter_out    (),
    .tc_out         (movTemp)
);
   
always @(posedge clk or posedge rst)begin
    if(rst) begin
        num[0]  <= 4'd3;
        num[1]  <= 4'd0;
        num[2]  <= 4'd2;
        num[3]  <= 4'd3;
        num[4]  <= 4'd2;
        num[5]  <= 4'd0;
        num[6]  <= 4'd2;
        num[7]  <= 4'd2;
        num[8]  <= 4'd3;
        num[9]  <= 4'd0;
        num[10] <= 4'hF;
        num[11] <= 4'hF;
        num[12] <= 4'hF;
        num[13] <= 4'hF;
    end else if(movTemp) begin
        num[0]  <= num[1];
        num[1]  <= num[2];
        num[2]  <= num[3];
        num[3]  <= num[4];
        num[4]  <= num[5];
        num[5]  <= num[6];
        num[6]  <= num[7];
        num[7]  <= num[8];
        num[8]  <= num[9];
        num[9]  <= num[10];
        num[10]  <= num[11];
        num[11]  <= num[12];
        num[12]  <= num[13];
        num[13]  <= num[0];
    end
end

endmodule
