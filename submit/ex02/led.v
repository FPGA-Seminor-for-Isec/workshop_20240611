module control-led(
    input clk, rst, enable
    output signal
)

parameter FREQ=50_000_000
reg [25:0]count

always @(posedge clk) begin
    if(enable) begin
        count <= count + 1
        if(count == FREQ) begin
            if(signal == 0) begin
                signal <= 1
                count <= 0
            end
            if(signal == 1) begin
                signal <= 0
                count <= 0
            end
            if(rst) begin
                count <= 0
            end
        end
    end
end

endmodule