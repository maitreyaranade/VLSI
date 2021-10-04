`timescale 1ns / 1ps

// 32 bit CRC generator 

module CRCEthernet32Bit #(
    parameter DATA_WIDTH = 8,
    parameter CRC_WIDTH = 32
    )
   (
   input       clk,
   input       rst,
   input       start, 
   input       [DATA_WIDTH - 1:0] DataIn,
   output wire [CRC_WIDTH - 1:0] CRCOut, 
   output reg  done
   );

   // State declaration
    localparam [1:0]
    idle   = 2'b00,
    minus  = 2'b01,
    shift  = 2'b10,
    result = 2'b11;

   // Signal declaration
   reg [DATA_WIDTH + CRC_WIDTH - 1:0] dividend;
   reg [CRC_WIDTH : 0] divisor = 33'b 1_0000_0100_1100_0001_0001_1101_1011_0111; // CRC-32 Polynomial HEX 104C11DB7;
   // Polynomial: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + 1

   reg [CRC_WIDTH : 0]                xorIN;
   reg [CRC_WIDTH : 0]                xorOUT;
   reg [CRC_WIDTH -1: 0]              _result;

   reg [1:0] state, next_state;
   reg [4:0] _counter;


   // Assignments
   assign CRCOut = _result;

   // counter logic
   always @(posedge clk, posedge rst)
   begin    
      if (rst)
      begin
         _counter       <= 0;
         dividend       <= 0;
         xorOUT         <= 0;
         xorIN          <= 0;
      end
   end

   // current state logic
   always @(posedge clk, posedge rst)
   begin
      if (rst) 
      state <= idle;
      else 
      state  <= next_state;
   end

   // next state logic 
   always @ * 
   begin  
      done            = 1'b0;
      next_state      = state;
      _result         = 0;

      // FSM logic
      case(state)
         idle: 
         begin
            if(start) 
            begin
               dividend       = { DataIn , { CRC_WIDTH +1 {1'b0}} };   // after calculation, for data == 0, CRCOut comes out to be 32'hBCB4666D, if { CRC_WIDTH +1 {1'b0}} is replaced with 32'hBCB4666D, CRCOut becomes zero again. Hence verified. (Also, manually confirmed.)
               _counter       = DATA_WIDTH - 1;        // load DATA_WIDTH - 1 for (DATA_WIDTH - 1)-bit down counter
               xorIN          = dividend[CRC_WIDTH + DATA_WIDTH - 1 : DATA_WIDTH - 1];
               next_state     = minus;
            end
         end

         minus: 
         begin
            xorOUT = xorIN ^ divisor;            
            if(_counter == 0)
               next_state = result;  
            else 
               next_state  = shift;   
            _counter = _counter - 1;     
         end

         shift: 
         begin
            xorIN      = {xorOUT[CRC_WIDTH - 1:0], dividend[_counter]};
            next_state = minus;
         end

         result:
         begin
            done       = 1;
            _result    = xorOUT[CRC_WIDTH - 1:0];
            next_state = idle;            
         end

         default: 
            next_state = idle;

      endcase
   end

endmodule // CRCEthernet32Bit