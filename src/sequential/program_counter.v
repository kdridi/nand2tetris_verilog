// src/sequential/program_counter.v - 16-bit Program Counter with Control Signals
// Part of Nand2Tetris Verilog Implementation
// Function: Program counter with reset/load/increment - CPU instruction pointer
// Architecture: Inc16 + Priority MUX chain + Register with feedback loop

`timescale 1ns / 1ps

module program_counter (
    input  wire [15:0] in,      // Jump address input for load operation
    input  wire        load,    // Load enable (1=load address from in)
    input  wire        inc,     // Increment enable (1=increment current address)
    input  wire        reset,   // Reset enable (1=reset to address 0x0000)
    input  wire        clk,     // Clock signal (positive edge triggered)
    output wire [15:0] out      // Current program counter address output
);

    // Internal signals for control flow pipeline
    wire [15:0] current_pc;         // Current PC value (register output)
    wire [15:0] incremented_pc;     // Current PC + 1
    wire [15:0] after_increment;    // After increment decision
    wire [15:0] after_load;         // After load decision
    wire [15:0] next_pc;            // Final next PC value

    // Increment Logic: Generate PC + 1 for sequential execution
    inc16 pc_incrementer (
        .in (current_pc),           // Current PC value
        .out(incremented_pc)        // PC + 1
    );

    // Priority Control Chain: MUX cascade implementing operation hierarchy
    // Priority order (highest to lowest): reset > load > inc > hold
    
    // Stage 1: Increment Decision (lowest priority active operation)
    mux16 increment_selector (
        .a  (current_pc),           // Hold current PC
        .b  (incremented_pc),       // Use incremented PC
        .sel(inc),                  // Increment control signal
        .out(after_increment)       // Result: current or incremented PC
    );

    // Stage 2: Load Decision (medium priority)
    mux16 load_selector (
        .a  (after_increment),      // Previous stage result
        .b  (in),                   // Jump address input
        .sel(load),                 // Load control signal
        .out(after_load)            // Result: previous or loaded address
    );

    // Stage 3: Reset Decision (highest priority)
    mux16 reset_selector (
        .a  (after_load),           // Previous stage result
        .b  (16'h0000),            // Reset address (zero)
        .sel(reset),               // Reset control signal
        .out(next_pc)              // Final next PC value
    );

    // PC Storage: Register with feedback maintains program counter state
    register16 pc_register (
        .in (next_pc),              // Next PC value from MUX chain
        .load(1'b1),               // Always update on clock edge
        .clk(clk),                 // Clock signal
        .out(current_pc)           // Current PC (feeds back to incrementer)
    );

    // Output Assignment
    assign out = current_pc;

    // Operation Priority Logic:
    // if (reset)     PC <= 0x0000        (highest priority)
    // else if (load) PC <= in            (jump to address)
    // else if (inc)  PC <= PC + 1        (sequential execution)
    // else           PC <= PC            (hold current address)

endmodule