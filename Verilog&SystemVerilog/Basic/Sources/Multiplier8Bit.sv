`timescale 1ns / 1ps

// 8 bit binary multiplier using binary adder 

module Multiplier8Bit
   (
   input       [7:0] A,
   input       [7:0] B, 
   output wire [15:0] product
   );
   
   reg [15:0] _product;

   //stage 0
   reg [7:0] stage0_A;
   reg [7:0] stage0_B;
   reg [7:0] stage0_sum;
   reg stage0_carry;
   assign stage0_A = {1'b0, A[0] & B[7], A[0] & B[6], A[0] & B[5], A[0] & B[4], A[0] & B[3], A[0] & B[2], A[0] & B[1]};
   assign stage0_B = {A[1] & B[7], A[1] & B[6], A[1] & B[5], A[1] & B[4], A[1] & B[3], A[1] & B[2], A[1] & B[1], A[1] & B[0]};
   binary_adder_8bit binary_adder_8bit_0_inst
   (
   .A(stage0_A),
   .B(stage0_B),
   .C_in(0),
   .sum(stage0_sum),
   .C_out(stage0_carry)
   );

   //stage 1
   reg [7:0] stage1_A;
   reg [7:0] stage1_B;
   reg [7:0] stage1_sum;
   reg stage1_carry;
   assign stage1_A = {stage0_carry, stage0_sum[7:1]};
   assign stage1_B = {A[2] & B[7], A[2] & B[6], A[2] & B[5], A[2] & B[4], A[2] & B[3], A[2] & B[2], A[2] & B[1], A[2] & B[0]};
   binary_adder_8bit binary_adder_8bit_1_inst
   (
   .A(stage1_A),
   .B(stage1_B),
   .C_in(0),
   .sum(stage1_sum),
   .C_out(stage1_carry)
   );

   //stage 2
   reg [7:0] stage2_A;
   reg [7:0] stage2_B;
   reg [7:0] stage2_sum;
   reg stage2_carry;
   assign stage2_A = {stage1_carry, stage1_sum[7:1]};
   assign stage2_B = {A[3] & B[7], A[3] & B[6], A[3] & B[5], A[3] & B[4], A[3] & B[3], A[3] & B[2], A[3] & B[1], A[3] & B[0]};
   binary_adder_8bit binary_adder_8bit_2_inst
   (
   .A(stage2_A),
   .B(stage2_B),
   .C_in(0),
   .sum(stage2_sum),
   .C_out(stage2_carry)
   );
   
   //stage 3
   reg [7:0] stage3_A;
   reg [7:0] stage3_B;
   reg [7:0] stage3_sum;
   reg stage3_carry;
   assign stage3_A = {stage2_carry, stage2_sum[7:1]};
   assign stage3_B = {A[4] & B[7], A[4] & B[6], A[4] & B[5], A[4] & B[4], A[4] & B[3], A[4] & B[2], A[4] & B[1], A[4] & B[0]};
   binary_adder_8bit binary_adder_8bit_3_inst
   (
   .A(stage3_A),
   .B(stage3_B),
   .C_in(0),
   .sum(stage3_sum),
   .C_out(stage3_carry)
   );

   //stage 4
   reg [7:0] stage4_A;
   reg [7:0] stage4_B;
   reg [7:0] stage4_sum;
   reg stage4_carry;
   assign stage4_A = {stage3_carry, stage3_sum[7:1]};
   assign stage4_B = {A[5] & B[7], A[5] & B[6], A[5] & B[5], A[5] & B[4], A[5] & B[3], A[5] & B[2], A[5] & B[1], A[5] & B[0]};
   binary_adder_8bit binary_adder_8bit_4_inst
   (
   .A(stage4_A),
   .B(stage4_B),
   .C_in(0),
   .sum(stage4_sum),
   .C_out(stage4_carry)
   );

   //stage 5
   reg [7:0] stage5_A;
   reg [7:0] stage5_B;
   reg [7:0] stage5_sum;
   reg stage5_carry;
   assign stage5_A = {stage4_carry, stage4_sum[7:1]};
   assign stage5_B = {A[6] & B[7], A[6] & B[6], A[6] & B[5], A[6] & B[4], A[6] & B[3], A[6] & B[2], A[6] & B[1], A[6] & B[0]};
   binary_adder_8bit binary_adder_8bit_5_inst
   (
   .A(stage5_A),
   .B(stage5_B),
   .C_in(0),
   .sum(stage5_sum),
   .C_out(stage5_carry)
   );

   //stage 6
   reg [7:0] stage6_A;
   reg [7:0] stage6_B;
   reg [7:0] stage6_sum;
   reg stage6_carry;
   assign stage6_A = {stage5_carry, stage5_sum[7:1]};
   assign stage6_B = {A[7] & B[7], A[7] & B[6], A[7] & B[5], A[7] & B[4], A[7] & B[3], A[7] & B[2], A[7] & B[1], A[7] & B[0]};
   binary_adder_8bit binary_adder_8bit_6_inst
   (
   .A(stage6_A),
   .B(stage6_B),
   .C_in(0),
   .sum(stage6_sum),
   .C_out(stage6_carry)
   );

   assign _product[0]     =   A[0] & B[0]; 
   assign _product[1]     = stage0_sum[0]; 
   assign _product[2]     = stage1_sum[0]; 
   assign _product[3]     = stage2_sum[0]; 
   assign _product[4]     = stage3_sum[0]; 
   assign _product[5]     = stage4_sum[0]; 
   assign _product[6]     = stage5_sum[0]; 
   assign _product[14:7]  = stage6_sum; 
   assign _product[15]    = stage6_carry; 

   assign product = _product;

endmodule //Multiplier8Bit