// src/arithmetic/add16.v – Additionneur 16 bits (ripple-carry) basé sur des full_adder
`timescale 1ns / 1ps

module add16 (
    input  wire [15:0] a,
    input  wire [15:0] b,
    output wire [15:0] out
);
    // Retenues : 0 en entrée, puis chaîne de 16 retenues intermédiaires
    wire [16:0] carry;  // carry[0] = entrée, carry[16] = débordement
    
    assign carry[0] = 1'b0;  // Pas de retenue d'entrée
    
    // Chaîne d'additionneurs avec propagation de retenue
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            full_adder fa_inst (
                .a(a[i]), 
                .b(b[i]), 
                .carry_in(carry[i]), 
                .sum(out[i]), 
                .carry_out(carry[i+1])
            );
        end
    endgenerate
    
    // carry[16] disponible pour détection de débordement si nécessaire

endmodule