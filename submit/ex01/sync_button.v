module sync_button(
    input                           clk_50_mhz,
    input                           button,
    output                          sync_button
);

reg     [8:0]                       lfsr_button;
wire    [8:0]                       lfsr_button_in;
reg                                 sync_button_reg;
wire                                sync_button_reg_in;

always @(posedge clk_50_mhz) begin
    lfsr_button <= lfsr_button_in;
end
assign lfsr_button_in <= {lfsr_button[7:0], button};

always @(posedge clk_50_mhz) begin
    case (lfsr_button)
        8'b00: sync_button_reg <= 1'b0;
        8'hff: sync_button_reg <= 1'b1;
        default: sync_button_reg <= sync_button_reg_in;
    endcase
end
assign sync_button_reg_in = sync_button_reg;
assign sync_button = sync_button_reg;

endmodule