`timescale 1ns / 1ps

// 4 bit binary multiplier using binary adder 

module Multiplier4Bit
   (
   input       [3:0] A,
   input       [3:0] B, 
   output wire [7:0] product
   );
   
   reg [7:0] _product;

   // stage 0 registers
   reg [3:0] stage0_A;
   reg [3:0] stage0_B;
   reg [3:0] stage0_sum;
   reg stage0_carry;
   
   // stage 1 registers
   reg [3:0] stage1_A;
   reg [3:0] stage1_B;
   reg [3:0] stage1_sum;
   reg stage1_carry;
   
   // stage 2 registers
   reg [3:0] stage2_A;
   reg [3:0] stage2_B;
   reg [3:0] stage2_sum;
   reg stage2_carry;

   //stage 0
   assign stage0_A = {1'b0, A[0] & B[3], A[0] & B[2], A[0] & B[1]};
   assign stage0_B = {A[1] & B[3], A[1] & B[2], A[1] & B[1], A[1] & B[0]};
   binary_adder binary_adder_0_inst
   (
   .A(stage0_A),
   .B(stage0_B),
   .C_in(0),
   .sum(stage0_sum),
   .C_out(stage0_carry)
   );

   //stage 1
   assign stage1_A = {stage0_carry, stage0_sum[3:1]};
   assign stage1_B = {A[2] & B[3], A[2] & B[2], A[2] & B[1], A[2] & B[0]};
   binary_adder binary_adder_1_inst
   (
   .A(stage1_A),
   .B(stage1_B),
   .C_in(0),
   .sum(stage1_sum),
   .C_out(stage1_carry)
   );

   //stage 1
   assign stage2_A = {stage1_carry, stage1_sum[3:1]};
   assign stage2_B = {A[3] & B[3], A[3] & B[2], A[3] & B[1], A[3] & B[0]};
   binary_adder binary_adder_2_inst
   (
   .A(stage2_A),
   .B(stage2_B),
   .C_in(0),
   .sum(stage2_sum),
   .C_out(stage2_carry)
   );

   assign _product[0]   =   A[0] & B[0]; 
   assign _product[1]   = stage0_sum[0]; 
   assign _product[2]   = stage1_sum[0]; 
   assign _product[6:3] = stage2_sum; 
   assign _product[7]   = stage2_carry; 

   assign product = _product;

endmodule //Multiplier4Bit