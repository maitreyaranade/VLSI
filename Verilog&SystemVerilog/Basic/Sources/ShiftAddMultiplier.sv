`timescale 1ns / 1ps

// 8x8 Multiplier using Shift/Add Algorithm 

module multiplier_8bit_Shift_add
   (
   input       clk,
   input       rst,
   input       start, 
   input       [7:0] A,
   input       [7:0] B, 
   output wire [15:0] product, 
   output reg  done
   );

   
   localparam [1:0]
      idle   = 2'b00,
      add    = 2'b01,
      shift  = 2'b10,
      result = 2'b11;

   // signal declaration
   reg       carry, next_carry;
   reg [1:0] state, next_state;
   reg [7:0] buffer1, next_buffer1, buffer2, next_buffer2, input1, next_input1;   
   reg [4:0] _counter, _counter_next;

   // always @ *
   // begin
   //    if (done) 
   //    product = {buffer2, buffer1};
   //    else 
   //    product  <= 0;
   // end

   assign product = {buffer2, buffer1};

   // reset logic
   always @(posedge clk, posedge rst)
   begin
      if (rst) 
      begin
         _counter       <= 0;
         carry          <= 0;
         buffer1        <= 0;
         buffer2        <= 0;
         input1         <= 0;
      end
      else 
      begin
         carry       <= next_carry;
         _counter    <= _counter_next;
         buffer1     <= next_buffer1;
         buffer2     <= next_buffer2;
         input1      <= next_input1; 
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
      done           = 1'b0;
      next_buffer1   = buffer1;
      next_buffer2   = buffer2;
      next_input1    = input1; 
      next_carry     = carry;
      _counter_next  = _counter;
      next_state     = state;

      // FSM logic
      case(state)
         idle: 
         begin
            if(start) 
            begin
               _counter_next  = 8;        // load 8 for 8-bit down counter
               next_buffer1   = B;        // load multiplier into lower half
               next_buffer2   = 8'b0;     // clear upper half. 
               next_input1    = A;        // load A (multiplicand) into register. 
               next_state     = add;
            end
         end

         add: 
         begin
            if(buffer1[0] == 1) 
            begin
               {next_carry,next_buffer2} = buffer2 + input1;      // add A (multiplicand) to upper half with carry bit. 
            end
            _counter_next = _counter - 1;
            next_state   = shift;             
         end

         shift: 
         begin
            {next_carry,next_buffer2,next_buffer1} = {carry, buffer2, buffer1} >> 1;  // putting everything back together and shifting everything to the right once. 
            if(_counter_next == 0)
               next_state = result;            
            else 
               next_state = add;
         end

         result:
         begin
            done = 1;
            next_state = idle;            
         end

         default: 
         begin
         next_state = idle;
         end
      endcase

   end

endmodule // multiplier_8bit_Shift_add