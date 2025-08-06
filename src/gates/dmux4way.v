// src/gates/dmux4way.v - DMux4Way Gate (1-to-4 Demultiplexer)
// Part of Nand2Tetris Verilog Implementation
// Function: DMux4Way(in, sel[2]) - 4-way data distributor using hierarchical DMUX gates
// Architecture: Uses 3 DMUX gates in 2-level hierarchy for 4-output routing

`timescale 1ns / 1ps

module dmux4way (
    input  wire in,     // Single data input (source signal)
    input  wire [1:0] sel, // 2-bit select signal (sel[1]=MSB, sel[0]=LSB)
    output wire a,      // Output A (active when sel=00)
    output wire b,      // Output B (active when sel=01)
    output wire c,      // Output C (active when sel=10)
    output wire d       // Output D (active when sel=11)
);

    // Internal signals for hierarchical routing
    wire a1, b1;        // First level outputs (intermediate routing)

    // Stage 1: First Level Demux - Route based on MSB (sel[1])
    // sel[1]=0: route to a1 (covers outputs a,b)
    // sel[1]=1: route to b1 (covers outputs c,d)
    dmux first_level (
        .in (in),       // Source data input
        .sel(sel[1]),   // MSB selector (high bit)
        .a  (a1),       // Route to upper half (a,b)
        .b  (b1)        // Route to lower half (c,d)
    );

    // Stage 2a: Second Level Demux - Upper half routing (a1 -> a,b)
    // Routes a1 signal to final outputs a or b based on LSB (sel[0])
    dmux second_level_upper (
        .in (a1),       // Input from first level upper output
        .sel(sel[0]),   // LSB selector (low bit)
        .a  (a),        // Final output A (sel=00)
        .b  (b)         // Final output B (sel=01)
    );

    // Stage 2b: Second Level Demux - Lower half routing (b1 -> c,d)
    // Routes b1 signal to final outputs c or d based on LSB (sel[0])
    dmux second_level_lower (
        .in (b1),       // Input from first level lower output
        .sel(sel[0]),   // LSB selector (low bit)
        .a  (c),        // Final output C (sel=10)
        .b  (d)         // Final output D (sel=11)
    );

    // Truth Table Summary:
    // sel[1:0] = 00 -> a=in, b=0, c=0, d=0
    // sel[1:0] = 01 -> a=0, b=in, c=0, d=0
    // sel[1:0] = 10 -> a=0, b=0, c=in, d=0
    // sel[1:0] = 11 -> a=0, b=0, c=0, d=in

endmodule