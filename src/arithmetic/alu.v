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
    mux16 mux_zx ( .a(x),            .b(16'h0000), .sel(zx), .out(x_z) );
    mux16 mux_zy ( .a(y),            .b(16'h0000), .sel(zy), .out(y_z) );

    // --------------------------------------------------
    // Étape 2 : possible inversion des entrées
    // --------------------------------------------------
    wire [15:0] x_n, y_n;
    not16_gate not_x ( .in(x_z), .out(x_n) );
    not16_gate not_y ( .in(y_z), .out(y_n) );

    wire [15:0] x_f, y_f;   // entrées finales de l’unité logique/arith.
    mux16 mux_nx ( .a(x_z), .b(x_n), .sel(nx), .out(x_f) );
    mux16 mux_ny ( .a(y_z), .b(y_n), .sel(ny), .out(y_f) );

    // --------------------------------------------------
    // Étape 3 : AND ou ADD selon f
    // --------------------------------------------------
    wire [15:0] and_xy, add_xy, alu_core;
    and16_gate and16xy ( .a(x_f), .b(y_f), .out(and_xy) );
    add16      add16xy ( .a(x_f), .b(y_f), .out(add_xy) );

    mux16 mux_f ( .a(and_xy), .b(add_xy), .sel(f), .out(alu_core) );

    // --------------------------------------------------
    // Étape 4 : inversion finale no
    // --------------------------------------------------
    wire [15:0] alu_core_not;
    not16_gate not_out ( .in(alu_core), .out(alu_core_not) );

    mux16 mux_no ( .a(alu_core), .b(alu_core_not), .sel(no), .out(out) );

    // --------------------------------------------------
    // Flags : zero (zr) et négatif (ng)
    // --------------------------------------------------
    assign zr = (out == 16'h0000); // 1 si résultat nul
    assign ng = out[15];           // bit de signe (complément à 2)

endmodule