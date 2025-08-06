// src/arithmetic/half_adder.v - HalfAdder Gate (2-bit to 2-bit Adder)
// Part of Nand2Tetris Verilog Implementation
// Function: HalfAdder(a, b) - Computes sum of two 1-bit inputs with carry output
// Architecture: Uses XOR for sum and AND for carry (basic binary addition)

`timescale 1ns / 1ps

module half_adder (
    input  wire a,      // First 1-bit input
    input  wire b,      // Second 1-bit input
    output wire sum,    // Sum output (LSB of a + b)
    output wire carry   // Carry output (MSB of a + b)
);

    // Sum computation: XOR operation (exclusive OR)
    // sum = a XOR b (1 if inputs are different, 0 if same)
    xor_gate sum_logic (
        .a  (a),            // First input bit
        .b  (b),            // Second input bit
        .out(sum)           // Sum = a ⊕ b
    );

    // Carry computation: AND operation
    // carry = a AND b (1 only when both inputs are 1)
    and_gate carry_logic (
        .a  (a),            // First input bit
        .b  (b),            // Second input bit
        .out(carry)         // Carry = a ∧ b
    );

    // Logic Summary:
    // For binary addition a + b:
    // - If both bits are 0: sum=0, carry=0 (0+0=0)
    // - If one bit is 1: sum=1, carry=0 (0+1=1 or 1+0=1)
    // - If both bits are 1: sum=0, carry=1 (1+1=10 in binary)
    // This implements the fundamental 2-bit binary addition

endmodule