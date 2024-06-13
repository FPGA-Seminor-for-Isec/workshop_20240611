module control_led(
  input      clk,
  input      rst,
  input      enable,
  output     signal, );

  wire      clk,
  wire      rst,
  reg       cnt,
  wire      enable,
  wire      signal,

  always @ (posedge clk)
  begin
    if (rst ==0)
       cnt  <= cnt + 1'b1 ;
            if (cnt == 50000000)
                  enable <= 1'b1 ; 
            else if (cnt == 100000000)
                  enable <= 1'b0 ; 
                  rst <= 0;
            end
        
  end
  assign signal <= enable ;

endmodule
      

  
