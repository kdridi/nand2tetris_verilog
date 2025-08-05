// src/gates/mux.v – Multiplexeur 2→1 construit avec NOT, AND et OR
`timescale 1ns / 1ps

module mux (
    input  wire a,     // entrée 0
    input  wire b,     // entrée 1
    input  wire sel,   // sélecteur (0 → a, 1 → b)
    output wire out    // sortie
);
    // ¬sel
    wire nsel;
    not_gate inv_sel (.in(sel), .out(nsel));

    // a & ¬sel
    wire a_path;
    and_gate and_a (.a(a), .b(nsel), .out(a_path));

    // b & sel
    wire b_path;
    and_gate and_b (.a(b), .b(sel), .out(b_path));

    // (a & ¬sel) | (b & sel)
    or_gate  or_out (.a(a_path), .b(b_path), .out(out));
endmodule
