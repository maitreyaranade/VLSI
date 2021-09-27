`timescale 1ns / 1ps
module full_adder_tb;
 
  reg A = 0;
  reg B = 0;
  reg C = 0;
  wire sum, sum_HA;
  wire carry, carry_HA;
   
  full_adder full_adder_inst
    (
     .A(A),
     .B(B),
     .C(C),
     .sum(sum),
     .carry(carry)
    );
   
  full_adder_HA full_adder_HA_inst
    (
     .A(A),
     .B(B),
     .C(C),
     .sum(sum_HA),
     .carry(carry_HA)
    );
 
  initial
    begin
      A = 1'b0;
      B = 1'b0;
      C = 1'b0;
      #10;
      A = 1'b0;
      B = 1'b0;
      C = 1'b1;
      #10;
      A = 1'b0;
      B = 1'b1;
      C = 1'b0;
      #10;
      A = 1'b0;
      B = 1'b1;
      C = 1'b1;
      #10;
      A = 1'b1;
      B = 1'b0;
      C = 1'b0;
      #10;
      A = 1'b1;
      B = 1'b0;
      C = 1'b1;
      #10;
      A = 1'b1;
      B = 1'b1;
      C = 1'b0;
      #10;
      A = 1'b1;
      B = 1'b1;
      C = 1'b1;
      #10;
      $finish();
    end 
 
endmodule // full_adder_tb