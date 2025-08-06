// src/gates/mux4way16.v - Mux4Way16 Gate (4-way 16-bit Multiplexer)
// Part of Nand2Tetris Verilog Implementation
// Function: Mux4Way16(a[16], b[16], c[16], d[16], sel[2]) - 4-input 16-bit data selector
// Architecture: Uses 3 Mux16 gates in 2-level hierarchy for 4-way selection

`timescale 1ns / 1ps

module mux4way16 (
    input  wire [15:0] a,   // Input A - 16-bit data (selected when sel=00)
    input  wire [15:0] b,   // Input B - 16-bit data (selected when sel=01)
    input  wire [15:0] c,   // Input C - 16-bit data (selected when sel=10)
    input  wire [15:0] d,   // Input D - 16-bit data (selected when sel=11)
    input  wire [1:0] sel,  // 2-bit select signal (sel[1]=MSB, sel[0]=LSB)
    output wire [15:0] out  // 16-bit output - selected input based on sel
);

    // Internal signals for hierarchical selection
    wire [15:0] ab;         // First level output (a or b based on sel[0])
    wire [15:0] cd;         // First level output (c or d based on sel[0])

    // Stage 1a: First Level Mux - Select between a and b based on LSB (sel[0])
    // sel[0]=0: ab = a, sel[0]=1: ab = b
    mux16 first_level_ab (
        .a  (a),            // Input A (16-bit)
        .b  (b),            // Input B (16-bit)
        .sel(sel[0]),       // LSB selector
        .out(ab)            // Output ab = a or b
    );

    // Stage 1b: First Level Mux - Select between c and d based on LSB (sel[0])
    // sel[0]=0: cd = c, sel[0]=1: cd = d
    mux16 first_level_cd (
        .a  (c),            // Input C (16-bit)
        .b  (d),            // Input D (16-bit)
        .sel(sel[0]),       // LSB selector
        .out(cd)            // Output cd = c or d
    );

    // Stage 2: Second Level Mux - Select between ab and cd based on MSB (sel[1])
    // sel[1]=0: out = ab (a or b), sel[1]=1: out = cd (c or d)
    mux16 second_level (
        .a  (ab),           // Input ab from first level
        .b  (cd),           // Input cd from first level
        .sel(sel[1]),       // MSB selector
        .out(out)           // Final 16-bit output
    );

    // Truth Table Summary:
    // sel[1:0] = 00 -> out = a
    // sel[1:0] = 01 -> out = b
    // sel[1:0] = 10 -> out = c
    // sel[1:0] = 11 -> out = d

endmodule