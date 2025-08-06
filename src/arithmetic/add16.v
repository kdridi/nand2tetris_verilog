// src/arithmetic/add16.v - Add16 Gate (16-bit Adder)
// Part of Nand2Tetris Verilog Implementation
// Function: Add16(a[16], b[16]) - 16-bit binary addition with carry propagation
// Architecture: Uses 1 HalfAdder + 15 FullAdders in ripple-carry configuration

`timescale 1ns / 1ps

module add16 (
    input  wire [15:0] a,   // 16-bit input A
    input  wire [15:0] b,   // 16-bit input B
    output wire [15:0] out  // 16-bit sum output (MSB carry ignored)
);

    // Internal carry chain for ripple-carry propagation (17 bits: 0 to 16)
    wire [16:0] carry;
    
    // Initialize carry chain: no carry input for LSB
    assign carry[0] = 1'b0;

    // Generate 16 Full Adders using generate loop
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : adder_stage
            // Each bit uses a Full Adder (carry[0]=0 makes first stage equivalent to Half Adder)
            full_adder bit_adder (
                .a    (a[i]),        // Bit i of input A
                .b    (b[i]),        // Bit i of input B
                .c    (carry[i]),    // Carry input from previous bit
                .sum  (out[i]),      // Bit i of sum output
                .carry(carry[i+1])  // Carry output to next bit
            );
        end
    endgenerate

    // Note: Final carry carry[16] is ignored - only 16-bit result is output
    // This implements modulo 2^16 arithmetic for 16-bit word size
    // First stage (i=0) has carry[0]=0, making it equivalent to a Half Adder

endmodule