module binary_adder_8bit (
    output [7: 0] sum,
    output C_out,
    input [7: 0] A, B,
    input C_in
    );
    
    assign {C_out, sum} = A + B + C_in;
endmodule // binary_adder_8bit