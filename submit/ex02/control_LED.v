module control_LED(
    input  clk, rst, enable,
    output signal
);
	
	//1秒毎に点滅する回路(clk周波数:50MHz)
	reg  [25:0] reg_counter_1sec;
	wire [25:0] reg_counter_1sec_in;
	wire [25:0] reg_counter_1sec_out;

    reg signal_next;
    
    wire counter_1sec;

    parameter FREQ = 50_000_000;

	always @(posedge clk, enable) begin
		if (rst) begin
			reg_counter_1sec = 0;
		end
		else begin
                reg_counter_1sec = reg_counter_1sec_in;
            end
	end

    
    assign counter_1sec = (reg_counter_1sec == FREQ - 1) ?  1 : 0;

    assign reg_counter_1sec = (counter_1sec) ? 0 : reg_counter_1sec;

    assign reg_counter_1sec_out = reg_counter_1sec;
    assign reg_counter_1sec_in  = reg_counter_1sec_out + 1;

    assign signal_next = (counter_1sec) ? ~signal_next : signal_next;
    assign signal = signal_next;

endmodule