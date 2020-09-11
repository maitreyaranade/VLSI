`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Maitreya Ranade
// 
// Create Date: 14.05.2020 21:20:02
// Design Name: 
// Module Name: spi_drv
// Project Name: SPI Driver Master
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

module spi_drv #(
    parameter integer               CLK_DIVIDE  = 100, // Clock divider to indicate frequency of SCLK
    parameter integer               SPI_MAXLEN  = 32   // Maximum SPI transfer length
) (
    input                           clk,
    input                           sresetn,           // active low reset, synchronous to clk
    
    // Command interface 
    input                           start_cmd,         // Start SPI transfer
    output                          spi_drv_rdy,       // Ready to begin a transfer
    input  [$clog2(SPI_MAXLEN):0]   n_clks,            // Number of bits (SCLK pulses) for the SPI transaction
    input  [SPI_MAXLEN-1:0]         tx_data,           // Data to be transmitted out on MOSI
    output [SPI_MAXLEN-1:0]         rx_miso,           // Data read in from MISO
    
    // SPI pins
    output                          SCLK,              // SPI clock sent to the slave
    output                          MOSI,              // Master out slave in pin (data output to the slave)
    input                           MISO,              // Master in slave out pin (data input from the slave)
    output                          SS_N               // Slave select, will be 0 during a SPI transaction
);


    
logic [$clog2(CLK_DIVIDE)-1:0] count;
logic [$clog2(SPI_MAXLEN)+1:0] _n_edges;
logic _risingEdge;
logic _fallingEdge;
logic [$clog2(CLK_DIVIDE):0] clk_period;
logic _clk_div;
logic _spi_drv_rdy;
logic _MOSI;
logic [SPI_MAXLEN-1:0] _rx_miso;
logic _start_cmd_delay;
logic [SPI_MAXLEN-1:0] _tx_data_delay;
logic [$clog2(SPI_MAXLEN) - 1 :0] _RXBitCount;
logic [$clog2(SPI_MAXLEN) - 1 :0] _TXBitCount;


assign clk_period = CLK_DIVIDE >> 1;        // I have pulled it permanently low as it has 0 value for transaction and nothing is mentioned otherwise
assign SCLK = sresetn ? 0 : _clk_div;       // SCLK definition with sresetn
assign MOSI = _MOSI;                        // Internal Registers for Stable Output pins
assign rx_miso = _rx_miso;                  // Internal Registers for Stable Output pins
assign spi_drv_rdy = ~_spi_drv_rdy;         // I added this logic for spi_drv_rdy and inverted it at the end.
assign SS_N = 0;                            // I have pulled it permanently low as it has 0 value for transaction and nothing is mentioned otherwise


// Clock divitions with 

always @(posedge clk or negedge sresetn)
begin
  if (sresetn)
  begin
    // Setting default values to variables
    _spi_drv_rdy   <= 0;                
    _n_edges       <= 0;                
    _risingEdge    <= 0;                
    _fallingEdge   <= 0;                
    _clk_div       <= 0;                
    count          <= 0;
  end
  else
  begin
    _risingEdge    <= 0;                     // these are defined for making different operarions at different edges according to the problem statment.
    _fallingEdge   <= 0;                     // these are defined for making different operarions at different edges according to the problem statment.
    
    if (start_cmd)
    begin
      _spi_drv_rdy <= 0;
      _n_edges     <= n_clks << 1;           // No of edges = no fo clocks * 2
    end
    else if (_n_edges > 0)
    begin
      _spi_drv_rdy <= 0;        
      if (count == CLK_DIVIDE-1)             // Later half of the SCLK clk
      begin
        _n_edges     <= _n_edges - 1;
        _fallingEdge <= 1;
        count        <= 0;
        _clk_div     <= ~_clk_div;
      end
      else if (count == clk_period-1)        // First half of the SCLK clk
      begin
        _n_edges     <= _n_edges - 1;
        _risingEdge  <= 1;
        count        <= count + 1;
        _clk_div     <= ~_clk_div;
      end
      else
        count        <= count + 1;
    end  
    else
      _spi_drv_rdy   <= 1;      
  end                                       //!if(sresetn)
end                                         // always @ (posedge clk or negedge sresetn) 


// Purpose: Register tx_data when Data Valid is pulsed.
// Keeps local storage of byte in case higher level module changes the data
always @(posedge clk or negedge sresetn)
begin
  if (sresetn)
  begin
    _tx_data_delay <=  {SPI_MAXLEN{1'b0}};
    _start_cmd_delay   <= 0;
  end
  else
    begin
      _start_cmd_delay <= start_cmd;      // this is required in the following stages. Can't use start_cmd as is. There's a delay in the later blocks.
      if (start_cmd)
      begin
        _tx_data_delay <= tx_data;
      end
    end 
end

//Transmitting MOSI data
always @(posedge clk or negedge sresetn)
begin
  if (sresetn)
  begin
    _MOSI            <= 0;
    _TXBitCount      <= {$clog2(SPI_MAXLEN){1'b1}}; // send MSb first
  end
  else
  begin
    if (_spi_drv_rdy)
      _TXBitCount    <= {$clog2(SPI_MAXLEN){1'b1}};
    else if (_start_cmd_delay)
    begin
      _MOSI          <= _tx_data_delay[ _TXBitCount ];
      _TXBitCount    <= {$clog2(SPI_MAXLEN){1'b1}} - 1;
    end
    else if (_fallingEdge)
    begin
      _TXBitCount    <= _TXBitCount - 1;
      _MOSI          <= _tx_data_delay[_TXBitCount];
    end
  end
end


//Reading MISO data.
always @(posedge clk or negedge sresetn)
begin
  if (sresetn)
  begin
    _rx_miso                <= {$clog2(SPI_MAXLEN){1'b0}};
    _RXBitCount             <= {$clog2(SPI_MAXLEN){1'b1}};
  end
  else
  begin
    if (_spi_drv_rdy)     
      _RXBitCount           <= {$clog2(SPI_MAXLEN){1'b1}};

    else if (_risingEdge)
    begin
      _rx_miso[_RXBitCount] <= MISO;  
      _RXBitCount           <= _RXBitCount - 1;
    end
  end
end


endmodule
