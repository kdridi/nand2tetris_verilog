// src/arithmetic/inc16.v - Inc16 Gate (16-bit Incrementer)
// Part of Nand2Tetris Verilog Implementation
// Function: Inc16(in[16]) - 16-bit incrementer (adds 1 to input)
// Architecture: Uses 16 HalfAdders in ripple-carry configuration with constant 1 input

`timescale 1ns / 1ps

module inc16 (
    input  wire [15:0] in,  // 16-bit input value
    output wire [15:0] out  // 16-bit output (input + 1)
);

    // Internal carry chain for ripple-carry propagation (17 bits: 0 to 16)
    wire [16:0] carry;
    
    // Initialize carry chain: carry[0] = 1 for increment operation
    assign carry[0] = 1'b1;

    // Generate 16 Half Adders using uniform generate loop
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : inc_stage
            // Each bit adds input with carry from previous stage
            // First stage (i=0) uses carry[0]=1, making it equivalent to adding 1
            half_adder bit_inc (
                .a   (in[i]),       // Input bit i
                .b   (carry[i]),    // Carry input (1 for i=0, propagated for i>0)
                .sum (out[i]),      // Output bit i
                .carry(carry[i+1])  // Carry to next bit
            );
        end
    endgenerate

    // Note: Final carry carry[16] is ignored - implements modulo 2^16 increment
    // Logic: carry[0]=1 initiates increment, then propagates through consecutive 1s
    // Examples: 
    // - 0000: carry stops at bit 0 → 0001
    // - 0111: carry propagates through bits 0,1,2 → 1000  
    // - FFFF: carry propagates through all bits → 0000 (overflow)

endmodule