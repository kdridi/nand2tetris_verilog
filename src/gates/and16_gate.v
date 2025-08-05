// src/gates/and16_gate.v – Porte AND 16 bits construite avec des and_gate unitaires
`timescale 1ns / 1ps

module and16_gate (
    input  wire [15:0] a,
    input  wire [15:0] b,
    output wire [15:0] out
);
    // AND bit à bit: out[i] = a[i] AND b[i]
    and_gate and0  (.a(a[0]),  .b(b[0]),  .out(out[0]));
    and_gate and1  (.a(a[1]),  .b(b[1]),  .out(out[1]));
    and_gate and2  (.a(a[2]),  .b(b[2]),  .out(out[2]));
    and_gate and3  (.a(a[3]),  .b(b[3]),  .out(out[3]));
    and_gate and4  (.a(a[4]),  .b(b[4]),  .out(out[4]));
    and_gate and5  (.a(a[5]),  .b(b[5]),  .out(out[5]));
    and_gate and6  (.a(a[6]),  .b(b[6]),  .out(out[6]));
    and_gate and7  (.a(a[7]),  .b(b[7]),  .out(out[7]));
    and_gate and8  (.a(a[8]),  .b(b[8]),  .out(out[8]));
    and_gate and9  (.a(a[9]),  .b(b[9]),  .out(out[9]));
    and_gate and10 (.a(a[10]), .b(b[10]), .out(out[10]));
    and_gate and11 (.a(a[11]), .b(b[11]), .out(out[11]));
    and_gate and12 (.a(a[12]), .b(b[12]), .out(out[12]));
    and_gate and13 (.a(a[13]), .b(b[13]), .out(out[13]));
    and_gate and14 (.a(a[14]), .b(b[14]), .out(out[14]));
    and_gate and15 (.a(a[15]), .b(b[15]), .out(out[15]));
endmodule
