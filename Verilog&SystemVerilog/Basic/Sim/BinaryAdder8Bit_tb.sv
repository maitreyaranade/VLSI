`timescale 1ns / 1ps
module binary_adder_8bit_tb;

  localparam MAX_TESTS = 10; 
  reg [7: 0] A = 0;
  reg [7: 0] B = 0;
  reg C_in = 0;
  wire [7: 0] sum;
  wire carry;
   
  binary_adder_8bit binary_adder_8bit_inst
  (
    .A(A),
    .B(B),
    .C_in(C_in),
    .sum(sum),
    .C_out(carry)
  );

  initial 
  begin
    integer i;
    for (i=0; i< MAX_TESTS; i=i+1)
    begin
        A = $urandom%255; 
        B = $urandom%255;
        C_in = $urandom;
        $display("A %d, B: %d, C_in: %d", A, B, C_in);
        $display("Binary Adder: Sum %d, Carry: %d", sum, carry);
        #10;    
    end 
    $finish();
   end
 
endmodule // binary_adder_8bit_tb