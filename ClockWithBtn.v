//按键控制时钟
//按下按键进入调节模式，可控制时分秒的增加和减少
module ClockWithBtn #(
    parameter FREQUENCY_IN = 100_000_000
)(
    input  wire    clk,
    input  wire    rst,
    input  wire    en_in,
    input  wire    timerSetupBtn_in,
    input  wire    timerSelectBtn_in,
    input  wire    timerUpBtn_in,
    input  wire    timerDownBtn_in,

    // output reg [7:0] bcdMSecond_out,
    output reg [7:0] bcdSecond_out,
    output reg [7:0] bcdMinute_out,
    output reg [7:0] bcdHour_out
);

//内部变量定义
reg [7:0] hour_setValue;
reg [7:0] minute_setValue;
reg [7:0] second_setValue;

//通过时钟模块得到的数值，为BCD码格式
wire [7:0] hours_cnt_bcd;
wire [7:0] minutes_cnt_bcd;
wire [7:0] seconds_cnt_bcd;

reg       setCmd    = 1'b0;           //一个时钟周期宽度
reg [1:0] selectCnt = 2'h0; //指示被选中的单元 时 分 秒

localparam IDLE_STATE    = 3'b001,
           SETTING_STATE = 3'b010,
           END_STATE     = 3'b100;
reg [2:0] state;

