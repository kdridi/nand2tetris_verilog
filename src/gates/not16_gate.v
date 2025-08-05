// src/gates/not16_gate.v – Porte NOT 16 bits construite avec des not_gate unitaires
`timescale 1ns / 1ps

module not16_gate (
    input  wire [15:0] in,
    output wire [15:0] out
);
    // Inversion bit à bit: out[i] = NOT(in[i])
    not_gate inv0  (.in(in[0]),  .out(out[0]));
    not_gate inv1  (.in(in[1]),  .out(out[1]));
    not_gate inv2  (.in(in[2]),  .out(out[2]));
    not_gate inv3  (.in(in[3]),  .out(out[3]));
    not_gate inv4  (.in(in[4]),  .out(out[4]));
    not_gate inv5  (.in(in[5]),  .out(out[5]));
    not_gate inv6  (.in(in[6]),  .out(out[6]));
    not_gate inv7  (.in(in[7]),  .out(out[7]));
    not_gate inv8  (.in(in[8]),  .out(out[8]));
    not_gate inv9  (.in(in[9]),  .out(out[9]));
    not_gate inv10 (.in(in[10]), .out(out[10]));
    not_gate inv11 (.in(in[11]), .out(out[11]));
    not_gate inv12 (.in(in[12]), .out(out[12]));
    not_gate inv13 (.in(in[13]), .out(out[13]));
    not_gate inv14 (.in(in[14]), .out(out[14]));
    not_gate inv15 (.in(in[15]), .out(out[15]));
endmodule
