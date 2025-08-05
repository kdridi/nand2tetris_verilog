// src/gates/and_gate.v – Implémentation AND à partir de NAND + NOT
`timescale 1ns / 1ps

module and_gate (
    input  wire a,
    input  wire b,
    output wire out
);
    wire nand_out;

    // Étape 1 : NAND des deux entrées
    nand_gate nand1 (
        .a  (a),
        .b  (b),
        .out(nand_out)
    );

    // Étape 2 : inversion du résultat pour obtenir AND
    not_gate not1 (
        .in (nand_out),
        .out(out)
    );
endmodule
