// src/memory/ram8.v - 8-Register RAM with 3-bit Addressing
// Part of Nand2Tetris Verilog Implementation
// Function: 8 words × 16 bits memory - Basic addressable storage
// Architecture: DMux8Way + 8 × Register16 + Mux8Way16

`timescale 1ns / 1ps

module ram8 (
    input  wire [15:0] in,      // Data input to write
    input  wire [2:0]  address, // 3-bit address (selects 1 of 8 registers)
    input  wire        load,    // Write enable (1=write data to addressed register)
    input  wire        clk,     // Clock signal (positive edge triggered)
    output wire [15:0] out      // Data output from addressed register
);

    // Internal signals for load control and register outputs
    wire load_enables [0:7];        // Load enable for each register
    wire [15:0] register_outputs [0:7]; // Output from each register

    // Address Decoder: DMux8Way distributes load signal to selected register
    // Only register[address] receives load=1, others receive load=0
    dmux8way load_decoder (
        .in (load),             // Load signal to distribute
        .sel(address),          // 3-bit address selector
        .a  (load_enables[0]),  // Load enable for register 0
        .b  (load_enables[1]),  // Load enable for register 1
        .c  (load_enables[2]),  // Load enable for register 2
        .d  (load_enables[3]),  // Load enable for register 3
        .e  (load_enables[4]),  // Load enable for register 4
        .f  (load_enables[5]),  // Load enable for register 5
        .g  (load_enables[6]),  // Load enable for register 6
        .h  (load_enables[7])   // Load enable for register 7
    );

    // Memory Array: 8 independent 16-bit registers using generate loop
    genvar register_index;
    generate
        for (register_index = 0; register_index < 8; register_index = register_index + 1) begin : memory_bank
            register16 memory_register (
                .in (in),                               // Shared data input
                .load(load_enables[register_index]),    // Individual load enable
                .clk(clk),                             // Shared clock
                .out(register_outputs[register_index])  // Individual output
            );
        end
    endgenerate

    // Output Selector: Mux8Way16 selects output from addressed register
    mux8way16 output_selector (
        .a  (register_outputs[0]),  // Output from register 0
        .b  (register_outputs[1]),  // Output from register 1
        .c  (register_outputs[2]),  // Output from register 2
        .d  (register_outputs[3]),  // Output from register 3
        .e  (register_outputs[4]),  // Output from register 4
        .f  (register_outputs[5]),  // Output from register 5
        .g  (register_outputs[6]),  // Output from register 6
        .h  (register_outputs[7]),  // Output from register 7
        .sel(address),              // Address selector
        .out(out)                   // Selected register output
    );

    // Operation Summary:
    // Write: DMux8Way routes load signal to register[address]
    // Store: Only register[address] loads new data on clock edge
    // Read:  Mux8Way16 routes register[address] output to module output

endmodule
