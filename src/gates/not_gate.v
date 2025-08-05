// src/gates/not_gate.v - NOT Gate (Inverter)
// Part of Nand2Tetris Verilog Implementation  
// Function: NOT(a) using only NAND gates - First derived logic gate
// Architecture: NOT(a) = NAND(a, a)

`timescale 1ns / 1ps

module not_gate (
    input  wire in,  // Input signal
    output wire out  // Inverted output: ~in
);

    // NOT Gate Implementation using NAND primitive
    // Logic: NOT(a) = NAND(a, a) - Connect both NAND inputs to same signal
    // Truth Table: 0->1, 1->0
    nand_gate nand_inverter (
        .a  (in),   // First NAND input connected to signal
        .b  (in),   // Second NAND input connected to same signal  
        .out(out)   // NAND output becomes NOT output
    );

endmodule