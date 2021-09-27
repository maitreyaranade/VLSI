///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:       Simple test bench for 8x8 Multiplier module  using Shift/Add Algorithm module
///////////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module multiplier_8bit_Shift_add_tb();

   // parameters 
   localparam MAX_TESTS = 10; 
   // signals
   reg clk, start, rst;
   reg [7:0] A = 0;
   reg [7:0] B = 0;
   reg [15: 0] product = 0;

   // Outputs
   wire done;

   // clock generation
   initial clk = 0;
   always clk = #10 ~clk;

   // Multiplier Instantiation
   multiplier_8bit_Shift_add multiplier_8bit_Shift_add_inst
   (
   .clk      (clk),
   .rst      (rst),
   .start    (start),
   .A        (A),
   .B        (B),
   .product  (product),
   .done     (done)
   );


   initial 
   begin
      integer i;
      rst = 1; // rst
      start = 0;

      #40 rst = 0; 
      #40 start = 1; // start
      
      for (i=0; i< MAX_TESTS; i=i+1)
      begin
         start = 1; // start
         A = $urandom%255; 
         B = $urandom%255;
         @(posedge done);
         $display("A %d, B: %d, product: %d", A, B, product);
         #20;    
      end 
      #400;

      $finish();

   end 

endmodule // multiplier_8bit_Shift_add_tb