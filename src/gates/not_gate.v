// src/gates/not_gate.v – Implémentation NOT à partir d’une seule porte NAND
`timescale 1ns / 1ps

module not_gate (
    input  wire in,
    output wire out
);
    // NOT(A) ≡ NAND(A, A)
    nand_gate nand1 (
        .a  (in),
        .b  (in),
        .out(out)
    );
endmodule
