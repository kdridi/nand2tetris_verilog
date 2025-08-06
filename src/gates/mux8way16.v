// src/gates/mux8way16.v - Mux8Way16 Gate (8-way 16-bit Multiplexer)
// Part of Nand2Tetris Verilog Implementation
// Function: Mux8Way16(a[16], b[16], c[16], d[16], e[16], f[16], g[16], h[16], sel[3]) - 8-input 16-bit data selector
// Architecture: Uses 2 Mux4Way16 + 1 Mux16 gates in 2-level hierarchy for 8-way selection

`timescale 1ns / 1ps

module mux8way16 (
    input  wire [15:0] a,   // Input A - 16-bit data (selected when sel=000)
    input  wire [15:0] b,   // Input B - 16-bit data (selected when sel=001)
    input  wire [15:0] c,   // Input C - 16-bit data (selected when sel=010)
    input  wire [15:0] d,   // Input D - 16-bit data (selected when sel=011)
    input  wire [15:0] e,   // Input E - 16-bit data (selected when sel=100)
    input  wire [15:0] f,   // Input F - 16-bit data (selected when sel=101)
    input  wire [15:0] g,   // Input G - 16-bit data (selected when sel=110)
    input  wire [15:0] h,   // Input H - 16-bit data (selected when sel=111)
    input  wire [2:0] sel,  // 3-bit select signal (sel[2]=MSB, sel[1:0]=LSB pair)
    output wire [15:0] out  // 16-bit output - selected input based on sel
);

    // Internal signals for hierarchical selection
    wire [15:0] abcd;       // First level output (a, b, c, or d based on sel[1:0])
    wire [15:0] efgh;       // First level output (e, f, g, or h based on sel[1:0])

    // Stage 1a: First Level Mux4Way16 - Select among a, b, c, d based on sel[1:0]
    // Handles lower half of inputs (sel[2]=0 cases)
    mux4way16 first_level_abcd (
        .a  (a),            // Input A (16-bit)
        .b  (b),            // Input B (16-bit)
        .c  (c),            // Input C (16-bit)
        .d  (d),            // Input D (16-bit)
        .sel(sel[1:0]),     // 2-bit LSB selector
        .out(abcd)          // Output abcd = a, b, c, or d
    );

    // Stage 1b: First Level Mux4Way16 - Select among e, f, g, h based on sel[1:0]
    // Handles upper half of inputs (sel[2]=1 cases)
    mux4way16 first_level_efgh (
        .a  (e),            // Input E (16-bit)
        .b  (f),            // Input F (16-bit)
        .c  (g),            // Input G (16-bit)
        .d  (h),            // Input H (16-bit)
        .sel(sel[1:0]),     // 2-bit LSB selector
        .out(efgh)          // Output efgh = e, f, g, or h
    );

    // Stage 2: Second Level Mux16 - Select between abcd and efgh based on MSB (sel[2])
    // sel[2]=0: out = abcd (a, b, c, or d), sel[2]=1: out = efgh (e, f, g, or h)
    mux16 second_level (
        .a  (abcd),         // Input abcd from first level
        .b  (efgh),         // Input efgh from first level
        .sel(sel[2]),       // MSB selector
        .out(out)           // Final 16-bit output
    );

    // Truth Table Summary:
    // sel[2:0] = 000 -> out = a
    // sel[2:0] = 001 -> out = b
    // sel[2:0] = 010 -> out = c
    // sel[2:0] = 011 -> out = d
    // sel[2:0] = 100 -> out = e
    // sel[2:0] = 101 -> out = f
    // sel[2:0] = 110 -> out = g
    // sel[2:0] = 111 -> out = h

endmodule