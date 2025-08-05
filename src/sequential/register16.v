// src/sequential/register16.v – Registre 16 bits avec signal de charge (load)
// Chaque bit est un bit indépendant.
`timescale 1ns / 1ps

module register16 (
    input  wire [15:0] in,    // mot à charger
    input  wire        load,  // 1 → charger « in », 0 → conserver
    input  wire        clk,   // horloge
    output wire [15:0] out    // mot mémorisé
);
    // Instanciation bit-par-bit avec generate
    // Chaque bit: charge in[i] si load=1, sinon conserve la valeur
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            bit bit_inst (
                .in(in[i]), 
                .load(load), 
                .clk(clk), 
                .out(out[i])
            );
        end
    endgenerate

endmodule