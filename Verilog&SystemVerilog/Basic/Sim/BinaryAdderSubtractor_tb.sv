`timescale 1ns / 1ps
module binary_adder_subtractor_tb;

  localparam MAX_TESTS = 10; 
  reg [3: 0] A = 0;
  reg [3: 0] B = 0;
  reg mode = 0;
  wire overflow;
  wire [3: 0] sum;
  wire carry;
   
  binary_adder_subtractor binary_adder_subtractor_inst
    (
     .A(A),
     .B(B),
     .mode(mode),
     .overflow(overflow),
     .sum(sum),
     .carry(carry)
    );
 
  initial 
  begin
    integer seed, i , j;
    for (i=0; i< MAX_TESTS; i=i+1)
    begin
        A = $urandom%15; 
        B = $urandom%15;
        mode = $urandom;
        $display("A %d, B: %d, mode: %d", A, B, mode);
        $display("Binary Adder Subtractor: Sum %d, Carry: %d, Overflow: %d", sum, carry, overflow);
        #10;    
    end 
    $finish();
   end
 
endmodule // binary_adder_subtractor_tb