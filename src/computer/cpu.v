// src/computer/cpu.v - Nand2Tetris CPU Implementation
// Part of Nand2Tetris Verilog Implementation
// Function: Complete 16-bit CPU with A/D registers, ALU, and jump logic
// Architecture: Executes Hack assembly instructions (A-type and C-type)

`timescale 1ns / 1ps

module cpu (
    input  wire        clk,         // Clock signal
    input  wire        reset,       // Reset signal (synchronous)

    // Data memory interface
    input  wire [15:0] inM,         // Data input from memory
    output wire [15:0] outM,        // Data output to memory
    output wire [14:0] addressM,    // Memory address (15-bit)
    output wire        writeM,      // Memory write enable

    // Instruction memory interface
    input  wire [15:0] instruction, // Current instruction from ROM

    // Program counter output
    output wire [15:0] pc           // Program counter (ROM address)
);

    // Instruction type decoding
    wire isA = (instruction[15] == 1'b0);    // A-type instruction
    wire isC = (instruction[15] == 1'b1);    // C-type instruction

    // Instruction field extraction (Hack specification)
    // C-instruction format: 111a cccccc ddd jjj
    wire        a_bit = instruction[12];     // ALU input selector (A or M)
    wire [5:0]  comp  = instruction[11:6];   // ALU control bits
    wire [2:0]  dest  = instruction[5:3];    // Destination bits (A D M)
    wire [2:0]  jump  = instruction[2:0];    // Jump condition bits

    // Internal register outputs
    wire [15:0] A_out, D_out;
    wire [15:0] alu_out;
    wire        alu_zr, alu_ng;

    // A Register: Load on A-instruction OR C-instruction with dest[A]=1
    wire loadA = isA | (isC & dest[2]);
    wire [15:0] A_in = isA ? instruction : alu_out;
    register16 regA (
        .in(A_in), 
        .load(loadA), 
        .clk(clk), 
        .out(A_out)
    );

    // D Register: Load on C-instruction with dest[D]=1
    wire loadD = isC & dest[1];
    register16 regD (
        .in(alu_out), 
        .load(loadD), 
        .clk(clk), 
        .out(D_out)
    );

    // Memory address is lower 15 bits of A register
    assign addressM = A_out[14:0];

    // ALU inputs: X=D, Y=(a_bit ? inM : A)
    wire [15:0] alu_x = D_out;
    wire [15:0] alu_y = a_bit ? inM : A_out;

    // ALU instance
    alu alu_core (
        .x (alu_x),
        .y (alu_y),
        .zx(comp[5]),    // Zero X input
        .nx(comp[4]),    // Negate X input
        .zy(comp[3]),    // Zero Y input
        .ny(comp[2]),    // Negate Y input
        .f (comp[1]),    // Function selector (+ or &)
        .no(comp[0]),    // Negate output
        .out(alu_out),
        .zr (alu_zr),    // Zero flag
        .ng (alu_ng)     // Negative flag
    );

    // Memory write control: C-instruction with dest[M]=1
    assign writeM = isC & dest[0];
    assign outM   = alu_out;

    // Jump condition evaluation based on ALU flags
    wire jump_condition = 
        (jump == 3'b000) ? 1'b0 :                    // No jump
        (jump == 3'b001) ? (~alu_zr & ~alu_ng) :     // JGT (> 0)
        (jump == 3'b010) ? alu_zr :                  // JEQ (= 0)
        (jump == 3'b011) ? (~alu_ng) :               // JGE (>= 0)
        (jump == 3'b100) ? alu_ng :                  // JLT (< 0)
        (jump == 3'b101) ? (~alu_zr) :               // JNE (!= 0)
        (jump == 3'b110) ? (alu_ng | alu_zr) :       // JLE (<= 0)
        (jump == 3'b111) ? 1'b1 :                    // JMP (unconditional)
                          1'b0;                      // Default: no jump

    // Program counter control
    wire pcLoad = isC & jump_condition;
    wire pc_inc = ~pcLoad;

    program_counter PC (
        .in   (A_out),      // Jump target address
        .load (pcLoad),     // Load enable (jump)
        .inc  (pc_inc),     // Increment enable
        .reset(reset),      // Reset to 0
        .clk  (clk),
        .out  (pc)
    );

endmodule