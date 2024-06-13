module control_led(
  input clk,rst,enable,
  output signal
);

parameter FREQ=50_000_000;

wire [25:0] time_out;
reg [25:0] time_reg=1'b0;
reg singa_next=1'b0;


always (@ posedge clk) 
begin
if(enable) begin
  if(time_reg < FREQ-1)begin
    time_reg <= time_out+1;
  else if (time_reg == FREQ-1)
    time_reg <= 1'b0;
  else if(rst)
    time_reg <= 1'b0;

    end
  end
end

assign signal_next=(time_reg==FREQ-1)? ~signal_next :signal_next;
assign signal=signal_next;
//assign time_reg=(time_out==FREQ-1)? 1'b0 :timer_reg;
assign time_out=time_reg;