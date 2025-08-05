// src/gates/or_gate.v - OR Gate
// Part of Nand2Tetris Verilog Implementation  
// Function: OR(a, b) using NAND + NOT gates - De Morgan's Law application
// Architecture: OR(a, b) = NAND(NOT(a), NOT(b))

`timescale 1ns / 1ps

module or_gate (
    input  wire a,   // First input
    input  wire b,   // Second input  
    output wire out  // OR output: a | b
);

    // Internal signals: Inverted inputs
    wire not_a, not_b;

    // Stage 1: Input Inversion  
    // Apply De Morgan's Law preparation: invert both inputs
    not_gate invert_a (
        .in (a),
        .out(not_a)     // ~a
    );
    
    not_gate invert_b (
        .in (b), 
        .out(not_b)     // ~b
    );

    // Stage 2: NAND of Inverted Inputs
    // Complete De Morgan's Law: OR(a, b) = NAND(NOT(a), NOT(b))
    // Truth Table: 00->0, 01->1, 10->1, 11->1
    nand_gate nand_final (
        .a  (not_a),    // ~a input
        .b  (not_b),    // ~b input
        .out(out)       // Final OR result
    );

endmodule