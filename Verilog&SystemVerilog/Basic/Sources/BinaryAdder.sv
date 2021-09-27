module binary_adder (
    output [3: 0] sum,
    output C_out,
    input [3: 0] A, B,
    input C_in
    );
    assign {C_out, sum} = A + B + C_in;
endmodule // binary_adder

// Binary adder using Full adders
// Ripple carry adder

module binary_adder_FA (
    output [3: 0] sum,
    output C_out,
    input [3: 0] A, B,
    input C_in
    );

    reg [3:0] C;
    reg [3:0] S;

    full_adder full_adder_0_inst
    (
     .A(A[0]),
     .B(B[0]),
     .C(C_in),
     .sum(S[0]),
     .carry(C[0])
    );

    full_adder full_adder_1_inst
    (
     .A(A[1]),
     .B(B[1]),
     .C(C[0]),
     .sum(S[1]),
     .carry(C[1])
    );

    full_adder full_adder_2_inst
    (
     .A(A[2]),
     .B(B[2]),
     .C(C[1]),
     .sum(S[2]),
     .carry(C[2])
    );

    full_adder full_adder_3_inst
    (
     .A(A[3]),
     .B(B[3]),
     .C(C[2]),
     .sum(S[3]),
     .carry(C_out)
    );

    assign sum = S;

endmodule // binary_adder_FA
