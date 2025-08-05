// src/gates/or_gate.v – Implémentation OR à partir de NAND + NOT
`timescale 1ns / 1ps

module or_gate (
    input  wire a,
    input  wire b,
    output wire out
);
    // Inversions des entrées
    wire na, nb;
    not_gate inv_a (.in(a), .out(na));
    not_gate inv_b (.in(b), .out(nb));

    // OR(A,B) = NAND(NOT(A), NOT(B))
    nand_gate nand1 (
        .a  (na),
        .b  (nb),
        .out(out)
    );
endmodule
