module Moving_ID #
(
    parameter   FREQUENCY_IN      = 50_000_000,
    parameter   MOVING_ID_LEN           = 1,
    parameter   MOVING_SPEED            = 1  
)
(
    input   wire                        clk, 
    input   wire                        rst,
    input   wire                        en_in,              //moving or stop
    input   wire                        dir_in,             //moving dir. 1 = to left, 0 = to right
    input   wire [MOVING_ID_LEN*4-1:0]  movingID_in,
    output  wire [8*4-1:0]              movingBCD_out
);
    localparam MOVING_ID_BIT_LEN = MOVING_ID_LEN*4;
    //generate moving speed
    wire    movingSpd;
    FrequencyDivisionPulse #(
        .FREQUENCY_IN         (FREQUENCY_IN),
        .FREQUENCY_OUT              (MOVING_SPEED)   
    )T0_xHzPulse_ISR0
    (
        .clk            (clk),
        .rst            (rst),
        .clk_out        (movingSpd)
    );
 
    reg     [MOVING_ID_BIT_LEN-1:0]   regMovingID = 'd0;    
    
    always @(posedge clk)
    begin
        if(rst)
            regMovingID <= movingID_in;
        else if(movingSpd & en_in)
        begin
            if(dir_in)     //to left
                regMovingID <= {regMovingID[0 +: MOVING_ID_BIT_LEN-4], regMovingID[(MOVING_ID_BIT_LEN-1) -: 4]};
            else        //to right
                regMovingID <= {regMovingID[3:0], regMovingID[(MOVING_ID_BIT_LEN-1):4]};
        end
    end
    
   assign movingBCD_out = dir_in ? regMovingID[MOVING_ID_BIT_LEN-1 -: 32] : regMovingID[0 +: 32];
endmodule
