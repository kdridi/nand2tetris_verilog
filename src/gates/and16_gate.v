// src/gates/and16_gate.v - AND16 Gate (16-bit Bitwise AND)
// Part of Nand2Tetris Verilog Implementation
// Function: 16-bit parallel AND operation using 16 independent 1-bit AND gates
// Architecture: Bitwise AND - out[i] = a[i] & b[i] for i = 0 to 15

`timescale 1ns / 1ps

module and16_gate (
    input  wire [15:0] a,   // 16-bit input A
    input  wire [15:0] b,   // 16-bit input B  
    output wire [15:0] out  // 16-bit AND result: a & b
);

    // 16-bit Parallel AND Implementation
    // Simple loop replaces 16 repetitive instantiations
    // Each bit: out[i] = a[i] AND b[i]
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            and_gate and_inst (.a(a[i]), .b(b[i]), .out(out[i]));
        end
    endgenerate

    // All 16 AND operations execute in parallel - no propagation delay

endmodule