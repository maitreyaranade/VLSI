`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Maitreya Ranade
// 
// Create Date: 3.06.2020 15:20:02
// Design Name: 
// Module Name: msgDecoder
// Project Name: Message Decoder with Avalon streaming interface and a custom output interface+
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
// out_bytemask       => Used to indicate the number of valid bytes in out_data. For example, if out_data has 10 valid bytes, then out_bytemask is 32’b0000_0000_0000_0000_0000_0011_1111_1111 and so on.    
//
// Assumptions: 
//   * The maximum number of bytes in a single payload will not exceed 1,500 bytes.
//   * The minimum size of a message is 8 bytes and the maximum size of a message is 32 bytes.
//   * "in_error" is always 0.
//   * "in_valid" depends on the "in_ready" from the module.
//   * "in_data" depends on the "in_ready" from the module. 
//   * "in_ready" should have Read Latency=1. 
//   * At "reset_n" :
//       * "in_valid" should be zero should have a delay of one clock cycle after reset_n.
//       * "in_startofpayload" should pulse after one clock cycle after "reset_n" and should be zero.
//       * "in_endofpayload" should be zero.
//   * Maximum payload size is 1500 bytes.
//   * Minimum size of the msg is 8 bytes.
//   * Maximum size of the msg is 32 bytes.
//   * There's minimum of 2 clock cycle delay requied between processing of the first payload and the next payload.
//
//////////////////////////////////////////////////////////////////////////////////


module msgDecoder #(
    parameter integer                      DATA_WIDTH   = 64,        // Message data width
    parameter integer                      OUTPUT_WIDTH = 256,       // Extracted message data width
    parameter integer                      OUTPUT_MASK_WIDTH = 32    // out_bytemask data width
) (                                                     
    input                                  clk,                      // Positive edge triggered clock
    input                                  reset_n,                  // Active low reset
    
    // Command interface : data stream in Avalon streaming interface
    input                                  in_valid,                 // High when incoming data is valid, low other wise
    input                                  in_startofpayload,        // High for 1 cycle, marks the beginning of incoming payload; should be qualified with in_valid
    input                                  in_endofpayload,          // High for 1 cycle, marks the end of incoming payload; should be qualified with in_valid
    output                                 in_ready,                 // Asserted by the module being design to indicate that it is ready to accept data. Read Latency=1
    input [DATA_WIDTH -1 : 0]              in_data,                  // Data in the given sample exchange protocol 
    input [2: 0]                           in_empty,                 // Always qualified when in_endofpacket is high. Indicates the number of empty bytes in the last cycle of the incoming payload
    input                                  in_error,                 // Used to indicate an error in the incoming data stream
                                                                     
    
    // Command interface : data stream in custom data stream interface
    output [OUTPUT_WIDTH - 1:0]            out_data,                 // Extracted message
    output                                 out_valid,                // High when out_data is valid; low otherwise
    output [OUTPUT_MASK_WIDTH - 1 : 0]     out_bytemask              // Used to indicate the number of valid bytes in out_data. Eg., out_data with 10 valid bytes will need an out_bytemask: 32’b0000_0000_0000_0000_0000_0011_1111_1111.    
);

// Purpose: state machine for read input Avalon streaming interface    -------------------------------------------------
// States : explanation of the states is in the FSM and Readme File

typedef enum logic[1:0]{
  IDLE    = 'b00,
  TRANS   = 'b01,
  HOLD    = 'b10,
  END     = 'b11
} stateTypes;

stateTypes _state, _stateNext; 
integer _msgCount, _msgSent =0;

// in_ready signal generation
logic _readyDelay,_ready;
assign in_ready = _ready;
always_ff @ (posedge clk)
begin
if(reset_n)
    begin
        _readyDelay  <= 1;
        _ready       <= _readyDelay && ( in_valid || !_msgSent);
    end
else
    begin
        _readyDelay <= 0;
        _ready      <= 0;
    end
end   

// State Transistion
always_ff @ (posedge clk)
begin
if(reset_n)
    _state <= _stateNext;
end 

// Next State Logic
always_comb 
begin
    case (_state)
    IDLE: 
        begin
            if(in_startofpayload & in_valid)
                _stateNext <= TRANS;
        end
    TRANS:
        begin
            if(!in_ready)
            _stateNext <= HOLD;
            if(in_endofpayload)
            _stateNext <= END;
        end
    HOLD:
        begin
            if(in_ready)
            _stateNext <= TRANS;
        end
    END:
        _stateNext <= IDLE;
    default:
        _stateNext <= IDLE;
    endcase   
end


// Purpose: Data alignment fom intput to output custom streaming interface    ------------------------------------------------- 

localparam MSG_COUNT            = 16;                                                           // Length of Message Count in bits 
localparam MSG_LENGTH           = 16;                                                           // Length of Message length in bits 
localparam MAX_MSGS_IN_PAYLOAD  = 150;                                                          // Maximum number of msgs in payload 
localparam MSG_COUNT_WIDTH      =$clog2(MAX_MSGS_IN_PAYLOAD);                                   
localparam MAX_LENGTH_IN_PAYLOAD  = 256;                                                        // Maximum length of msg in bytes 256bits 32 bytes
localparam MSG_LENTH_WIDTH      =$clog2(MAX_LENGTH_IN_PAYLOAD);
localparam MAX_DATA_SAMPLES       = 256;                                                        // Maximum number of data samples of 64 widths 
localparam MAX_DATA_SAMPLES_WIDTH      =$clog2(MAX_DATA_SAMPLES);

// Variable dclararions
logic [MSG_LENGTH - 1 : 0] _currentMsgLength =0;                                                 // Length of the Current message being read in bytes
logic [DATA_WIDTH - 1 : 0] _firstDataIn;
logic [MAX_DATA_SAMPLES - 1 : 0] [DATA_WIDTH -1 : 0] _dataIn=0;                                   // Array used for storing the data
logic [OUTPUT_WIDTH -1: 0] _dataOut =0;                                                         // Variale for Data to be sent out
logic [OUTPUT_MASK_WIDTH -1: 0] _bytemask =0;
logic _spillMsg=0 , _spillMsgLen =0, _readingMsgLen =1, _readingMsg =0;
logic _validOut =0;
logic _sampleWithOnlyMsg =0;
logic _waitMsgSending =0;
logic _processing =0;

integer _offset;                                                                                 // "offset" is a pointer pointing to current reading bit and location 
logic[$clog2(DATA_WIDTH) - 1: 0] _remainingSampleWidth;                                                                   // "_remainingSampleWidth" variable is defined which signify bits yet to be read in a data sample
logic[$clog2(OUTPUT_WIDTH) - 1: 0] _remainingMsgWidth =0;                                                                   // "_remainingMsgWidth" variable is defined which signify 
logic[$clog2(MSG_LENGTH) - 1: 0] _remainingMsgLenWidth =0;
logic[MSG_LENGTH -1 : 0] _currentMsgLengthBits;
integer i=0, j=0, k= 0;


// Assign statements for some processes
assign _remainingSampleWidth = DATA_WIDTH - _offset;                                             
assign out_bytemask = _bytemask;
assign _firstDataIn = in_valid ? (in_startofpayload ? in_data : _firstDataIn) : 0;
assign _msgCount =  reset_n ? (in_valid ? (_firstDataIn[DATA_WIDTH - 1 -: MSG_COUNT]): _msgCount) : 0;           // getting the msg_count from "in_startofpayload"
assign out_valid = _validOut;                                                                    // defining "out_valid"
assign out_data = _validOut ? _dataOut : 0;                                                      // defining "out_data"

// Purpose: Store incoming data in a 2D array: _dataIn[j]
always_comb
begin
    if(reset_n && in_valid)
        _dataIn[k] <= in_data;
end

always_ff @ (posedge clk)
begin    
    if (reset_n && in_valid)
    begin        
        k <= k +1;  
    end
end

// Purpose: Deafult offset is 16 as First 16 bits are MSG_COUNT
always_ff @ (posedge clk)
begin    
    if (!reset_n)
        _offset <= MSG_COUNT;
end


// Purpose: Definition of _msgSent default values
always_ff @ (posedge clk)
begin    
    if (!reset_n)
        _msgSent <= 0;  
end


// Purpose: Definition of _processing default values
always_comb
begin    
    if (reset_n)
    begin
        if(in_startofpayload)
            _processing<= 1;
        if(_msgSent >= _msgCount)
            _processing<= 0;
    end
    else
        _processing <= 0;  
end

        

// Purpose: Splitting and outputting the data
// Following always_ff block has been written in order to  split the data and process it further.
//  * Data is read only till the msg count. if(_msgSent < _msgCount) is a check for that.
//  * At every positive clock edge, the control goes to either "if(_readingMsgLen)" or "if(_readingMsg)"
//      * While reading the message length, 3 cases are considered and treated separately.
//          1. _remainingSampleWidth > MSG_LENGTH : Msg length is stored in _currentMsgLength, Control is passed to _readingMsg, offset is set accordingly.
//          2. _remainingSampleWidth = MSG_LENGTH : Msg length is stored in _currentMsgLength, Control is passed to _readingMsg, offset is set accordingly. 
//          3. _remainingSampleWidth < MSG_LENGTH : Stores part of the Msg length in _currentMsgLength, wait for the next clock cycle store the remaining part.
//              then the Control is passed to _readingMsg, offset is set accordingly.
//
//      * While reading the message, 3 cases are considered and treated separately. "_currentMsgLengthBits" is obtained from "_readingMsgLen "
//          1. _remainingSampleWidth > _currentMsgLengthBits: Message is stored in _dataOut, Control is passed to _readingMsgLen, offset is set accordingly.
//          2. _remainingSampleWidth = _currentMsgLengthBits: Message is stored in _dataOut, Control is passed to _readingMsgLen, offset is set accordingly. 
//          3. _remainingSampleWidth < _currentMsgLengthBits: Unlike message length, the message can spill over multiple data samples of 64 bits width. 
//                    part of the message is stored _dataOut, wait for the next clock cycle/s and check multiple cases anf then store the remaining part.
//                    then the Control is then passed to the _readingMsgLen, offset is set accordingly.
//                        (i)   _remainingMsgWidth > DATA_WIDTH : The message is read at this clock cycle and the control is changed to reading the next message.
//                                    the offset is   set accordingly.
//                        (ii)  _remainingMsgWidth = DATA_WIDTH : The message is read at this clock cycle and the control is changed to reading the next message. 
//                                    the offset is   set accordingly.
//                        (iii) _remainingMsgWidth < DATA_WIDTH :  Part of the message is read at this clock cycle and remaining in following clock cycles. 
//                                    And then the control is changed to reading the next message. 
//  * The process stops when sent messages reach _msgCount and hence detects the desired output


always_ff @ (posedge clk)
begin  
    if(!_waitMsgSending)                                                                      // One clock cycle delay between messages for setting variables.
    begin
        if(_msgSent < _msgCount && _processing)                                                                  // Data is read only till the msg count. This is a check for that.
        begin
            // ---------------  Reading Message Length ------------------ //        
            if(_readingMsgLen)
            begin 
                _currentMsgLength <= 0; 
                
                if(_spillMsgLen)                                                                   // This loop runs when message length loops over multiple input data samples
                begin                    
                    for(j=0; j<_remainingMsgLenWidth; j++)
                    begin
                        _currentMsgLength[(_remainingMsgLenWidth -1 - j) -: 1] <= _dataIn[i][( DATA_WIDTH -1 -j) -: 1];
                    end
                    _spillMsgLen <= 0;
                    _offset <= _offset + _remainingMsgLenWidth;
                    _readingMsgLen <= 0;
                    _readingMsg <= 1;
                    _remainingMsgLenWidth <= 0;
                end   // end of if(_spillMsgLen)
                
                else                                                                                
                begin                
                    if(_remainingSampleWidth > MSG_LENGTH)
                    begin
                        _currentMsgLength <= _dataIn[i][(_remainingSampleWidth-1) -: MSG_LENGTH];
                        _offset <= _offset + MSG_LENGTH;
                        _readingMsgLen <= 0;
                        _readingMsg <= 1;
                    end
                    else if (_remainingSampleWidth == MSG_LENGTH)
                    begin
                        _currentMsgLength <= _dataIn[i][(_remainingSampleWidth-1) -: MSG_LENGTH];
                        _offset <=0;
                        _readingMsgLen <= 0;
                        _readingMsg <= 1;
                        i++;
                    end
                    else 
                    begin
                        _remainingMsgLenWidth <= MSG_LENGTH - _remainingSampleWidth;             
                        for(j=0; j<_remainingSampleWidth; j++)
                        begin
                            _currentMsgLength[(MSG_LENGTH - 1) -j -: 1] <= _dataIn[i][((_remainingSampleWidth-1) -j) -: 1];
                        end
                        _spillMsgLen <= 1;
                        _offset <= 0;
                        i++;                
                    end      // end of (_remainingSampleWidth > MSG_LENGTH)
                end 
                
            end     // end of if(_readingMsgLen)
            
            
            // ---------------  Reading Message ------------------ //
            if(_readingMsg)
            begin   
                if(_spillMsg)                                                                       // This loop runs when message loops over multiple input data samples
                begin       
                    if(_remainingMsgWidth > DATA_WIDTH)
                    begin
                        _sampleWithOnlyMsg <= 1;
                        _dataOut[(_remainingMsgWidth - 1) -: DATA_WIDTH] <= _dataIn[i];
                        _remainingMsgWidth <= _remainingMsgWidth - DATA_WIDTH;
                        i++;    
                    end
                    else if (_remainingMsgWidth == DATA_WIDTH)
                    begin
                        _dataOut[(_remainingMsgWidth - 1) -: DATA_WIDTH] <= _dataIn[i];
                        _remainingMsgWidth <= 0;
                        _readingMsgLen <= 1;
                        _readingMsg <= 0;
                        _spillMsg <= 0;
                        _msgSent++;
                        _waitMsgSending <= 1; 
                        _validOut <= 1;
                        i++;    
                    end
                    else
                    begin   
                        _sampleWithOnlyMsg <= 0;               
                        for(j=0; j<_remainingMsgWidth; j++)
                        begin
                            _dataOut[(_remainingMsgWidth -1) - j -: 1] <= _dataIn[i][ ( DATA_WIDTH -1 -j) -: 1];
                        end
                        _offset <= _offset + _remainingMsgWidth;
                        _readingMsgLen <= 1;
                        _readingMsg <= 0;
                        _spillMsg <= 0;
                        _msgSent++;
                        _waitMsgSending <= 1; 
                        _validOut <= 1;
                        _remainingMsgWidth <= 0;          
                    end 
                end // end of if(_spillMsg) 
                
                else  // else of if(_spillMsg) 
                begin   
                    if(_remainingSampleWidth > _currentMsgLengthBits)
                    begin           
                        for(j=0; j<_currentMsgLengthBits; j++)
                        begin
                            _dataOut[_currentMsgLengthBits - j -: 1] <= _dataIn[i][(DATA_WIDTH - 1 - _remainingSampleWidth) - j -: 1];
                        end 
                        _offset <= _offset + _currentMsgLengthBits;
                        _readingMsgLen <= 1;
                        _readingMsg <= 0;
                        _msgSent++;
                        _waitMsgSending <= 1; 
                        _validOut <= 1;
                    end
                    else if (_remainingSampleWidth == _currentMsgLengthBits)
                    begin        
                        for(j=0; j<_currentMsgLengthBits; j++)
                        begin
                            _dataOut[_remainingSampleWidth - j -: 1] <= _dataIn[i][(DATA_WIDTH - 1 - _remainingSampleWidth) - j -: 1];
                        end 
                        _offset <=0;
                        _readingMsgLen <= 1;
                        _readingMsg <= 0;
                        _msgSent++;
                        _waitMsgSending <= 1; 
                        _validOut <= 1;
                        i++;
                    end
                    else
                    begin
                        _remainingMsgWidth <= _currentMsgLengthBits - _remainingSampleWidth;             
                        for(j=0; j<_remainingSampleWidth; j++)
                        begin
                            _dataOut[( _currentMsgLengthBits - 1) -j -: 1] <= _dataIn[i][((_remainingSampleWidth - 1) -j) -: 1];
                        end
                        i++;  
                        _readingMsgLen <= 0;  
                        _spillMsg <= 1; 
                        _offset <= 0;
                    end // end of if(_remainingSampleWidth > _currentMsgLengthBits) else if & else if                
                end // end of else of if(_spillMsg) 
                
            end // end of if(_readingMsg)            
        end  // end of (_msgSent < _msgCount)
        
        else if (_msgSent >= _msgCount && _msgCount != 0)               // Reset all variables after one payload. This 
        begin 
            _msgSent <= 0;
            _remainingMsgWidth <= 0;
            _readingMsgLen <= 0;
            _readingMsg <= 0;
            _spillMsg <= 0; 
            _offset <= 0;
            _dataOut <=0; 
            _dataIn <= 0; 
            _currentMsgLength <= 0;
            _spillMsgLen <= 0;
            _remainingMsgLenWidth <= 0;   
            i <= 0;
            j <=0;
            k <=0;
        end // end of else if(_msgSent >= _msgCount && _msgCount != 0) 
        
    end // end of if(!_waitMsgSending)
    
    else //else of if(!_waitMsgSending)
    begin
       _waitMsgSending <= 0; 
    end
    
end// end of a long process

// Purpose: create out_bytemask
assign _currentMsgLengthBits = (_currentMsgLength << 3);
integer l; 
logic [MSG_LENGTH -1 : 0] _msgLengthForMask; 
assign _msgLengthForMask = _currentMsgLength;
always_ff @ (posedge clk)
begin             
    _bytemask <= 0;
    for(l=0; l<_msgLengthForMask; l++)
    begin       
        _bytemask[(OUTPUT_MASK_WIDTH -1) -l -: 1] <= 0;
        _bytemask[l +: 1] <= 1;
    end 
end

// Purpose: Send Output Data
always_ff @ (posedge clk)
begin    
    if (_validOut)
    begin
        _validOut <= 0;
        _dataOut <= 0;
    end
end

endmodule
