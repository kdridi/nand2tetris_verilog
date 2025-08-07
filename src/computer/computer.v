// src/computer/computer.v - Complete Nand2Tetris Computer System
// Part of Nand2Tetris Verilog Implementation
// Function: Complete computer system (CPU + ROM + RAM) that executes Hack assembly programs
// Architecture: Harvard architecture with separate instruction ROM and data RAM

`timescale 1ns / 1ps

module computer (
    input  wire        clk,     // Clock signal
    input  wire        reset,   // Reset signal (synchronous)
    output wire [15:0] pc_out   // Program counter output (for debugging)
);

    // Internal CPU-memory interface signals
    wire [15:0] instruction;    // Current instruction from ROM
    wire [15:0] inM, outM;      // Data memory interface
    wire [14:0] addressM;       // Memory address from CPU
    wire        writeM;         // Memory write enable
    wire [15:0] pc;             // Program counter

    // Instruction Memory (ROM): 32K × 16-bit program storage
    // Loads program from "prog.hex" file at simulation startup
    reg [15:0] rom [0:32767];

    initial begin
        $readmemh("prog.hex", rom);
    end

    assign instruction = rom[pc];

    // Data Memory (RAM64): 64 × 16-bit data storage
    // Uses only lower 6 bits of addressM for 64-word addressing
    ram64 data_memory (
        .in     (outM),
        .address(addressM[5:0]),
        .load   (writeM),
        .clk    (clk),
        .out    (inM)
    );

    // Central Processing Unit
    cpu processor (
        .clk        (clk),
        .reset      (reset),
        .inM        (inM),
        .instruction(instruction),
        .outM       (outM),
        .addressM   (addressM),
        .writeM     (writeM),
        .pc         (pc)
    );

    assign pc_out = pc;

endmodule