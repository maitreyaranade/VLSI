///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:       Simple test bench for 8x8 Multiplier module  using Shift/Add Algorithm module
///////////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module CRCEthernet32Bit_tb();

   // parameters 
   parameter DATA_WIDTH = 8;
   parameter CRC_WIDTH = 32;
   localparam MAX_TESTS = 10;

   // signals
   reg clk, start, rst;
   reg [DATA_WIDTH - 1:0] DataIn;

   // Outputs
   wire done;
   wire [CRC_WIDTH - 1:0] CRCOut;

   // clock generation
   initial clk = 0;
   always clk = #10 ~clk;

   // Multiplier Instantiation
   CRCEthernet32Bit #(
    .DATA_WIDTH (DATA_WIDTH),
    .CRC_WIDTH (CRC_WIDTH)
    ) CRCEthernet32Bit_inst (
    .clk      (clk),
    .rst      (rst),
    .start    (start),
    .DataIn   (DataIn),
    .CRCOut   (CRCOut),
    .done     (done)
   );


   initial 
   begin: initial_block
      integer i;
      rst = 1;       
      DataIn = 0; 
      start = 0;

      #20 rst = 0; 
      #20;
      
      for (i=0; i< MAX_TESTS; i=i+1)
      begin
         start = 1; // start
         DataIn = 0; // $urandom%255;
         @(posedge done);
         $display("DataIn: %d, CRCOut: %d", DataIn, CRCOut);
         #20;    
      end 
      #400;

      $finish();

   end 

endmodule // CRCEthernet32Bit_tb