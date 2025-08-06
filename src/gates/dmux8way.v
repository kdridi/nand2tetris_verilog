// src/gates/dmux8way.v - DMux8Way Gate (1-to-8 Demultiplexer)
// Part of Nand2Tetris Verilog Implementation
// Function: DMux8Way(in, sel[3]) - 8-way data distributor using hierarchical DMUX gates
// Architecture: Uses 1 DMUX + 2 DMux4Way gates in 2-level hierarchy for 8-output routing

`timescale 1ns / 1ps

module dmux8way (
    input  wire in,        // Single data input (source signal)
    input  wire [2:0] sel, // 3-bit select signal (sel[2]=MSB, sel[1:0]=LSB pair)
    output wire a,         // Output A (active when sel=000)
    output wire b,         // Output B (active when sel=001)
    output wire c,         // Output C (active when sel=010)
    output wire d,         // Output D (active when sel=011)
    output wire e,         // Output E (active when sel=100)
    output wire f,         // Output F (active when sel=101)
    output wire g,         // Output G (active when sel=110)
    output wire h          // Output H (active when sel=111)
);

    // Internal signals for hierarchical routing
    wire selA, selB;       // First level outputs (intermediate routing)

    // Stage 1: First Level Demux - Route based on MSB (sel[2])
    // sel[2]=0: route to selA (covers outputs a,b,c,d)
    // sel[2]=1: route to selB (covers outputs e,f,g,h)
    dmux first_level (
        .in (in),          // Source data input
        .sel(sel[2]),      // MSB selector (high bit)
        .a  (selA),        // Route to upper half (a,b,c,d)
        .b  (selB)         // Route to lower half (e,f,g,h)
    );

    // Stage 2a: Second Level DMux4Way - Upper half routing (selA -> a,b,c,d)
    // Routes selA signal to final outputs a,b,c,d based on sel[1:0]
    dmux4way second_level_upper (
        .in (selA),        // Input from first level upper output
        .sel(sel[1:0]),    // 2-bit LSB selector
        .a  (a),           // Final output A (sel=000)
        .b  (b),           // Final output B (sel=001)
        .c  (c),           // Final output C (sel=010)
        .d  (d)            // Final output D (sel=011)
    );

    // Stage 2b: Second Level DMux4Way - Lower half routing (selB -> e,f,g,h)
    // Routes selB signal to final outputs e,f,g,h based on sel[1:0]
    dmux4way second_level_lower (
        .in (selB),        // Input from first level lower output
        .sel(sel[1:0]),    // 2-bit LSB selector
        .a  (e),           // Final output E (sel=100)
        .b  (f),           // Final output F (sel=101)
        .c  (g),           // Final output G (sel=110)
        .d  (h)            // Final output H (sel=111)
    );

    // Truth Table Summary:
    // sel[2:0] = 000 -> a=in, others=0
    // sel[2:0] = 001 -> b=in, others=0
    // sel[2:0] = 010 -> c=in, others=0
    // sel[2:0] = 011 -> d=in, others=0
    // sel[2:0] = 100 -> e=in, others=0
    // sel[2:0] = 101 -> f=in, others=0
    // sel[2:0] = 110 -> g=in, others=0
    // sel[2:0] = 111 -> h=in, others=0

endmodule