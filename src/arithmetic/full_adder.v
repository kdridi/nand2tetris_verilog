// src/arithmetic/full_adder.v – Additionneur complet (FA) réalisé avec deux half‑adder + OR
`timescale 1ns / 1ps

module full_adder (
    input  wire a,
    input  wire b,
    input  wire carry_in,
    output wire sum,
    output wire carry_out
);
    // Étape 1: premier demi‑additionneur (a + b)
    wire sum1, carry1;
    half_adder ha1 (
        .a   (a),
        .b   (b),
        .sum (sum1),
        .carry(carry1)
    );

    // Étape 2: second demi‑additionneur (sum1 + carry_in)
    wire carry2;
    half_adder ha2 (
        .a   (sum1),
        .b   (carry_in),
        .sum (sum),
        .carry(carry2)
    );

    // Sortie carry = carry1 OR carry2
    or_gate or1 (
        .a  (carry1),
        .b  (carry2),
        .out(carry_out)
    );
endmodule