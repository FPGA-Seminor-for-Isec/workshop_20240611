module control_led(
  input      clk,
  input      rst,
  input      enable,
  input      cnt,
  output     signal, );

  wire      clk,
  wire      rst,
  reg       cnt,
  wire      enable,
  wire      signal,

  always @ (posedge clk)
  begin
       cnt  <= cnt + 1'b1 ;
            if (cnt == 50000000)
                  enable <= 1'b1 ;
            else　if (cnt == 100000000)
                  enable <= 1'b0 ;
            else
                  cnt <= 1'b0 ;
  end
      

  
