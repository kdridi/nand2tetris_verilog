// src/gates/or16_gate.v - OR16 Gate (16-bit Bitwise OR)
// Part of Nand2Tetris Verilog Implementation
// Function: 16-bit parallel OR operation using 16 independent 1-bit OR gates
// Architecture: Bitwise OR - out[i] = a[i] | b[i] for i = 0 to 15

`timescale 1ns / 1ps

module or16_gate (
    input  wire [15:0] a,   // 16-bit input A
    input  wire [15:0] b,   // 16-bit input B
    output wire [15:0] out  // 16-bit OR result: a | b
);

    // 16-bit Parallel OR Implementation
    // Simple loop replaces 16 repetitive instantiations
    // Each bit: out[i] = a[i] OR b[i]
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            or_gate or_inst (.a(a[i]), .b(b[i]), .out(out[i]));
        end
    endgenerate

    // All 16 OR operations execute in parallel - single gate delay

endmodule