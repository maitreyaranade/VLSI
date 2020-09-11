//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Maitreya Ranade
// 
// Create Date: 20.05.2020 12:14:02
// Design Name: 
// Module Name: alu
// Project Name: ALU
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
//  ALU Arithmetic and Logic Operations
// | Operator |   ALU Operation
// |   0000   |   Result = Input1 +     Input2;
// |   0001   |   Result = Input1 -     Input2;
// |   0010   |   Result = Input1 *     Input2;
// |   0011   |   Result = Input1 /     Input2;
// |   0100   |   Result = Input1 <<    1;
// |   0101   |   Result = Input1 >>    1;
// |   0110   |   Result = Input1 rotate left by 1;
// |   0111   |   Result = Input1 rotate right by 1;
// |   1000   |   Result = Input1 and   Input2;
// |   1001   |   Result = Input1 or    Input2;
// |   1010   |   Result = Input1 xor   Input2;
// |   1011   |   Result = Input1 nor   Input2;
// |   1100   |   Result = Input1 nand  Input2;
// |   1101   |   Result = Input1 xnor  Input2;
// |   1110   |   Result = 1 if Input1 > Input2 else 0;
// |   1111   |   Result = 1 if Input1 = Input2 else 0;
// 
//
//////////////////////////////////////////////////////////////////////////////////



module alu #(
    parameter DATA_WIDTH = 8 
    ) (
           input  [ DATA_WIDTH -1 :0] Input1,Input2,          // ALU 8-bit Inputs                 
           input  [3:0] Operator,                             // Operator
           output [ DATA_WIDTH -1 :0] Result,                 // ALU 8-bit Output
           output Carry                                       // Carry Flag
    );
    logic [ DATA_WIDTH -1 :0] _result;
    logic [ DATA_WIDTH :0] _addWithCarry;
    assign Result = _result;                                  // ALU out
    assign _addWithCarry = {1'b0,Input1} + {1'b0,Input2};
    assign Carry = _addWithCarry[ DATA_WIDTH ];                          // Carry flag
    always @(*)
    begin
        case(Operator)
        4'b0000:                                              // Addition
           _result <= Input1 + Input2 ; 
        4'b0001:                                              // Subtraction
           _result <= Input1 - Input2 ;
        4'b0010:                                              // Multiplication
           _result <= Input1 * Input2;
        4'b0011:                                              // Division
           _result <= Input1/Input2;
        4'b0100:                                              // Logical shift left
           _result <= Input1<<1;
        4'b0101:                                              // Logical shift right
           _result <= Input1>>1;
        4'b0110:                                              // Rotate left
           _result <= {Input1[6:0],Input1[7]};
        4'b0111:                                              // Rotate right
           _result <= {Input1[0],Input1[ DATA_WIDTH -1 :1]};
        4'b1000:                                              //  Logical and 
           _result <= Input1 & Input2;
        4'b1001:                                              //  Logical or
           _result <= Input1 | Input2;
        4'b1010:                                              //  Logical xor 
           _result <= Input1 ^ Input2;
        4'b1011:                                              //  Logical nor
           _result <= ~(Input1 | Input2);
        4'b1100:                                              // Logical nand 
           _result <= ~(Input1 & Input2);
        4'b1101:                                              // Logical xnor
           _result <= ~(Input1 ^ Input2);
        4'b1110:                                              // Greater comparison
           _result <= (Input1>Input2)?  {{DATA_WIDTH}{1'b1}} : {{DATA_WIDTH}{1'b0}};
        4'b1111:                                              // Equal comparison   
           _result <= (Input1==Input2)? {{DATA_WIDTH}{1'b1}} : {{DATA_WIDTH}{1'b0}};
        default: 
           _result <= Input1 + Input2 ; 
        endcase
    end

endmodule