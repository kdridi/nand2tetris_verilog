// src/computer/computer.v – Ordinateur Hack « tout‑en‑un » (CPU + ROM + RAM64)
// ------------------------------------------------------------------
// * ROM  : 32 K mots max (initialisée depuis "prog.hex")
// * RAM  : 64 mots (16 bits) pour les données (suffit à la démo)
// ------------------------------------------------------------------
// Ports :
//   clk, reset : horloge et remise à zéro
//   pc_out     : adresse d’instruction courante (debug facultatif)
//
// Pour l’utiliser :
//   1. Place ton programme assembleur compilé dans un fichier HEX :
//        $ cat prog.hex
//        000A
//        EC10
//        ...
//   2. Compile : iverilog ... computer.v <modules>.v
//   3. La ROM se charge automatiquement au démarrage.
//
`timescale 1ns / 1ps

module computer (
    input  wire clk,
    input  wire reset,
    output wire [15:0] pc_out          // signal de debug (facultatif)
);
    // ------------------------------------------------------------------
    // 1) Liaisons internes CPU <-> mémoire
    // ------------------------------------------------------------------
    wire [15:0] instruction;
    wire [15:0] inM, outM;
    wire [14:0] addressM;
    wire        writeM;
    wire [15:0] pc;

    // ------------------------------------------------------------------
    // 2) Mémoire de programme (ROM) – 32 K mots maximum
    // ------------------------------------------------------------------
    reg [15:0] rom [0:32767];         // 32K × 16 bits

    initial begin
        // Charge "prog.hex" (fichier texte : 1 mot 16 bits/ligne, hex).
        // En l’absence de fichier, la ROM vaudra 0x0000 partout.
        $readmemh("prog.hex", rom);
    end

    assign instruction = rom[pc];     // lecture combinatoire

    // ------------------------------------------------------------------
    // 3) Mémoire de données (RAM64) – 64 mots × 16 bits
    // ------------------------------------------------------------------
    ram64 data_ram (
        .in      (outM),
        .address (addressM[5:0]),     // on n’utilise que 6 bits
        .load    (writeM),
        .clk     (clk),
        .out     (inM)
    );

    // ------------------------------------------------------------------
    // 4) Processeur
    // ------------------------------------------------------------------
    cpu cpu_core (
        .clk        (clk),
        .reset      (reset),
        .inM        (inM),
        .instruction(instruction),
        .outM       (outM),
        .addressM   (addressM),
        .writeM     (writeM),
        .pc         (pc)
    );

    assign pc_out = pc;               // exposé pour la trace/DEBUG
endmodule