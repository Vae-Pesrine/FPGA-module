//四位数码管显示
module FourLedCtrl#(
    parameter   FREQUENCY_IN     =   50_000_000
)
(
    input   wire        clk,            
    input   wire        rst,            
    input   wire [15:0] bcdCoder_in,    
    input   wire [3:0]  hasDot_in,      
    
    output  wire [3:0]  seg_cs_out,     
    output  wire [7:0]  seg_data_out    //{DP,g,f,e,d,c,b,a}
);

wire    [3:0]   inter_ledData;
wire            inter_ledDot;

GenerateLed_cs#(
    .FREQUENCY_IN  (FREQUENCY_IN)
)
GenerateLed_cs_ISRO(
    .clk            (clk),
    .rst            (rst),
    
    .seg_cs_out     (seg_cs_out)
);

LedDataSelect LedDataSelect_ISRO(
    .select_in              (seg_cs_out),
    .ledData_in             (bcdCoder_in),
    .ledDot_in              (hasDot_in),
          
    .ledDataSelected_out    (inter_ledData),
    .ledDotSelected_out     (inter_ledDot)
);

LedDecoder LedDecoder_ISRO(
    .bcdCoder_in        (inter_ledData),
    .dp_in              (inter_ledDot),
    
    .seg_data_out       (seg_data_out)
);

endmodule
