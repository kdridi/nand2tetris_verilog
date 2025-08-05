// src/gates/dmux.v - DMUX Gate (1-to-2 Demultiplexer)
// Part of Nand2Tetris Verilog Implementation
// Function: DMUX(in, sel) - Data distributor/splitter using basic logic gates
// Architecture: DMUX routes single input 'in' to output A or B based on selector

`timescale 1ns / 1ps

module dmux (
    input  wire in,  // Single data input (source signal)
    input  wire sel, // Select signal (0=route to A, 1=route to B)
    output wire a,   // Output A (active when sel=0)
    output wire b    // Output B (active when sel=1)
);

    // Internal signal: Inverted selector
    wire not_sel;           // Complement of select signal

    // Stage 1: Selector Inversion
    // Generate complement of select signal for output A control
    not_gate invert_selector (
        .in (sel),
        .out(not_sel)       // ~sel
    );

    // Stage 2: Data Distribution
    // Output A: Data routed when sel=0 (in & ~sel)
    // When sel=0: ~sel=1, so A gets 'in', B gets 0
    and_gate route_to_a (
        .a  (in),           // Source data
        .b  (not_sel),      // Enable when sel=0
        .out(a)             // Output A = in & ~sel
    );
    
    // Output B: Data routed when sel=1 (in & sel)  
    // When sel=1: sel=1, so B gets 'in', A gets 0
    and_gate route_to_b (
        .a  (in),           // Source data
        .b  (sel),          // Enable when sel=1
        .out(b)             // Output B = in & sel
    );

    // Note: Outputs are mutually exclusive - only one is active at a time
    // Truth Table: sel=0 -> a=in,b=0 | sel=1 -> a=0,b=in

endmodule