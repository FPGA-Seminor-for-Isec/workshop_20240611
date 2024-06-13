module control_led(
    input   clk,
    input   rst,
    input   enable,
    output  signal
);
    reg [0:9]   cnt;
    parameter FREQ = 50000000;

    always @ (posedge clk)
        if(rst == 1'b00)
            cnt <= 11'b0;
        else if (cnt == 11'd49999999)
            cnt <= 11'b0;
        else
            cnt <= cnt + 11'd1;
        end
    
    assign signal = (cnt == 11'd49999999) ? ~signal : signal;


endmodule