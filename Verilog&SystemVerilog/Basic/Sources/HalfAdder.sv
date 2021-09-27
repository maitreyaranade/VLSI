module half_adder (
    output sum,
    output carry,
    input  A, B
    );

    assign sum   = A ^ B;   // bitwise xor
    assign carry = A & B;   // bitwise AND

endmodule // half_adder