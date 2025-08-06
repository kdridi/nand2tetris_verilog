// src/sequential/register16.v - 16-bit Register with Load Control
// Part of Nand2Tetris Verilog Implementation
// Function: 16-bit register with load enable - Word-sized memory storage
// Architecture: Uses 16 independent 1-bit registers (bit modules) in parallel

`timescale 1ns / 1ps

module register16 (
    input  wire [15:0] in,      // 16-bit data input to store
    input  wire        load,    // Load enable (1=load new data, 0=keep current data)
    input  wire        clk,     // Clock signal (positive edge triggered)
    output wire [15:0] out      // Current 16-bit stored data output
);

    // Parallel Architecture: 16 independent 1-bit registers
    // Each bit[i] operates independently with same load and clock signals
    // This creates a 16-bit word register from 1-bit building blocks
    
    genvar bit_index;
    generate
        for (bit_index = 0; bit_index < 16; bit_index = bit_index + 1) begin : bit_array
            // Each bit register: stores in[i] when load=1, maintains value when load=0
            bit bit_register (
                .in (in[bit_index]),    // Input bit i
                .load(load),            // Shared load control
                .clk(clk),              // Shared clock signal
                .out(out[bit_index])    // Output bit i
            );
        end
    endgenerate

    // Logic Summary:
    // - load=1, clk edge: out[15:0] <= in[15:0] (store new 16-bit word)
    // - load=0, clk edge: out[15:0] <= out[15:0] (maintain current 16-bit word)
    // This implements a complete 16-bit register with load enable functionality

endmodule