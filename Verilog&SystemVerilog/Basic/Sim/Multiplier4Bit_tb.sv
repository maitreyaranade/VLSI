`timescale 1ns / 1ps
module Multiplier4Bit_tb;

  localparam MAX_TESTS = 10; 
  reg [3: 0] A = 0;
  reg [3: 0] B = 0;
  reg [7: 0] product = 0;
   
  Multiplier4Bit Multiplier4Bit_inst
  (
    .A(A),
    .B(B),
    .product(product)
  );
 
  initial 
  begin
    integer seed, i , j;
    for (i=0; i< MAX_TESTS; i=i+1)
    begin
        A = $urandom%15; 
        B = $urandom%15;
        $display("A %d, B: %d, product: %d", A, B, product);
        #10;    
    end 
    $finish();
   end
 
endmodule // Multiplier4Bit_tb