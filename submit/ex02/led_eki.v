module control-led(
    input clk, rst, enable
    output signal
)

parameter FREQ=50_000_000
reg [25:0]count

always @(posedge clk) begin
    if(enable)
        count <= count + 1
        if(count == FREQ)
            if(signal == 0)
                signal <= 1
                count <= 0
            end
            if(signal == 1)
                signal <= 0
                count <= 0
            end
            if(rst)
                count <= 0
            end
        end
    end
end

endmodule