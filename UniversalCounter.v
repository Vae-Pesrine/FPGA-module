//通用计数器
module UniversalCounter#(
    parameter MAX_NUM       =   10,     
    parameter COUNTER_BITS  =   31      
)
(
    input  wire                     clk,           
    input  wire                     rst,          
    input  wire                     en_in,         
    input  wire                     dir_in,         
    input  wire                     loadCmd_in,     
    input  wire [COUNTER_BITS:0]    loadValue_in,
    
    output reg  [COUNTER_BITS:0]    counter_out,    
    output wire                     tc_out          
);

localparam COUNTER_MODULE   =   MAX_NUM - 1'b1;
always@(posedge clk) begin
    if(rst)
        counter_out <= 'h0;
    else if(loadCmd_in) begin
        if(loadValue_in <= COUNTER_MODULE)
            counter_out <= loadValue_in;
    end else if(en_in) begin
        if(dir_in) begin
            if(counter_out == COUNTER_MODULE)
                counter_out <= 'h0;
            else counter_out <= counter_out + 1'b1;   
        end
        else begin
            if(counter_out == 0)
                counter_out <= COUNTER_MODULE;
            else counter_out <= counter_out - 1'b1;   
        end
    end
end

assign tc_out = en_in & (counter_out == COUNTER_MODULE);

endmodule
