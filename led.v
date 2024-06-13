module control_led(
    input   clk,
    input   rst,
    input   enable,
    output  signal
);
    wire    internal_signal = 0
    reg [0:9]   cnt;
    parameter FREQ = 50000000;

    always @ (posedge clk)
        if(rst == 1'b00)
            cnt <= 10'b0;
        else if (cnt == 10'd49999999)
            cnt <= 10'b0;
        else
            cnt <= cnt + 10'd1;
        end
    
    assign internal_signal = (cnt == 10'd49999999) ? ~internal_signal : internal_signal;
    assign signal = internal_signal;


endmodule