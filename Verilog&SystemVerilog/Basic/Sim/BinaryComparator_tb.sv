module BinaryComparator_tb();

   // parameters 
   parameter DATA_WIDTH = 2;
   localparam MAX_TESTS = 10;

   // signals
   reg clk, start, rst;
   reg [DATA_WIDTH - 1:0] A;
   reg [DATA_WIDTH - 1:0] B;

   // Outputs
   wire AGB, AEB, ALB, done;

   // clock generation
   initial clk = 0;
   always clk = #10 ~clk;

   // Multiplier Instantiation
   BinaryComparator #(
    .DATA_WIDTH (DATA_WIDTH)
   ) BinaryComparator_inst (
    .clk      (clk),
    .rst      (rst),
    .start    (start),
    .A        (A),
    .B        (B),
    .AGB      (AGB),
    .AEB      (AEB),
    .ALB      (ALB),
    .done     (done)
   );

   initial 
   begin: initial_block
      integer i;
      rst = 1;       
      A = 0; 
      B = 0;
      start = 0;

      #20 rst = 0; 
      #20;
      
      for (i=0; i< MAX_TESTS; i=i+1)
      begin
         start = 1; // start
         A = $urandom%4; 
         B = $urandom%4;
         @(posedge done);
         $display("A %d, B: %d, AEB: %d, ALB: %d, AGB: %d", A, B, AEB, ALB, AGB);
         start = 0; // start
         #20;    
      end 
      #400;

      $finish();

   end 

endmodule // BinaryComparator_tb