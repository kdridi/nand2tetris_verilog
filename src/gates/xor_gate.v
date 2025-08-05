// src/gates/xor_gate.v - XOR Gate (Exclusive OR)
// Part of Nand2Tetris Verilog Implementation
// Function: XOR(a, b) using NOT, AND, OR gates - Sum of Products implementation  
// Architecture: XOR(a, b) = (a & ~b) | (~a & b) - "Different inputs" detector

`timescale 1ns / 1ps

module xor_gate (
    input  wire a,   // First input
    input  wire b,   // Second input
    output wire out  // XOR output: a ^ b (HIGH when inputs differ)
);

    // Internal signals: Inverted inputs
    wire not_a, not_b;
    
    // Internal signals: Product terms  
    wire term_a_not_b;  // a & ~b (a=1, b=0)
    wire term_not_a_b;  // ~a & b (a=0, b=1)

    // Stage 1: Input Inversion
    // Generate complements for product terms
    not_gate invert_a (
        .in (a),
        .out(not_a)     // ~a
    );
    
    not_gate invert_b (
        .in (b),
        .out(not_b)     // ~b  
    );

    // Stage 2: Product Term Generation
    // First term: a AND NOT(b) - TRUE when a=1, b=0
    and_gate and_a_not_b (
        .a  (a),
        .b  (not_b),
        .out(term_a_not_b)
    );
    
    // Second term: NOT(a) AND b - TRUE when a=0, b=1  
    and_gate and_not_a_b (
        .a  (not_a),
        .b  (b),
        .out(term_not_a_b)
    );

    // Stage 3: Sum of Products
    // Final OR: XOR is TRUE when exactly one input is HIGH
    // Truth Table: 00->0, 01->1, 10->1, 11->0
    or_gate sum_of_products (
        .a  (term_a_not_b),
        .b  (term_not_a_b), 
        .out(out)
    );

endmodule