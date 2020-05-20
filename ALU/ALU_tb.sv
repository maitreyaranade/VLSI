`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Maitreya Ranade
// 
// Create Date: 20.05.2020 12:14:02
// Design Name: 
// Module Name: top
// Project Name: ALU
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


module top();

  parameter DATA_WIDTH = 16;
  logic [ DATA_WIDTH -1 :0] Input1,Input2;
  logic [3:0] Operator;
  logic [ DATA_WIDTH -1 :0] Result;
  logic Carry;
  integer i;

  alu  #(
    .DATA_WIDTH(DATA_WIDTH)  
     )  dut(
             Input1,Input2,  // ALU 8-bit Inputs                 
             Operator,       // ALU Selection
             Result,         // ALU 8-bit Output
             Carry           // Carry Out Flag
      );
     initial 
     begin
       Input1   <=  {{DATA_WIDTH}{1'b0}};
       Input2   <=  {{DATA_WIDTH}{1'b0}};
       Operator <=  4'h0;

       #100;      // hold reset state for 100 ns.
       
       for (i=0;i<=15;i=i+1)
       begin  
        Input1   <= $urandom;
        Input2   <= $urandom;  
        #10;
        Operator <= Operator + 1;   
       end;
       
       $finish();

     end

endmodule