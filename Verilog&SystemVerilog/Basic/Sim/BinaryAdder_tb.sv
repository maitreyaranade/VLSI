`timescale 1ns / 1ps
module binary_adder_tb;

  localparam MAX_TESTS = 10; 
  reg [3: 0] A = 0;
  reg [3: 0] B = 0;
  reg C_in = 0;
  wire [3: 0] sum, sum_FA;
  wire carry, carry_FA;
   
  binary_adder binary_adder_inst
    (
     .A(A),
     .B(B),
     .C_in(C_in),
     .sum(sum),
     .C_out(carry)
    );
   
  binary_adder_FA binary_adder_FA_inst
    (
     .A(A),
     .B(B),
     .C_in(C_in),
     .sum(sum_FA),
     .C_out(carry_FA)
    );
 
  initial 
  begin
    integer seed, i , j;
    for (i=0; i< MAX_TESTS; i=i+1)
    begin
        A = $urandom%15; 
        B = $urandom%15;
        C_in = $urandom;
        $display("A %d, B: %d, C_in: %d", A, B, C_in);
        $display("Binary Adder: Sum %d, Carry: %d", sum, carry);
        $display("Binary Adder with FA: Sum %d, Carry: %d", sum_FA, carry_FA);
        #10;    
    end 
    $finish();
   end
 
endmodule // binary_adder_tb