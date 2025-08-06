// src/arithmetic/full_adder.v - FullAdder Gate (3-bit to 2-bit Adder)
// Part of Nand2Tetris Verilog Implementation
// Function: FullAdder(a, b, c) - Computes sum of three 1-bit inputs with carry output
// Architecture: Uses 2 HalfAdders + 1 OR gate in cascaded configuration

`timescale 1ns / 1ps

module full_adder (
    input  wire a,      // First 1-bit input
    input  wire b,      // Second 1-bit input
    input  wire c,      // Third 1-bit input (carry from previous stage)
    output wire sum,    // Sum output (LSB of a + b + c)
    output wire carry   // Carry output (MSB of a + b + c)
);

    // Internal signals for cascaded half-adder stages
    wire s1, c1, c2;    // Intermediate sum and carry signals

    // Stage 1: First Half Adder - Add inputs a and b
    half_adder first_stage (
        .a   (a),           // First input bit
        .b   (b),           // Second input bit
        .sum (s1),          // Intermediate sum (a XOR b)
        .carry(c1)          // Intermediate carry (a AND b)
    );

    // Stage 2: Second Half Adder - Add intermediate sum with carry input c
    half_adder second_stage (
        .a   (s1),          // Intermediate sum from first stage
        .b   (c),           // Carry input from previous bit position
        .sum (sum),         // Final sum output
        .carry(c2)          // Second carry output
    );

    // Stage 3: Carry Combination - OR the two carry outputs
    or_gate carry_combine (
        .a  (c1),           // Carry from first half adder
        .b  (c2),           // Carry from second half adder
        .out(carry)         // Final carry output
    );

    // Logic Summary:
    // sum = a XOR b XOR c (parity of three inputs)
    // carry = (a AND b) OR (c AND (a XOR b)) (majority function)
    // Truth table: sum represents LSB, carry represents MSB of a+b+c

endmodule