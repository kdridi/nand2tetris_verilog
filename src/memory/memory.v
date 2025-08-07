// src/memory/memory.v - Complete Hack Computer Memory System with I/O
// Part of Nand2Tetris Verilog Implementation
// Function: Memory-mapped system with RAM, Screen, and Keyboard
// Architecture: Address decoder routes to RAM16K, Screen memory, or Keyboard register

`timescale 1ns / 1ps

module memory (
    input  wire [15:0] in,      // Data input for write operations
    input  wire [14:0] address, // 15-bit address (32K address space)
    input  wire        load,    // Write enable (1=write, 0=read)
    input  wire        clk,     // Clock signal
    output wire [15:0] out      // Data output from addressed location
);

    // Memory Map (Hack Computer specification):
    // 0x0000-0x3FFF (0-16383)    : RAM16K - Main memory for variables/heap
    // 0x4000-0x5FFF (16384-24575): SCREEN - Screen memory map (512x256 pixels)  
    // 0x6000 (24576)             : KEYBOARD - Keyboard memory map (ASCII codes)

    // Address decode signals
    wire ram_select;        // Select RAM16K (address[14:13] == 00)
    wire screen_select;     // Select Screen (address[14:13] == 10) 
    wire keyboard_select;   // Select Keyboard (address == 0x6000)

    // Component outputs
    wire [15:0] ram_out;
    wire [15:0] screen_out;
    wire [15:0] keyboard_out;

    // Address decoding logic
    assign ram_select      = (address[14] == 1'b0);                       // 0x0000-0x3FFF
    assign screen_select   = (address[14:13] == 2'b10);                   // 0x4000-0x5FFF  
    assign keyboard_select = (address == 15'h6000);                       // 0x6000

    // Main Memory: RAM16K for variables, arrays, heap
    // Uses lower 14 bits of address (0-16383)
    ram16k main_memory (
        .in     (in),
        .address(address[13:0]),        // 14-bit address for 16K words
        .load   (load & ram_select),    // Write only when RAM selected
        .clk    (clk),
        .out    (ram_out)
    );

    // Screen Memory: 8K words for 512×256 pixel display
    // Each word represents 16 pixels (1 bit per pixel)
    // Uses lower 13 bits of address (0-8191 within screen space)
    reg [15:0] screen_memory [0:8191];  // 8K × 16-bit screen buffer

    // Screen write logic
    always @(posedge clk) begin
        if (load & screen_select) begin
            screen_memory[address[12:0]] <= in;
        end
    end

    // Screen read logic
    assign screen_out = screen_select ? screen_memory[address[12:0]] : 16'h0000;

    // Keyboard Memory: Single register for current key code
    // In real hardware, this would be connected to keyboard controller
    // For simulation, can be driven externally or remain 0 (no key pressed)
    reg [15:0] keyboard_register;

    // Loop variable for initialization
    integer i;

    initial begin
        keyboard_register = 16'h0000;   // No key pressed initially
        // Initialize screen memory to blank (all pixels off)
        for (i = 0; i < 8192; i = i + 1) begin
            screen_memory[i] = 16'h0000;
        end
    end

    // Keyboard is read-only from CPU perspective
    assign keyboard_out = keyboard_select ? keyboard_register : 16'h0000;

    // Output multiplexer: Select appropriate component output
    assign out = ram_select ? ram_out : 
                 screen_select ? screen_out : 
                 keyboard_select ? keyboard_out : 
                 16'h0000;

    // Memory operation summary:
    // Read:  Address decoder selects RAM, Screen, or Keyboard output
    // Write: Address decoder enables write to RAM or Screen only
    //        (Keyboard is read-only - updated by external input)

endmodule