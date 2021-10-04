module BinaryComparator #(
    parameter DATA_WIDTH = 2
) (
    input       clk,
    input       rst,
    input       start, 
    input  [DATA_WIDTH - 1 :0] A,
    input  [DATA_WIDTH - 1 :0] B,
    output AGB,
    output AEB,
    output ALB,
    output reg done
    );

    // State declaration
    localparam [1:0]
    idle     = 2'b00,
    compare  = 2'b01,
    result   = 2'b10;

    // Signal declaration
    reg [1:0] state, next_state;
    reg _AGB; 
    reg _AEB;
    reg _ALB;
    reg [DATA_WIDTH - 1 :0] _A;
    reg [DATA_WIDTH - 1 :0] _B;
    
    reg [$clog2(DATA_WIDTH) - 1 :0] _counter;
    reg [$clog2(DATA_WIDTH) - 1 :0] _counterNext;
    wire [DATA_WIDTH - 1 :0] X;  // Xi = Ai ^ Bi


    // Assignments
    assign X   = A ~^ B;   // bitwise XOR
    assign AGB = _AGB; 
    assign AEB = _AEB;
    assign ALB = _ALB;
    

    // counter logic
    always @(posedge clk, posedge rst)
    begin    
        if (rst)
        begin
            _AGB <= 0; 
            _AEB <= 0;
            _ALB <= 0;  
            _A <= 0;
            _B <= 0;    
            _counter <= 0;
        end       
        else
        begin
            _A <= A;
            _B <= B;  
            _counter <= _counterNext;          
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
        _counterNext    = _counter;
        next_state      = state;
        _AGB = 0; 
        _AEB = 0;
        _ALB = 0;   

        // FSM logic
        case(state)
            idle: 
            begin
                if(start) 
                begin                        
                    //_counter   = DATA_WIDTH - 1;        // load DATA_WIDTH - 1 for (DATA_WIDTH - 1)-bit down counter
                    _counterNext   = DATA_WIDTH - 1;        // load DATA_WIDTH - 1 for (DATA_WIDTH - 1)-bit down counter
                    next_state = compare;
                end
            end

            compare: 
            begin       
                if(X == {DATA_WIDTH{1'b1}})
                begin                        
                    next_state = result;            
                end   
                else
                begin
                    if(X[_counter])
                    begin 
                        next_state = compare;  
                        _counterNext = _counter - 1;    
                    end
                    else   
                        next_state = result;                     
                    //_counter = _counter - 1;
                end
            end

            result:
            begin                     
                if(X == {DATA_WIDTH{1'b1}})
                begin                
                    _AGB = 0; 
                    _AEB = 1;
                    _ALB = 0;              
                end            
                else
                begin
                    if(_A[_counter])
                    begin                    
                        _AGB = 1; 
                        _AEB = 0;
                        _ALB = 0;                          
                    end
                    else
                    begin                    
                        _AGB = 0; 
                        _AEB = 0;
                        _ALB = 1;                         
                    end                    
                end
                done       = 1;
                next_state = idle;            
            end

            default: 
                next_state = idle;

        endcase
    end

endmodule // BinaryComparator