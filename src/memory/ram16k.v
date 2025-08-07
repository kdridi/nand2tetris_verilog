// src/memory/ram16k.v - 16K-Register RAM with 14-bit Addressing
// Part of Nand2Tetris Verilog Implementation
// Function: 16384 words × 16 bits memory - Flat implementation using arrays for performance
// Architecture: Direct array access (optimized for simulation speed)

`timescale 1ns / 1ps

module ram16k (
    input  wire [15:0] in,      // Data input to write
    input  wire [13:0] address, // 14-bit address (selects 1 of 16384 registers)
    input  wire        load,    // Write enable (1=write data to addressed register)
    input  wire        clk,     // Clock signal (positive edge triggered)
    output reg  [15:0] out      // Data output from addressed register
);

    // Memory array: 16384 registers × 16 bits each
    reg [15:0] memory [0:16383];
    
    // Initialize memory to zero
    integer i;
    initial begin
        for (i = 0; i < 16384; i = i + 1) begin
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