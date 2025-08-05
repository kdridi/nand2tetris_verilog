// src/gates/xor_gate.v – Implémentation XOR à partir de NOT, AND et OR
`timescale 1ns / 1ps

module xor_gate (
    input  wire a,
    input  wire b,
    output wire out
);
    // NOT des deux entrées
    wire na, nb;
    not_gate inv_a (.in(a), .out(na));
    not_gate inv_b (.in(b), .out(nb));

    // Termes (A & ¬B) et (¬A & B)
    wire t1, t2;
    and_gate and1 (.a(a),  .b(nb), .out(t1));
    and_gate and2 (.a(na), .b(b),  .out(t2));

    // XOR = (A & ¬B) OR (¬A & B)
    or_gate or1 (.a(t1), .b(t2), .out(out));
endmodule
