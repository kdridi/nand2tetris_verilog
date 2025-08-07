// src/memory/ram4k.v - 4K-Register RAM with 12-bit Addressing
// Part of Nand2Tetris Verilog Implementation
// Function: 4096 words × 16 bits memory - Flat implementation using arrays for performance
// Architecture: Direct array access (optimized for simulation speed)

`timescale 1ns / 1ps

module ram4k (
    input  wire [15:0] in,      // Data input to write
    input  wire [11:0] address, // 12-bit address (selects 1 of 4096 registers)
    input  wire        load,    // Write enable (1=write data to addressed register)
    input  wire        clk,     // Clock signal (positive edge triggered)
    output reg  [15:0] out      // Data output from addressed register
);

    // Memory array: 4096 registers × 16 bits each
    reg [15:0] memory [0:4095];
    
    // Initialize memory to zero
    integer i;
    initial begin
        for (i = 0; i < 4096; i = i + 1) begin
            memory[i] = 16'h0000;
        end
    end

    // Write operation: On clock edge, write input data to addressed register if load=1
    always @(posedge clk) begin
        if (load) begin
            memory[address] <= in;
        end
    end

    // Read operation: Continuous assignment, output data from addressed register
    always @(*) begin
        out = memory[address];
    end

endmodule