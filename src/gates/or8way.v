// src/gates/or8way.v - Or8Way Gate (8-way OR)
// Part of Nand2Tetris Verilog Implementation
// Function: Or8Way(in[8]) - 8-input OR gate using cascaded OR gates
// Architecture: Uses 7 OR gates in sequential cascade for 8-input reduction

`timescale 1ns / 1ps

module or8way (
    input  wire [7:0] in,   // 8-bit input vector (in[7:0])
    output wire out         // Single output - OR of all inputs
);

    // Internal signals for cascaded OR operations
    wire tmp1v, tmp2v, tmp3v, tmp4v, tmp5v, tmp6v;

    // Stage 1: OR of first two inputs (in[0] OR in[1])
    or_gate stage1 (
        .a  (in[0]),        // Input bit 0
        .b  (in[1]),        // Input bit 1
        .out(tmp1v)         // Intermediate result 1
    );

    // Stage 2: Add in[2] to previous result
    or_gate stage2 (
        .a  (tmp1v),        // Previous result
        .b  (in[2]),        // Input bit 2
        .out(tmp2v)         // Intermediate result 2
    );

    // Stage 3: Add in[3] to previous result
    or_gate stage3 (
        .a  (tmp2v),        // Previous result
        .b  (in[3]),        // Input bit 3
        .out(tmp3v)         // Intermediate result 3
    );

    // Stage 4: Add in[4] to previous result
    or_gate stage4 (
        .a  (tmp3v),        // Previous result
        .b  (in[4]),        // Input bit 4
        .out(tmp4v)         // Intermediate result 4
    );

    // Stage 5: Add in[5] to previous result
    or_gate stage5 (
        .a  (tmp4v),        // Previous result
        .b  (in[5]),        // Input bit 5
        .out(tmp5v)         // Intermediate result 5
    );

    // Stage 6: Add in[6] to previous result
    or_gate stage6 (
        .a  (tmp5v),        // Previous result
        .b  (in[6]),        // Input bit 6
        .out(tmp6v)         // Intermediate result 6
    );

    // Stage 7: Add in[7] to previous result (final output)
    or_gate stage7 (
        .a  (tmp6v),        // Previous result
        .b  (in[7]),        // Input bit 7
        .out(out)           // Final output
    );

    // Logic: out = in[0] | in[1] | in[2] | in[3] | in[4] | in[5] | in[6] | in[7]
    // Result: out = 1 if any input bit is 1, otherwise out = 0

endmodule