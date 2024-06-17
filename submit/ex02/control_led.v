/*

1秒ごとに点灯/消灯を繰り返す回路

*/

module control_led(
    input                       clk,
    input                       rst,
    input                       enable,
    output                      signal
);

parameter                       FREQ = 50_000_000;

wire    [$clog2(FREQ+1)-1:0]    cnt_1sec_in;
wire    [$clog2(FREQ+1)-1:0]    cnt_1sec_out;
reg     [$clog2(FREQ+1)-1:0]    cnt_1sec_reg;

wire                            pulse_cnt_max;

wire                            signal_internal = 0;

// increment the counter triggered by positive edge of clock
always @(posedge clk) begin
    if (rst) begin
        cnt_1sec_reg <= 0;
    end
    else begin
        if (enable) begin
            cnt_1sec_reg <= cnt_1sec_in;
        end
    end
end
assign cnt_1sec_out = cnt_1sec_reg;
assign cnt_1sec_in ? (pulse_cnt_max) ? 0 : cnt_1sec_out + 1;

// generate the pulse signal every 1 second
assign pulse_cnt_max = (cnt_1sec_reg == FREQ - 1) ? 1'b1 : 1'b0;

// generate the output singal
assign signal_internal = (pulse_cnt_max) ? ~signal_internal : signal_internal;
assign signal = (rst) ? 1'b0 : signal_internal; 

endmodule
