`timescale 1ns / 1ps
module Multiplier8Bit_tb;

  localparam MAX_TESTS = 10; 
  reg [7: 0] A = 0;
  reg [7: 0] B = 0;
  reg [15: 0] product = 0;
   
  Multiplier8Bit Multiplier8Bit_inst
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
        A = $urandom%255; 
        B = $urandom%255;
        $display("A %d, B: %d, product: %d", A, B, product);
        #10;    
    end 
    $finish();
   end
 
endmodule // Multiplier8Bit_tb