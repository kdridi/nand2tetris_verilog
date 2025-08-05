// src/gates/nand_gate.v – Implémentation minimale pour le cycle 1
`timescale 1ns / 1ps

module nand_gate (
    input  wire a,
    input  wire b,
    output wire out
);
    // Porte NAND : la sortie est l’inverse de ET(a, b)
    assign out = ~(a & b);
endmodule
