// src/arithmetic/alu.v - ALU (Arithmetic Logic Unit)
// Part of Nand2Tetris Verilog Implementation
// Function: ALU(x[16], y[16], zx, nx, zy, ny, f, no) - Complete 16-bit ALU with control bits
// Architecture: Sequential processing pipeline with input conditioning, operation, and output conditioning

`timescale 1ns / 1ps

module alu (
    input  wire [15:0] x,   // 16-bit input X
    input  wire [15:0] y,   // 16-bit input Y
    input  wire zx,         // Zero the x input (x = 0)
    input  wire nx,         // Negate the x input (x = !x)
    input  wire zy,         // Zero the y input (y = 0)
    input  wire ny,         // Negate the y input (y = !y)
    input  wire f,          // Function: 1=addition (x+y), 0=AND (x&y)
    input  wire no,         // Negate the output (out = !out)
    output wire [15:0] out, // 16-bit output
    output wire zr,         // Zero flag: 1 if out == 0, 0 otherwise
    output wire ng          // Negative flag: 1 if out < 0, 0 otherwise
);

    // Internal signals for processing pipeline
    wire [15:0] x0, x1, x2; // X processing stages
    wire [15:0] y0, y1, y2; // Y processing stages
    wire [15:0] andXY, addXY, xy, notXY; // Operation stages
    wire [7:0] lsw, msw;    // Output word splitting for zero detection
    wire olsw, omsw, notZR; // Zero flag computation

    // Stage 1: X Input Conditioning - Zero if zx=1
    mux16 x_zero_stage (
        .a  (x),            // Original x input
        .b  (16'b0),        // Zero constant
        .sel(zx),           // Zero control
        .out(x0)            // Conditioned x (step 1)
    );

    // Stage 2: X Input Conditioning - Negate if nx=1
    not16_gate x_not_stage (
        .in (x0),           // Input from zero stage
        .out(x1)            // Bitwise NOT of x0
    );

    mux16 x_negate_stage (
        .a  (x0),           // Non-negated x
        .b  (x1),           // Negated x
        .sel(nx),           // Negate control
        .out(x2)            // Final conditioned x
    );

    // Stage 3: Y Input Conditioning - Zero if zy=1
    mux16 y_zero_stage (
        .a  (y),            // Original y input
        .b  (16'b0),        // Zero constant
        .sel(zy),           // Zero control
        .out(y0)            // Conditioned y (step 1)
    );

    // Stage 4: Y Input Conditioning - Negate if ny=1
    not16_gate y_not_stage (
        .in (y0),           // Input from zero stage
        .out(y1)            // Bitwise NOT of y0
    );

    mux16 y_negate_stage (
        .a  (y0),           // Non-negated y
        .b  (y1),           // Negated y
        .sel(ny),           // Negate control
        .out(y2)            // Final conditioned y
    );

    // Stage 5: Function Computation - AND operation
    and16_gate and_operation (
        .a  (x2),           // Conditioned x
        .b  (y2),           // Conditioned y
        .out(andXY)         // x2 AND y2
    );

    // Stage 6: Function Computation - ADD operation
    add16 add_operation (
        .a  (x2),           // Conditioned x
        .b  (y2),           // Conditioned y
        .out(addXY)         // x2 + y2
    );

    // Stage 7: Function Selection - Choose AND or ADD
    mux16 function_select (
        .a  (andXY),        // AND result
        .b  (addXY),        // ADD result
        .sel(f),            // Function control
        .out(xy)            // Selected operation result
    );

    // Stage 8: Output Conditioning - Negate if no=1
    not16_gate output_not_stage (
        .in (xy),           // Function result
        .out(notXY)         // Bitwise NOT of result
    );

    mux16 output_negate_stage (
        .a  (xy),           // Non-negated result
        .b  (notXY),        // Negated result
        .sel(no),           // Output negate control
        .out(out)           // Final output
    );

    // Stage 9: Flag Generation - Extract output parts for zero detection
    assign lsw = out[7:0];   // Lower 8 bits
    assign msw = out[15:8];  // Upper 8 bits
    assign ng = out[15];     // Negative flag (MSB of output)

    // Stage 10: Zero Flag Computation - OR reduction of all bits
    or8way lsw_or (
        .in (lsw),          // Lower 8 bits
        .out(olsw)          // OR of lower bits
    );

    or8way msw_or (
        .in (msw),          // Upper 8 bits
        .out(omsw)          // OR of upper bits
    );

    or_gate final_or (
        .a  (olsw),         // Lower bits OR
        .b  (omsw),         // Upper bits OR
        .out(notZR)         // OR of all bits (inverse of zero)
    );

    not_gate zero_flag (
        .in (notZR),        // Inverse of zero flag
        .out(zr)            // Zero flag: 1 if all bits are 0
    );

    // ALU Operations Summary:
    // Input conditioning: zero and/or negate x and y based on control bits
    // Function: compute x+y (f=1) or x&y (f=0) on conditioned inputs  
    // Output conditioning: optionally negate the result
    // Flags: zr=1 if output is zero, ng=1 if output is negative (MSB=1)

endmodule