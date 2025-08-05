// src/sequential/dff.v – Flip‑Flop D à déclenchement sur front montant
`timescale 1ns / 1ps

module dff (
    input  wire d,    // donnée à mémoriser
    input  wire clk,  // horloge
    output reg  q     // sortie mémorisée
);
    // Capture de d au front montant de l’horloge
    always @(posedge clk) begin
        q <= d;
    end
endmodule