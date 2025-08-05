// src/memory/ram8.v – Mémoire 8 mots × 16 bits (version optimisée)
`timescale 1ns / 1ps

module ram8 (
    input  wire [15:0] in,
    input  wire [2:0]  address,
    input  wire        load,
    input  wire        clk,
    output wire [15:0] out
);
    // Signaux de contrôle et sorties des registres
    wire [7:0] load_signals;  // Un signal load par registre
    wire [15:0] reg_outputs [0:7];  // Sorties des 8 registres
    
    // 1) DÉCODAGE DU SIGNAL LOAD avec generate
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            // load_signals[i] = 1 si address == i ET load = 1
            assign load_signals[i] = (address == i) & load;
        end
    endgenerate
    
    // 2) INSTANCIATION DES 8 REGISTRES
    generate
        for (i = 0; i < 8; i = i + 1) begin
            register16 reg_inst (
                .in(in), 
                .load(load_signals[i]), 
                .clk(clk), 
                .out(reg_outputs[i])
            );
        end
    endgenerate
    
    // 3) MUX DE LECTURE - sélection directe par adresse
    assign out = reg_outputs[address];

endmodule
