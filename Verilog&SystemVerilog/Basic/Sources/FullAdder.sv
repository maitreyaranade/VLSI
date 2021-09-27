module full_adder (
    output sum,
    output carry,
    input  A, B, C
    );

    assign sum   = C ^ (A ^ B);
    assign carry = (A|B) & (B|C) & (C|A);

endmodule // full_adder


// Binary adder using Full adders
// Ripple carry adder


module full_adder_HA (
    output sum,
    output carry,
    input  A, B, C
    );

    reg _sum1;
    reg _carry1, _carry2;

    half_adder half_adder_0_inst
    (
     .A(A),
     .B(B),
     .sum(_sum1),
     .carry(_carry1)
    );

    half_adder half_adder_1_inst
    (
     .A(_sum1),
     .B(C),
     .sum(sum),
     .carry(_carry2)
    );

    assign carry = _carry1 | _carry2;

endmodule // full_adder_HA