// src/arithmetic/alu.v – ALU 16 bits (Nand2Tetris) construite uniquement
// avec les modules déjà définis : not16_gate, and16_gate,
// add16, mux16, or_gate, etc.
`timescale 1ns / 1ps

module alu (
    input  wire [15:0] x, y,   // opérandes
    input  wire        zx, nx, // contrôle X
    input  wire        zy, ny, // contrôle Y
    input  wire        f,      // 1=ADD, 0=AND
    input  wire        no,     // inversion finale
    output wire [15:0] out,    // résultat
    output wire        zr,     // 1 si out==0
    output wire        ng      // 1 si out<0 (bit 15)
);
    // --------------------------------------------------
    // Étape 1 : mise à zéro éventuelle des entrées
    // --------------------------------------------------
    wire [15:0] x_z, y_z;
    mux16 mux_zx (.a(x), .b(16'h0000), .sel(zx), .out(x_z));
    mux16 mux_zy (.a(y), .b(16'h0000), .sel(zy), .out(y_z));

    // --------------------------------------------------
    // Étape 2 : inversion éventuelle des entrées
    // --------------------------------------------------
    wire [15:0] x_n, y_n, x_f, y_f;
    
    not16_gate not_x (.in(x_z), .out(x_n));
    not16_gate not_y (.in(y_z), .out(y_n));

    mux16 mux_nx (.a(x_z), .b(x_n), .sel(nx), .out(x_f));
    mux16 mux_ny (.a(y_z), .b(y_n), .sel(ny), .out(y_f));

    // --------------------------------------------------
    // Étape 3 : opération AND ou ADD selon f
    // --------------------------------------------------
    wire [15:0] and_result, add_result, alu_core;
    
    and16_gate and_op (.a(x_f), .b(y_f), .out(and_result));
    add16      add_op (.a(x_f), .b(y_f), .out(add_result));

    mux16 mux_f (.a(and_result), .b(add_result), .sel(f), .out(alu_core));

    // --------------------------------------------------
    // Étape 4 : inversion finale selon no
    // --------------------------------------------------
    wire [15:0] alu_inverted;
    
    not16_gate not_final (.in(alu_core), .out(alu_inverted));
    mux16 mux_no (.a(alu_core), .b(alu_inverted), .sel(no), .out(out));

    // --------------------------------------------------
    // Flags de sortie : zero (zr) et négatif (ng)
    // --------------------------------------------------
    // Flag zero : OR de tous les bits inversé
    wire [15:0] out_bits;
    assign out_bits = out;  // Pour clarté
    
    wire or_all;  // OR de tous les bits de out
    assign or_all = |out;  // Opérateur de réduction OR
    
    assign zr = ~or_all;   // zr = 1 si aucun bit n'est à 1
    assign ng = out[15];   // Flag négatif = bit de signe

endmodule