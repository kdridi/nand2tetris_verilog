// src/arithmetic/add16.v – Additionneur 16 bits (ripple‑carry) basé sur des full_adder
`timescale 1ns / 1ps

module add16 (
    input  wire [15:0] a,
    input  wire [15:0] b,
    output wire [15:0] out
);
    // Retenues intermédiaires
    wire c1, c2, c3,  c4,  c5,  c6,  c7,  c8,
         c9, c10, c11, c12, c13, c14, c15, c16;

    // Bit 0 : retenue d’entrée = 0
    full_adder fa0  (.a(a[0]),  .b(b[0]),  .carry_in(1'b0), .sum(out[0]),  .carry_out(c1));
    full_adder fa1  (.a(a[1]),  .b(b[1]),  .carry_in(c1),   .sum(out[1]),  .carry_out(c2));
    full_adder fa2  (.a(a[2]),  .b(b[2]),  .carry_in(c2),   .sum(out[2]),  .carry_out(c3));
    full_adder fa3  (.a(a[3]),  .b(b[3]),  .carry_in(c3),   .sum(out[3]),  .carry_out(c4));
    full_adder fa4  (.a(a[4]),  .b(b[4]),  .carry_in(c4),   .sum(out[4]),  .carry_out(c5));
    full_adder fa5  (.a(a[5]),  .b(b[5]),  .carry_in(c5),   .sum(out[5]),  .carry_out(c6));
    full_adder fa6  (.a(a[6]),  .b(b[6]),  .carry_in(c6),   .sum(out[6]),  .carry_out(c7));
    full_adder fa7  (.a(a[7]),  .b(b[7]),  .carry_in(c7),   .sum(out[7]),  .carry_out(c8));
    full_adder fa8  (.a(a[8]),  .b(b[8]),  .carry_in(c8),   .sum(out[8]),  .carry_out(c9));
    full_adder fa9  (.a(a[9]),  .b(b[9]),  .carry_in(c9),   .sum(out[9]),  .carry_out(c10));
    full_adder fa10 (.a(a[10]), .b(b[10]), .carry_in(c10),  .sum(out[10]), .carry_out(c11));
    full_adder fa11 (.a(a[11]), .b(b[11]), .carry_in(c11),  .sum(out[11]), .carry_out(c12));
    full_adder fa12 (.a(a[12]), .b(b[12]), .carry_in(c12),  .sum(out[12]), .carry_out(c13));
    full_adder fa13 (.a(a[13]), .b(b[13]), .carry_in(c13),  .sum(out[13]), .carry_out(c14));
    full_adder fa14 (.a(a[14]), .b(b[14]), .carry_in(c14),  .sum(out[14]), .carry_out(c15));
    full_adder fa15 (.a(a[15]), .b(b[15]), .carry_in(c15),  .sum(out[15]), .carry_out(c16));
    // c16 est la retenue de débordement, optionnellement disponible si nécessaire
endmodule