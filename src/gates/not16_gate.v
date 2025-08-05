// src/gates/not16_gate.v - NOT16 Gate (16-bit Bitwise Inverter)
// Part of Nand2Tetris Verilog Implementation
// Function: 16-bit parallel inversion using 16 independent 1-bit NOT gates
// Architecture: Bitwise NOT - out[i] = ~in[i] for i = 0 to 15

`timescale 1ns / 1ps

module not16_gate (
    input  wire [15:0] in,  // 16-bit input word
    output wire [15:0] out  // 16-bit inverted output: ~in
);

    // 16-bit Parallel Inversion Implementation
    // Simple loop replaces 16 repetitive instantiations
    // Each bit: out[i] = NOT in[i]
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            not_gate not_inst (.in(in[i]), .out(out[i]));
        end
    endgenerate

    // All 16 NOT operations execute in parallel - minimum delay

endmodule