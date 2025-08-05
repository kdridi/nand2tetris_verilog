// src/sequential/bit.v – Registre 1 bit avec signal de charge (load)
`timescale 1ns / 1ps

module bit (
    input  wire in,    // donnée à charger
    input  wire load,  // 1 → charger « in », 0 → conserver
    input  wire clk,   // horloge
    output wire out    // valeur mémorisée
);
    wire q_internal;   // sortie interne du DFF
    wire d_next;       // donnée appliquée au DFF

    // Sélection : si load=1 → in, sinon → valeur courante
    mux sel_mux (
        .a   (q_internal), // garder
        .b   (in),         // charger
        .sel (load),
        .out (d_next)
    );

    // Stockage sur front montant
    dff storage (
        .d   (d_next),
        .clk (clk),
        .q   (q_internal)
    );

    assign out = q_internal;
endmodule