// Binary adder subtractor using Full adders

module binary_adder_subtractor (
    output [3: 0] sum,
    output carry,
    output overflow,
    input [3: 0] A, B,
    input mode
    );

    reg [3:0] C;
    reg [3:0] S;

    full_adder full_adder_0_inst
    (
     .A(A[0]),
     .B(B[0] ^ mode),
     .C(mode),
     .sum(S[0]),
     .carry(C[0])
    );

    full_adder full_adder_1_inst
    (
     .A(A[1]),
     .B(B[1] ^ mode),
     .C(C[0]),
     .sum(S[1]),
     .carry(C[1])
    );

    full_adder full_adder_2_inst
    (
     .A(A[2]),
     .B(B[2] ^ mode),
     .C(C[1]),
     .sum(S[2]),
     .carry(C[2])
    );

    full_adder full_adder_3_inst
    (
     .A(A[3]),
     .B(B[3] ^ mode),
     .C(C[2]),
     .sum(S[3]),
     .carry(carry)
    );

    assign sum = S;
    assign overflow = carry ^ C[2] ;

endmodule // binary_adder_subtractor