`timescale 1ns / 1ps


//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Maitreya Ranade
// 
// Create Date: 05.06.2020 09:56:41
// Design Name: 
// Module Name: top
// Project Name: TestBench for Message Decoder with Avalon streaming interface and a custom output interface+
// Target Devices: 
// Tool Versions: 
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
// Input interface: 
//
// The module to be designed receives the data stream in Avalon streaming interface
// clk                => Positive edge triggered clock
// reset_n            => Active low reset
// in_valid           => High when incoming data is valid, low other wise
// in_startofpayload  => High for 1 cycle, marks the beginning of incoming payload; should be qualified with in_valid
// in_endofpayload    => High for 1 cycle, marks the end of incoming payload; should be qualified with in_valid
// in_ready           => Asserted by the module being design to indicate that it is ready to accept data. Read Latency=1
// in_data            => Data in the given sample exchange protocol 
// in_empty           => Always qualified when in_endofpacket is high. Indicates the number of empty bytes in the last cycle of the incoming payload
// in_error           => Used to indicate an error in the incoming data stream
// 
// Output interface: 
//
// out_data,          => Extracted message
// out_valid,         => High when out_data is valid; low otherwise
// out_bytemask       => Used to indicate the number of valid bytes in out_data. For example, if out_data has 10 valid bytes, then out_bytemask is 32'b0000_0000_0000_0000_0000_0011_1111_1111 and so on.    
//
//
//////////////////////////////////////////////////////////////////////////////////

module top();

    // Parameter, Localparam, and variable definitions
    parameter DATA_WIDTH   = 64;   
    parameter OUTPUT_WIDTH = 256; 
    parameter OUTPUT_MASK_WIDTH = 32;
    
    localparam SIMULATION_RUN_TIME = 1000;              // Simulation time
    localparam SAMPLE_COUNT = 15;                          // Number of Data Samples
    
    logic                              clk=1;
    logic                              reset_n=0;
    logic                              in_valid=0;          
    logic                              in_startofpayload=0; 
    logic                              in_endofpayload=0;   
    logic                              in_ready;          
    logic [DATA_WIDTH -1 : 0]          in_data;           
    logic [2: 0]                       in_empty;          
    logic                              in_error=0; 
    logic [OUTPUT_WIDTH - 1:0]         out_data;          
    logic                              out_valid;         
    logic [OUTPUT_MASK_WIDTH - 1 : 0]  out_bytemask;
    
    integer i=0, j=0, k=0; 
      
    logic [DATA_WIDTH -1 : 0] dataIn [SAMPLE_COUNT - 1:0];  // Data is fetched and stored in 2D array from the "input.sv" file
    
    //Clock generation
    always #(10) clk = ~clk;  
    
    // Instance of the dut
    msgDecoder #(
    .DATA_WIDTH(DATA_WIDTH), 
    .OUTPUT_WIDTH(OUTPUT_WIDTH)   
    ) dut(
     .clk                  (clk),
     .reset_n              (reset_n),
     .in_valid             (in_valid),         
     .in_startofpayload    (in_startofpayload),
     .in_endofpayload      (in_endofpayload),  
     .in_ready             (in_ready),         
     .in_data              (in_data),          
     .in_empty             (in_empty),         
     .in_error             (in_error), 
     .out_data             (out_data),         
     .out_valid            (out_valid),        
     .out_bytemask         (out_bytemask)
    );
    
    
    
    
    // Initialization of signals
    initial
    begin   
        // Adding input from a file (location is in the parent directory of the project)
        j=$fopen("../../../../input.txt","r");               // reading input
        while (! $feof(j))                                   // Read until an "end of file" is reached
        begin
            $fscanf(j,"%h\n", dataIn[k]);                    // Scan each line and get the value as an hexadecimal
            k++;
        end
        $fclose(j);                                          // Once reading and writing is finished, close the file
        in_data    =  0;    
        @(posedge clk);
        reset_n            = 1;                              // Synchronous reset
        @(posedge clk);
        @(posedge clk);
        in_startofpayload  = 1;
        @(posedge clk);
        in_startofpayload  = 0;
    end

    // Write output to the file (location is in the parent directory of the project)
    integer f =0;
    initial 
    begin
        f = $fopen("../../../../output.txt","w");
        #SIMULATION_RUN_TIME;                                 // Simulation run time
        $fclose(f);
        $finish;                                              // End of simulation
    end

    // Purpose: Writing data to the file
    always @(posedge clk)
    begin
        if(out_valid)
            $fwrite(f,"%0h\n",out_data);
    end 
    
    // Purpose: Generating and sending data to dut
    always @(posedge clk)
    begin
      if (in_ready)
      begin
          in_valid <=  1;
          if(i<SAMPLE_COUNT)
          begin
              in_data  <= dataIn[i];
              i <= i + 1;
          end
          if (i == SAMPLE_COUNT -1)
          begin
              in_endofpayload    <= 1;
              in_empty           <= 4;
              i <= i + 1;
          end
          if(i >= SAMPLE_COUNT)
          begin
              in_endofpayload <= 0;
              in_empty        <= 0;
              in_data  <=  0;
              in_valid <=  0; 
          end
      end
      else
      begin
        in_valid <=  0;
        in_data  <=  0;   
      end
    end
    
endmodule 
