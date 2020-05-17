`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.05.2020 21:20:02
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clkDividerTB();
    
  logic clk;
  logic sresetn;
  
  initial 
  begin
    sresetn <=1;
    #200;
    sresetn <=0;    
  end
    
  always 
    begin
      clk <= 1; #5;
      clk <= 0; #5;
    end
    
ClkDivider #(
  .CLK_DIVIDE(100)
  ) dut (
  .clk    (clk),
  .rst    (sresetn),
  .clk_div()
  );

endmodule
