// src/sequential/program_counter.v – Compteur d’instructions 16 bits
// Priorité des commandes (haute → basse) : reset > load > inc > hold
`timescale 1ns / 1ps

module program_counter (
    input  wire [15:0] in,
    input  wire        load,
    input  wire        inc,
    input  wire        reset,
    input  wire        clk,
    output wire [15:0] out
);
    // ————————————————————————————————————————————
    // 1) registre courant
    // ————————————————————————————————————————————
    wire [15:0] curr;
    wire [15:0] next;   // ← déclaration manquante dans la première version

    register16 reg_pc (
        .in  (next),
        .load(1'b1),    // always load “next” à chaque front montant
        .clk (clk),
        .out (curr)
    );

    // ————————————————————————————————————————————
    // 2) curr + 1
    // ————————————————————————————————————————————
    wire [15:0] inc_val;
    add16 adder_plus1 (
        .a  (curr),
        .b  (16'h0001),
        .out(inc_val)
    );

    // ————————————————————————————————————————————
    // 3) Chaîne de MUX : inc → load → reset
    // ————————————————————————————————————————————
    wire [15:0] after_inc, after_load;

    mux16 mux_inc   ( .a(curr),      .b(inc_val), .sel(inc),   .out(after_inc) );
    mux16 mux_load  ( .a(after_inc), .b(in),      .sel(load),  .out(after_load) );
    mux16 mux_reset ( .a(after_load),.b(16'h0000),.sel(reset), .out(next) );

    // ————————————————————————————————————————————
    // 4) Sortie
    // ————————————————————————————————————————————
    assign out = curr;
endmodule