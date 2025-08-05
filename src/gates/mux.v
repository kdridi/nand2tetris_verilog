// src/gates/mux.v - MUX Gate (2-to-1 Multiplexer)
// Part of Nand2Tetris Verilog Implementation
// Function: MUX(a, b, sel) - Data selector/router using basic logic gates
// Architecture: MUX(a, b, sel) = (a & ~sel) | (b & sel)

`timescale 1ns / 1ps

module mux (
    input  wire a,   // Data input 0 (selected when sel=0)
    input  wire b,   // Data input 1 (selected when sel=1)  
    input  wire sel, // Select signal (0=choose a, 1=choose b)
    output wire out  // Selected output
);

    // Internal signals: Control paths
    wire not_sel;           // Inverted selector
    wire path_a;            // Path A: a & ~sel  
    wire path_b;            // Path B: b & sel

    // Stage 1: Selector Inversion
    // Generate complement of select signal for path A
    not_gate invert_selector (
        .in (sel),
        .out(not_sel)       // ~sel
    );

    // Stage 2: Data Path Generation  
    // Path A: Data 'a' gated by ~sel (active when sel=0)
    and_gate gate_path_a (
        .a  (a),            // Data input A
        .b  (not_sel),      // Enable when sel=0
        .out(path_a)        // a & ~sel
    );
    
    // Path B: Data 'b' gated by sel (active when sel=1)
    and_gate gate_path_b (
        .a  (b),            // Data input B  
        .b  (sel),          // Enable when sel=1
        .out(path_b)        // b & sel
    );

    // Stage 3: Path Selection
    // OR the two mutually exclusive paths
    // Truth Table: sel=0 -> out=a, sel=1 -> out=b
    or_gate select_output (
        .a  (path_a),       // Path A result
        .b  (path_b),       // Path B result
        .out(out)           // Final multiplexed output
    );

endmodule