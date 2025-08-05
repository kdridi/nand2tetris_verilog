// src/memory/ram64.v – Mémoire 64 mots × 16 bits (version optimisée)
`timescale 1ns / 1ps

module ram64 (
    input  wire [15:0] in,
    input  wire [5:0]  address,
    input  wire        load,
    input  wire        clk,
    output wire [15:0] out
);
    // Signaux de contrôle et sorties des bancs RAM8
    wire [7:0] load_signals;  // Un signal load par banc RAM8
    wire [15:0] ram_outputs [0:7];  // Sorties des 8 bancs RAM8
    wire [2:0] bank_select = address[5:3];  // Sélection du banc (3 MSB)
    wire [2:0] word_select = address[2:0];  // Adresse interne (3 LSB)
    
    // 1) DÉCODAGE DU SIGNAL LOAD avec generate
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            // load_signals[i] = 1 si bank_select == i ET load = 1
            assign load_signals[i] = (bank_select == i) & load;
        end
    endgenerate
    
    // 2) INSTANCIATION DES 8 BANCS RAM8
    generate
        for (i = 0; i < 8; i = i + 1) begin
            ram8 bank_inst (
                .in(in), 
                .address(word_select), 
                .load(load_signals[i]), 
                .clk(clk), 
                .out(ram_outputs[i])
            );
        end
    endgenerate
    
    // 3) MUX DE LECTURE - sélection directe par bank_select
    assign out = ram_outputs[bank_select];

endmodule