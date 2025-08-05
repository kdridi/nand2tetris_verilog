// src/arithmetic/half_adder.v – Demi‑additionneur (HA) à partir de XOR et AND
`timescale 1ns / 1ps

module half_adder (
    input  wire a,
    input  wire b,
    output wire sum,    // somme
    output wire carry   // retenue
);
    // sum   = A ⊕ B
    xor_gate xor1 (
        .a  (a),
        .b  (b),
        .out(sum)
    );

    // carry = A ∧ B
    and_gate and1 (
        .a  (a),
        .b  (b),
        .out(carry)
    );
endmodule