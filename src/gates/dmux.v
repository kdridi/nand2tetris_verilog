// src/gates/dmux.v – Démultiplexeur1→2 construit avec NOT et AND
`timescale 1ns / 1ps

module dmux (
    input  wire in,   // entrée unique
    input  wire sel,  // sélecteur (0 → a, 1 → b)
    output wire a,    // sortie 0
    output wire b     // sortie 1
);
    // ¬sel
    wire nsel;
    not_gate inv_sel (.in(sel), .out(nsel));

    // a = in & ¬sel
    and_gate and_a (.a(in), .b(nsel), .out(a));

    // b = in &  sel
    and_gate and_b (.a(in), .b(sel),  .out(b));
endmodule