always @(posedge clk) begin
    if(rst) begin
        hour_setValue   <= 8'h00;
        minute_setValue <= 8'h00;
        second_setValue <= 8'h00;
        setCmd          <= 1'b0;
        selectCnt       <= 2'h0;
        state           <= IDLE_STATE;
    end
    else begin
        case (state)
            IDLE_STATE:begin
                //进入时钟校准模式，保存当前的时分秒数据
                if(timerSetupBtn_in) begin
                    state <= SETTING_STATE;
                    //将两个8421BCD码转化为二进制数值  AB--A*10 + B--A*8 + A*2 + B--A < 3 + A < 2 + B
                    hour_setValue   <= {1'b0, hours_cnt_bcd[7:4],   3'b0} + {3'b0, hours_cnt_bcd[7:4],   1'b0} + hours_cnt_bcd[3:0];
                    minute_setValue <= {1'b0, minutes_cnt_bcd[7:4], 3'b0} + {3'b0, minutes_cnt_bcd[7:4], 1'b0} + minutes_cnt_bcd[3:0];
                    second_setValue <= {1'b0, seconds_cnt_bcd[7:4], 3'b0} + {3'b0, seconds_cnt_bcd[7:4], 1'b0} + seconds_cnt_bcd[3:0];
                end
            end 
            SETTING_STATE: begin
                if(timerSetupBtn_in) begin
                    setCmd <= 1'b1;
                    state <= END_STATE;
                end
                else if(timerSelectBtn_in) begin
                    if(selectCnt == 2'h2)
                        selectCnt <= 2'h0;
                    else
                        selectCnt <= selectCnt + 1'b1;                    
                end
                else begin
                    if(timerUpBtn_in) begin
                        case (selectCnt)
                            2'h0: begin
                                if(second_setValue == 8'd59)
                                    second_setValue <= 8'd0;
                                else
                                    second_setValue <= second_setValue + 1'b1; 
                            end
                            2'h1: begin
                                if(minute_setValue == 8'd59)
                                    minute_setValue <= 8'd0;
                                else
                                    minute_setValue <= minute_setValue + 1'b1; 
                            end
                            2'h2: begin
                                if(hour_setValue == 8'd23)
                                    hour_setValue <= 8'd0;
                                else
                                    hour_setValue <= hour_setValue + 1'b1;
                            end
                            default: selectCnt <= 2'h0;
                        endcase
                    end
                    else if(timerDownBtn_in) begin
                        case (selectCnt)
                            2'h0: begin
                                if(second_setValue == 8'd0)
                                    second_setValue <= 8'd59;
                                else
                                    second_setValue <= second_setValue - 1'b1; 
                            end
                            2'h1: begin
                                if(minute_setValue == 8'd0)
                                    minute_setValue <= 8'd59;
                                else
                                    minute_setValue <= minute_setValue - 1'b1; 
                            end
                            2'h2: begin
                                if(hour_setValue == 8'd0)
                                    hour_setValue <= 8'd23;
                                else
                                    hour_setValue <= hour_setValue - 1'b1;
                            end
                            default: selectCnt <= 2'h0;
                        endcase                        
                    end
                end
            end
            END_STATE: begin
                setCmd <= 1'b0;
                selectCnt <= 2'h0;
                state <= IDLE_STATE;
            end
            default: state <= IDLE_STATE;
        endcase
    end
end

//获得设置值的BCD码
wire [7:0] secondSet_bcd;
wire [7:0] minuteSet_bcd;
wire [7:0] hourSet_bcd;
Bin2bcd_6bit Bin2bcd_6bit_ISR0
(
    .i_data (second_setValue[5:0]),
    .o_bcd  (secondSet_bcd)
);
Bin2bcd_6bit Bin2bcd_6bit_ISR1
(
    .i_data (minute_setValue[5:0]),
    .o_bcd  (minuteSet_bcd)
);
Bin2bcd_6bit Bin2bcd_6bit_ISR2
(
    .i_data (hour_setValue[5:0]),
    .o_bcd  (hourSet_bcd)
);

//双向IO口处理方法
assign hours_cnt_bcd   = (setCmd) ? hourSet_bcd   : 8'hzz;
assign minutes_cnt_bcd = (setCmd) ? minuteSet_bcd : 8'hzz;
assign seconds_cnt_bcd = (setCmd) ? secondSet_bcd : 8'hzz;

AdjustableTimerHMS #(
    .FREQUENCY_IN (FREQUENCY_IN)
)
(
    .clk          (clk),
    .rst          (rst),
    .en_in        (en_in),
    .adjustCmd_in (setCmd),
    .bcdSecond_io (seconds_cnt_bcd),
    .bcdMinute_io (minutes_cnt_bcd),
    .bcdHour_io   (hours_cnt_bcd) 
);

reg [7:0] bcdHourTmp;
reg [7:0] bcdMinuteTmp;
reg [7:0] bcdSecondTmp;
always @(*) begin
    if(state == IDLE_STATE) begin
        bcdHourTmp <= hours_cnt_bcd;
        bcdMinuteTmp <= minutes_cnt_bcd;
        bcdSecondTmp <= seconds_cnt_bcd;
    end
    else begin
        bcdHourTmp <= hourSet_bcd;
        bcdMinuteTmp <= minuteSet_bcd;
        bcdSecondTmp <= secondSet_bcd;
    end
end

//选中时增加闪烁效果
wire twinklingTime;
FrequencyDivisionSquare #(
    .FREQUENCY_IN  (FREQUENCY_IN),
    .FREQUENCY_OUT (2)
)
(
    .clk     (clk),
    .rst     (rst),
    .clk_out (twinklingTime)
);

always @(*) begin
    if(state == SETTING_STATE) begin
        if(selectCnt == 2'h0) begin
            bcdSecond_out <= (twinklingTime) ? bcdSecondTmp : 8'hFF;
            bcdMinute_out <= bcdMinuteTmp;
            bcdHour_out <= bcdHourTmp;
        end
        else if(selectCnt == 2'h1) begin
            bcdSecond_out <= bcdSecondTmp;
            bcdMinute_out <= (twinklingTime) ? bcdMinuteTmp : 8'hFF;
            bcdHour_out <= bcdHourTmp;
        end
        else if(selectCnt == 2'h2) begin
            bcdSecond_out <= bcdSecondTmp;
            bcdMinute_out <= bcdMinuteTmp;
            bcdHour_out <= (twinklingTime) ? bcdHourTmp : 8'hFF;
        end
    end
    else begin
        bcdSecond_out <= bcdSecondTmp;
        bcdMinute_out <= bcdMinuteTmp;
        bcdHour_out <= bcdHourTmp;
    end
end

endmodule