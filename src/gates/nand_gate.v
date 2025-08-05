// src/gates/nand_gate.v - NAND Gate (Primitive Building Block)
// Part of Nand2Tetris Verilog Implementation
// Function: NOT(a AND b) - Foundation of all digital logic

`timescale 1ns / 1ps

module nand_gate (
    input  wire a,   // First input
    input  wire b,   // Second input  
    output wire out  // NAND output: ~(a & b)
);

    // NAND Logic: Output is LOW only when both inputs are HIGH
    // Truth Table: 00->1, 01->1, 10->1, 11->0
    assign out = ~(a & b);

endmodule