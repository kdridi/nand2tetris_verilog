// src/sequential/dff.v - D-Flip-Flop (Basic Memory Element)
// Part of Nand2Tetris Verilog Implementation
// Function: D-Flip-Flop with positive edge clock - Foundation of sequential logic
// Architecture: Primitive sequential element (cannot be built from gates alone)

`timescale 1ns / 1ps

module dff (
    input  wire d,      // Data input to store
    input  wire clk,    // Clock signal (positive edge triggered)
    output reg  q       // Stored data output
);

    // Sequential Logic: Capture data on positive clock edge
    // This is the fundamental memory primitive - all sequential circuits build from this
    // On rising edge of clk: q captures the value of d
    // Between clock edges: q maintains its stored value
    always @(posedge clk) begin
        q <= d;
    end

    // Note: Unlike combinational gates, DFF requires behavioral Verilog
    // This is the primitive sequential element that enables state storage
    // Truth behavior: q(t+1) = d(t) where t is the clock edge time

endmodule