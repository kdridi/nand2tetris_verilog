// src/gates/and_gate.v - AND Gate  
// Part of Nand2Tetris Verilog Implementation
// Function: AND(a, b) using NAND + NOT gates - De Morgan's Law application
// Architecture: AND(a, b) = NOT(NAND(a, b))

`timescale 1ns / 1ps

module and_gate (
    input  wire a,   // First input
    input  wire b,   // Second input
    output wire out  // AND output: a & b
);

    // Internal signal: NAND intermediate result
    wire nand_intermediate;

    // Stage 1: NAND Operation
    // Compute NAND(a, b) = ~(a & b)
    nand_gate nand_stage (
        .a  (a),
        .b  (b),
        .out(nand_intermediate)
    );

    // Stage 2: Inversion to get AND
    // Apply De Morgan's Law: AND(a, b) = NOT(NAND(a, b))
    // Truth Table: 00->0, 01->0, 10->0, 11->1
    not_gate invert_stage (
        .in (nand_intermediate),
        .out(out)
    );

endmodule