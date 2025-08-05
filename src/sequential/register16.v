// src/sequential/register16.v – Registre 16 bits avec signal de charge (load)
// Chaque bit est un bit indépendant.
`timescale 1ns / 1ps

module register16 (
    input  wire [15:0] in,    // mot à charger
    input  wire        load,  // 1 → charger « in », 0 → conserver
    input  wire        clk,   // horloge
    output wire [15:0] out    // mot mémorisé
);
    // Instanciation bit‑par‑bit
    bit br0  (.in(in[0]),  .load(load), .clk(clk), .out(out[0]));
    bit br1  (.in(in[1]),  .load(load), .clk(clk), .out(out[1]));
    bit br2  (.in(in[2]),  .load(load), .clk(clk), .out(out[2]));
    bit br3  (.in(in[3]),  .load(load), .clk(clk), .out(out[3]));
    bit br4  (.in(in[4]),  .load(load), .clk(clk), .out(out[4]));
    bit br5  (.in(in[5]),  .load(load), .clk(clk), .out(out[5]));
    bit br6  (.in(in[6]),  .load(load), .clk(clk), .out(out[6]));
    bit br7  (.in(in[7]),  .load(load), .clk(clk), .out(out[7]));
    bit br8  (.in(in[8]),  .load(load), .clk(clk), .out(out[8]));
    bit br9  (.in(in[9]),  .load(load), .clk(clk), .out(out[9]));
    bit br10 (.in(in[10]), .load(load), .clk(clk), .out(out[10]));
    bit br11 (.in(in[11]), .load(load), .clk(clk), .out(out[11]));
    bit br12 (.in(in[12]), .load(load), .clk(clk), .out(out[12]));
    bit br13 (.in(in[13]), .load(load), .clk(clk), .out(out[13]));
    bit br14 (.in(in[14]), .load(load), .clk(clk), .out(out[14]));
    bit br15 (.in(in[15]), .load(load), .clk(clk), .out(out[15]));
endmodule