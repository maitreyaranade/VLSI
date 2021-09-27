`timescale 1ns / 1ps
module half_adder_tb;
 
  reg A = 0;
  reg B = 0;
  wire sum;
  wire carry;
   
  half_adder half_adder_inst
    (
     .A(A),
     .B(B),
     .sum(sum),
     .carry(carry)
    );
 
  initial
    begin
      A = 1'b0;
      B = 1'b0;
      #10;
      A = 1'b0;
      B = 1'b1;
      #10;
      A = 1'b1;
      B = 1'b0;
      #10;
      A = 1'b1;
      B = 1'b1;
      #10;
      $finish();
    end 
 
endmodule // half_adder_tb