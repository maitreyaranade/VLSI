# My FPGA Projects 

## Verilog & SystemVerilog Projects:

### 1. Clock divider
Please find ClockDivider folder including testbench and the module in SystemVerilog.

### 2. ALU with data_width
Please find ClockDivider folder including testbench and the module in SystemVerilog. This ALU carries out 15 arithmetic and logic operations on the operands such as +. -, *, /, Logic gates, <<, >>, and comparison etc.

### 3. SPI Master
 Please find SPIDriver-Master folder including waveform screenshot, testbench and the module in SystemVerilog. This module is used to implement a SPI master. The host transmits a certain number of SCLK pulses. This is placed in the n_clks port. It will always be less than or equal to SPI_MAXLEN.
 
* **SPI bus timing :** SPI clock frequency is the host clock frequency divided by CLK_DIVIDE. CLK_DIVIDE value is guaranteed to be even and >= 4. SCLK has a 50% duty cycle. The slave will expect to clock in data on the rising edge of SCLK; therefore this module outputs new MOSI values on SCLK falling edges. Similarly, MISO input bits latch on the rising edges of SCLK.

* **Command Interface :** 
  * The data to be transmitted on MOSI is placed on the tx_data port. The first bit of data to be transmitted is bit tx_data[n_clks-1] and the last bit transmitted is tx_data[0]. On completion of the SPI transaction, rx_miso should hold the data clocked in from MISO on each positive edge of SCLK. rx_miso[n_clks-1] should hold the first bit and rx_miso[0]  is the last. 
   
  * When the host wants to issue a SPI transaction, the host holds the start_cmd pin high. While start_cmd is asserted, the host guarantees that n_clks and tx_data are valid and stable. This module acknowledges receipt of the command by issuing a transition on spi_drv_rdy from 1 to 0. This module then performs the SPI transaction on the SPI lines. This module indicates completion of the command by transitioning spi_drv_rdy from 0 to 1. rx_miso must contain valid data when this transition happens, and the data remains stable until the next command starts.

### 4. Message Decoder

The FPGA receives data stream in Avalon streaming interface format from the exchange. The objective of this project is to design and implement a module that extracts messages from this stream and outputs it in a custom interface.
The data comes in samples of fixed width. The data includes message count, message length and message of "message length". Details of the problem statement are explained in "FPGA_Engineer_Assignment.pdf" file. And details abou the soultion are added in the "readMe.txt".

## VHDL Projects:

### 1. ALU
### 2. Comparator
### 3. DFlipFlopAsynch
### 4. DFlipFlopSynch
### 5. JKFlipFlopAsynch
### 6. JKFlipFlopSynch
### 7. JKSynchStuctural
### 8. UpDownCounter
