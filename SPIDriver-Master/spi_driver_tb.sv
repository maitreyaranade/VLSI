`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Maitreya Ranade
// 
// Create Date: 14.05.2020 21:20:02
// Design Name: 
// Module Name: top
// Project Name: SPI Driver Master Testbench
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
// SPI Master Module
//
// This module is used to implement a SPI master. The host will want to transmit a certain number
// of SCLK pulses. This number will be placed in the n_clks port. It will always be less than or
// equal to SPI_MAXLEN.
//
// SPI bus timing
// --------------
// This SPI clock frequency should be the host clock frequency divided by CLK_DIVIDE. This value is
// guaranteed to be even and >= 4. SCLK should have a 50% duty cycle. The slave will expect to clock
// in data on the rising edge of SCLK; therefore this module should output new MOSI values on SCLK
// falling edges. Similarly, you should latch MISO input bits on the rising edges of SCLK.
//
// Command Interface
// -----------------
// The data to be transmitted on MOSI will be placed on the tx_data port. The first bit of data to
// be transmitted will be bit tx_data[n_clks-1] and the last bit transmitted will be tx_data[0].
//  On completion of the SPI transaction, rx_miso should hold the data clocked in from MISO on each
// positive edge of SCLK. rx_miso[n_clks-1] should hold the first bit and rx_miso[0] will be the last.
//
//  When the host wants to issue a SPI transaction, the host will hold the start_cmd pin high. While
// start_cmd is asserted, the host guarantees that n_clks and tx_data are valid and stable. This
// module acknowledges receipt of the command by issuing a transition on spi_drv_rdy from 1 to 0.
// This module should then being performing the SPI transaction on the SPI lines. This module indicates
// completion of the command by transitioning spi_drv_rdy from 0 to 1. rx_miso must contain valid data
// when this transition happens, and the data must remain stable until the next command starts.
//
//////////////////////////////////////////////////////////////////////////////////


module top();
    
  parameter SPI_MAXLEN = 32;
  parameter CLK_DIVIDE = 100;
  parameter n_clks = 36;
  
  logic clk=0, sresetn=1, start_cmd = 0;
  logic MOSI_MISO;
  logic [SPI_MAXLEN-1:0] rx_miso;
  logic [SPI_MAXLEN-1:0] tx_data = 0;  
  logic spi_drv_rdy;

  always #(10) clk = ~clk;

  // Instantiation os SPI driver Master
   spi_drv #(
   .CLK_DIVIDE(CLK_DIVIDE), 
   .SPI_MAXLEN(SPI_MAXLEN)   
   ) dut(
    .clk          (clk),
    .sresetn      (sresetn),
    .start_cmd    (start_cmd),  
    .spi_drv_rdy  (spi_drv_rdy),  
    .n_clks       (n_clks),  
    .tx_data      (tx_data),  
    .rx_miso      (rx_miso),
    .SCLK         (),  
    .MOSI         (MOSI_MISO),  
    .MISO         (MOSI_MISO),  
    .SS_N         () 
    );


  // Function that sends a single byte from master.
  task SendSingleByte(input [SPI_MAXLEN-1:0] data);
    @(posedge clk);
    tx_data     <= data;
    start_cmd   <=1;
    @(posedge clk);
    start_cmd   <=0;
    @(negedge spi_drv_rdy);
  endtask 
  
  // The initial initates all variables and calls function SendSingleByte to verify sent and received byte.
  // One can verify the test by looking this "Sent out 0xC128ABE9, Received 0xC128ABE9" in the simulation console.
  initial
    begin 
      $dumpfile("SPIMaitreya.vcd"); 
      $dumpvars;
      
      repeat(10) @(posedge clk);
      sresetn    = 1;
      repeat(10) @(posedge clk);
      sresetn    = 0;
      
      // Test single byte
      SendSingleByte(32'hC128ABE9);
      $display("Sent out 0xC128ABE9, Received 0x%X", rx_miso); 
      
      // Test double byte
      SendSingleByte(32'hB991FE65);
      $display("Sent out 0xB991FE65, Received 0x%X", rx_miso); 
      SendSingleByte(32'hE08657BB);
      $display("Sent out 0xE08657BB, Received 0x%X", rx_miso); 
      repeat(10) @(posedge clk);
      $finish();      
    end

endmodule 
