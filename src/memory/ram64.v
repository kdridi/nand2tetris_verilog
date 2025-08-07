// src/memory/ram64.v - 64-Register RAM with 6-bit Addressing
// Part of Nand2Tetris Verilog Implementation
// Function: 64 words × 16 bits memory - Hierarchical memory using RAM8 banks
// Architecture: DMux8Way + 8 × RAM8 + Mux8Way16

`timescale 1ns / 1ps

module ram64 (
    input  wire [15:0] in,      // Data input to write
    input  wire [5:0]  address, // 6-bit address (selects 1 of 64 registers)
    input  wire        load,    // Write enable (1=write data to addressed register)
    input  wire        clk,     // Clock signal (positive edge triggered)
    output wire [15:0] out      // Data output from addressed register
);

    // Address decode: Split 6-bit address into bank and word selection
    wire [2:0] bank_selector;   // Upper 3 bits select RAM8 bank (0-7)
    wire [2:0] word_selector;   // Lower 3 bits select word within bank (0-7)
    
    assign bank_selector = address[5:3];    // MSB: bank selection
    assign word_selector = address[2:0];    // LSB: word within bank

    // Internal signals for bank control and outputs
    wire bank_load_enables [0:7];           // Load enable for each RAM8 bank
    wire [15:0] bank_outputs [0:7];         // Output from each RAM8 bank

    // Bank Address Decoder: DMux8Way distributes load signal to selected bank
    // Only bank[bank_selector] receives load=1, others receive load=0
    dmux8way bank_load_decoder (
        .in (load),                     // Load signal to distribute
        .sel(bank_selector),            // 3-bit bank selector
        .a  (bank_load_enables[0]),     // Load enable for RAM8 bank 0
        .b  (bank_load_enables[1]),     // Load enable for RAM8 bank 1
        .c  (bank_load_enables[2]),     // Load enable for RAM8 bank 2
        .d  (bank_load_enables[3]),     // Load enable for RAM8 bank 3
        .e  (bank_load_enables[4]),     // Load enable for RAM8 bank 4
        .f  (bank_load_enables[5]),     // Load enable for RAM8 bank 5
        .g  (bank_load_enables[6]),     // Load enable for RAM8 bank 6
        .h  (bank_load_enables[7])      // Load enable for RAM8 bank 7
    );

    // Memory Bank Array: 8 independent RAM8 modules using generate loop
    // Each RAM8 provides 8 × 16-bit registers, total = 64 × 16-bit registers
    genvar bank_index;
    generate
        for (bank_index = 0; bank_index < 8; bank_index = bank_index + 1) begin : memory_banks
            ram8 bank_memory (
                .in     (in),                           // Shared data input
                .address(word_selector),                // Shared word selector (3 LSB)
                .load   (bank_load_enables[bank_index]), // Individual bank load enable
                .clk    (clk),                          // Shared clock
                .out    (bank_outputs[bank_index])      // Individual bank output
            );
        end
    endgenerate

    // Bank Output Selector: Mux8Way16 selects output from addressed bank
    mux8way16 bank_output_selector (
        .a  (bank_outputs[0]),      // Output from RAM8 bank 0
        .b  (bank_outputs[1]),      // Output from RAM8 bank 1
        .c  (bank_outputs[2]),      // Output from RAM8 bank 2
        .d  (bank_outputs[3]),      // Output from RAM8 bank 3
        .e  (bank_outputs[4]),      // Output from RAM8 bank 4
        .f  (bank_outputs[5]),      // Output from RAM8 bank 5
        .g  (bank_outputs[6]),      // Output from RAM8 bank 6
        .h  (bank_outputs[7]),      // Output from RAM8 bank 7
        .sel(bank_selector),        // Bank selector (3 MSB of address)
        .out(out)                   // Selected bank output
    );

    // Operation Summary:
    // Write: DMux8Way routes load to bank[address[5:3]]
    //        Selected bank writes data to register[address[2:0]]
    // Read:  Mux8Way16 routes bank[address[5:3]] output to module output
    // Address mapping: address[5:3] = bank, address[2:0] = word within bank

endmodule