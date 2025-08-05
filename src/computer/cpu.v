// src/computer/cpu.v – Version « cycle 3 » : A‑instr., C‑instr. (dest A/D/M) et sauts Jxx
// Ports : cf. spécification Nand2Tetris
`timescale 1ns / 1ps

module cpu (
    input  wire        clk,
    input  wire        reset,

    // interface RAM‑données
    input  wire [15:0] inM,
    output wire [15:0] outM,
    output wire [14:0] addressM,
    output wire        writeM,

    // instruction courante (ROM)
    input  wire [15:0] instruction,

    // programme‑counter courant (ROM address)
    output wire [15:0] pc
);
    // ────────────────────────────────────────────────────────────────
    // 0) DÉCODAGE GÉNÉRAL
    // ────────────────────────────────────────────────────────────────
    wire isA   = (instruction[15] == 1'b0);  // A‑type
    wire isC   = (instruction[15] == 1'b1);  // C‑type

    // Champs (index Hack : 1 1 1 a zx nx zy ny f no d1 d2 d3 j1 j2 j3)
    wire        a_bit = instruction[12];
    wire [5:0]  comp  = instruction[11:6];   // zx nx zy ny f no
    wire [2:0]  dest  = instruction[5:3];    // A D M
    wire [2:0]  jump  = instruction[2:0];    // Jxx

    // ────────────────────────────────────────────────────────────────
    // 1) REGISTRES A et D
    // ────────────────────────────────────────────────────────────────
    wire [15:0] A_out, D_out;
    wire [15:0] alu_x, alu_y, alu_out;
    wire        alu_zr, alu_ng;

    // Registre A : charge pour A‑instr. OU pour C‑instr. si dest[A]=1
    wire loadA = isA | (isC & dest[2]);          // dest[2]=d1 (A)
    wire [15:0] A_in = isA ? instruction : alu_out;
    register16 regA (.in(A_in), .load(loadA), .clk(clk), .out(A_out));

    // Registre D : charge si C‑instr. dest[D]=1 (dest[1])
    wire loadD = isC & dest[1];
    register16 regD (.in(alu_out), .load(loadD), .clk(clk), .out(D_out));

    assign addressM = A_out[14:0];               // adresse RAM = A

    // ────────────────────────────────────────────────────────────────
    // 2) ALU
    //    X = D
    //    Y = (a_bit ? inM : A)
    // ────────────────────────────────────────────────────────────────
    assign alu_x = D_out;
    assign alu_y = a_bit ? inM : A_out;

    alu alu_core (
        .x (alu_x),
        .y (alu_y),
        .zx(comp[5]),
        .nx(comp[4]),
        .zy(comp[3]),
        .ny(comp[2]),
        .f (comp[1]),
        .no(comp[0]),
        .out(alu_out),
        .zr (alu_zr),
        .ng (alu_ng)
    );

    // Dest[M] → write en RAM
    assign writeM = isC & dest[0];               // dest[0]=d3 (M)
    assign outM   = alu_out;                     // valeur à écrire si writeM=1

    // ────────────────────────────────────────────────────────────────
    // 3) LOGIQUE DE SAUT
    //    Table Jxx (Hack spec)
    // ────────────────────────────────────────────────────────────────
    wire j1 = jump[0], j2 = jump[1], j3 = jump[2];

    wire jump_condition =
          (jump == 3'b000) ? 1'b0                                   :  // Pas de saut
          (jump == 3'b111) ? 1'b1                                   :  // JMP
          (jump == 3'b001) ? (~alu_zr & ~alu_ng)                    :  // JGT
          (jump == 3'b010) ?  alu_zr                                :  // JEQ
          (jump == 3'b011) ? (~alu_ng)                              :  // JGE
          (jump == 3'b100) ?  alu_ng                                :  // JLT
          (jump == 3'b101) ? (~alu_zr)                              :  // JNE
                             (alu_ng | alu_zr);                        // JLE (110)

    wire pcLoad = isC & jump_condition;  // charge PC avec A si condition vraie

    // ────────────────────────────────────────────────────────────────
    // 4) PROGRAM COUNTER
    // ────────────────────────────────────────────────────────────────
    wire pc_inc = ~pcLoad;               // si saut → pas d’auto‑inc
    program_counter PC (
        .in   (A_out),                   // cible de saut = A
        .load (pcLoad),
        .inc  (pc_inc),
        .reset(reset),
        .clk  (clk),
        .out  (pc)
    );
endmodule
