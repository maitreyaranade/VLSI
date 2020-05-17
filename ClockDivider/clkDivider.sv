`timescale 1ns / 1ps
 
module ClkDivider #(
  parameter integer CLK_DIVIDE  = 100
  )(
  input clk,
  input rst,
  output clk_div
  );

  logic [31:0] count;
  logic [$clog2(CLK_DIVIDE):0] clk_period;
  logic _clk_div;
  
  assign clk_period = CLK_DIVIDE >> 1;
  assign clk_div = _clk_div;
  
  always @ (posedge(clk), posedge(rst))
  begin
    if (rst == 1'b1)
      count <=0;
    else if (count == clk_period - 1)
      count <=0;
    else
        count <= count + 1;
  end

  always @ (posedge(clk), posedge(rst))
  begin
    if (rst == 1'b1)
      _clk_div <= 1'b0;
    else if (count == clk_period - 1)
      _clk_div <= ~_clk_div;
    else
      _clk_div <= _clk_div;
  end
     
endmodule
