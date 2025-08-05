// src/gates/mux16.v – Multiplexeur 16 bits (2 → 1) composé de mux unitaires
`timescale 1ns / 1ps

module mux16 (
    input  wire [15:0] a,   // entrée 0
    input  wire [15:0] b,   // entrée 1
    input  wire        sel, // sélecteur commun
    output wire [15:0] out  // sortie
);

    // Version optimisée avec generate pour éviter la répétition
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : mux_array
            mux mux_inst (
                .a(a[i]), 
                .b(b[i]), 
                .sel(sel), 
                .out(out[i])
            );
        end
    endgenerate

endmodule