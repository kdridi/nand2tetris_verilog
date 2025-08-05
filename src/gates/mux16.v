// src/gates/mux16.v – Multiplexeur 16 bits (2 → 1) composé de mux unitaires
`timescale 1ns / 1ps

module mux16 (
    input  wire [15:0] a,   // entrée 0
    input  wire [15:0] b,   // entrée 1
    input  wire        sel, // sélecteur commun
    output wire [15:0] out  // sortie
);
    // Sélection bit à bit : out[i] = sel ? b[i] : a[i]
    mux mux0  (.a(a[0]),  .b(b[0]),  .sel(sel), .out(out[0]));
    mux mux1  (.a(a[1]),  .b(b[1]),  .sel(sel), .out(out[1]));
    mux mux2  (.a(a[2]),  .b(b[2]),  .sel(sel), .out(out[2]));
    mux mux3  (.a(a[3]),  .b(b[3]),  .sel(sel), .out(out[3]));
    mux mux4  (.a(a[4]),  .b(b[4]),  .sel(sel), .out(out[4]));
    mux mux5  (.a(a[5]),  .b(b[5]),  .sel(sel), .out(out[5]));
    mux mux6  (.a(a[6]),  .b(b[6]),  .sel(sel), .out(out[6]));
    mux mux7  (.a(a[7]),  .b(b[7]),  .sel(sel), .out(out[7]));
    mux mux8  (.a(a[8]),  .b(b[8]),  .sel(sel), .out(out[8]));
    mux mux9  (.a(a[9]),  .b(b[9]),  .sel(sel), .out(out[9]));
    mux mux10 (.a(a[10]), .b(b[10]), .sel(sel), .out(out[10]));
    mux mux11 (.a(a[11]), .b(b[11]), .sel(sel), .out(out[11]));
    mux mux12 (.a(a[12]), .b(b[12]), .sel(sel), .out(out[12]));
    mux mux13 (.a(a[13]), .b(b[13]), .sel(sel), .out(out[13]));
    mux mux14 (.a(a[14]), .b(b[14]), .sel(sel), .out(out[14]));
    mux mux15 (.a(a[15]), .b(b[15]), .sel(sel), .out(out[15]));
endmodule