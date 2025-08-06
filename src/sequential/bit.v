// src/sequential/bit.v - 1-bit Register with Load Control
// Part of Nand2Tetris Verilog Implementation
// Function: 1-bit register with load enable - Controlled memory storage
// Architecture: Uses MUX (load control) + DFF (storage) in feedback configuration

`timescale 1ns / 1ps

module bit (
    input  wire in,     // Data input to store
    input  wire load,   // Load enable (1=load new data, 0=keep current data)
    input  wire clk,    // Clock signal (positive edge triggered)
    output wire out     // Current stored data output
);

    // Internal signals for feedback loop architecture
    wire stored_data;   // Current stored value from DFF
    wire next_data;     // Next data to store (mux output)

    // Data Selection: Choose between new input or current stored value
    // If load=1: select new input data (in)
    // If load=0: select current stored data (feedback loop)
    mux data_selector (
        .a  (stored_data),  // Current stored value (feedback)
        .b  (in),           // New input data to load
        .sel(load),         // Load control signal
        .out(next_data)     // Selected data for storage
    );

    // Storage Element: D-Flip-Flop captures data on positive clock edge
    // On clock edge: stored_data <= next_data
    // Between edges: stored_data maintains its value
    dff storage_element (
        .d  (next_data),    // Data input to store
        .clk(clk),          // Clock signal
        .q  (stored_data)   // Stored data output
    );

    // Output Assignment: Connect internal storage to module output
    assign out = stored_data;

    // Logic Summary:
    // - load=1, clk edge: out <= in (store new data)
    // - load=0, clk edge: out <= out (maintain current data)
    // This implements a 1-bit register with load enable functionality

endmodule