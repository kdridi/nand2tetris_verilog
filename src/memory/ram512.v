// src/memory/ram512.v - 512-Register RAM with 9-bit Addressing
// Part of Nand2Tetris Verilog Implementation
// Function: 512 words × 16 bits memory - Flat implementation using arrays for performance
// Architecture: Direct array access (optimized for simulation speed)

`timescale 1ns / 1ps

module ram512 (
    input  wire [15:0] in,      // Data input to write
    input  wire [8:0]  address, // 9-bit address (selects 1 of 512 registers)
    input  wire        load,    // Write enable (1=write data to addressed register)
    input  wire        clk,     // Clock signal (positive edge triggered)
    output reg  [15:0] out      // Data output from addressed register
);

    // Memory array: 512 registers × 16 bits each
    reg [15:0] memory [0:511];
    
    // Initialize memory to zero
    integer i;
    initial begin
        for (i = 0; i < 512; i = i + 1) begin
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