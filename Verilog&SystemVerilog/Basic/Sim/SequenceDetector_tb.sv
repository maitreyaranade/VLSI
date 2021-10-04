module sequence_detector_101101_tb;
  reg 			clk;
  reg 			in;
  reg 			rst;
  wire 			mealy_out, moore_out;
  
  always #10 clk = ~clk;
  
  sequence_detector_101101_mealy sequence_detector_101101_mealy_inst
    (
        .clk(clk), 
        .rst(rst), 
        .in(in), 
        .out(mealy_out)
    );
  
  sequence_detector_101101_moore sequence_detector_101101_moore_inst
    (
        .clk(clk), 
        .rst(rst), 
        .in(in), 
        .out(moore_out)
    );


  initial 
  begin	
    integer i;
  	clk <= 0;
    rst <= 1;
    in <= 0;
    
    repeat (5) @ (posedge clk);
    rst <= 0;
    in <= $urandom;
    repeat (5) @ (posedge clk);

	// Generating pattern
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 0;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 1; 	
    @(posedge clk) in <= 0;
    @(posedge clk) in <= 1;         // Pattern detected
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 0;
    @(posedge clk) in <= 1;         // Pattern completed again
    @(posedge clk) in <= 1; 	 
    @(posedge clk) in <= 1; 	 
    @(posedge clk) in <= 0; 

    for (i=0; i< 100; i=i+1)
    begin
        @(posedge clk);
        in <= $urandom;
    end

    $finish;  
  end
endmodule  // sequence_detector_101101_tb
