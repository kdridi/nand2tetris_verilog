// src/memory/ram8.v – Mémoire 8 mots × 16 bits
// Ports : in[15:0], address[2:0], load, clk → out[15:0]
`timescale 1ns / 1ps

module ram8 (
    input  wire [15:0] in,
    input  wire [2:0]  address,
    input  wire        load,
    input  wire        clk,
    output wire [15:0] out
);
    // ------------------------------------------------------------
    // 1) DÉCODAGE DU SIGNAL LOAD  (dmux en arbre)
    // ------------------------------------------------------------
    wire load_low4, load_high4;
    dmux d0 (.in(load), .sel(address[2]), .a(load_low4), .b(load_high4));

    wire load_low2, load_low3;
    dmux d1 (.in(load_low4),  .sel(address[1]), .a(load_low2),  .b(load_low3));

    wire load_high2, load_high3;
    dmux d2 (.in(load_high4), .sel(address[1]), .a(load_high2), .b(load_high3));

    wire load0, load1, load2, load3, load4, load5, load6, load7;
    dmux d3 (.in(load_low2),  .sel(address[0]), .a(load0), .b(load1));
    dmux d4 (.in(load_low3),  .sel(address[0]), .a(load2), .b(load3));
    dmux d5 (.in(load_high2), .sel(address[0]), .a(load4), .b(load5));
    dmux d6 (.in(load_high3), .sel(address[0]), .a(load6), .b(load7));

    // ------------------------------------------------------------
    // 2) 8 REGISTRES 16 bits
    // ------------------------------------------------------------
    wire [15:0] r0, r1, r2, r3, r4, r5, r6, r7;

    register16 reg0 (.in(in), .load(load0), .clk(clk), .out(r0));
    register16 reg1 (.in(in), .load(load1), .clk(clk), .out(r1));
    register16 reg2 (.in(in), .load(load2), .clk(clk), .out(r2));
    register16 reg3 (.in(in), .load(load3), .clk(clk), .out(r3));
    register16 reg4 (.in(in), .load(load4), .clk(clk), .out(r4));
    register16 reg5 (.in(in), .load(load5), .clk(clk), .out(r5));
    register16 reg6 (.in(in), .load(load6), .clk(clk), .out(r6));
    register16 reg7 (.in(in), .load(load7), .clk(clk), .out(r7));

    // ------------------------------------------------------------
    // 3) MUX DE LECTURE (arbre de mux16)
    // ------------------------------------------------------------
    wire [15:0] m01, m23, m45, m67;
    mux16 m0 (.a(r0), .b(r1), .sel(address[0]), .out(m01));
    mux16 m1 (.a(r2), .b(r3), .sel(address[0]), .out(m23));
    mux16 m2 (.a(r4), .b(r5), .sel(address[0]), .out(m45));
    mux16 m3 (.a(r6), .b(r7), .sel(address[0]), .out(m67));

    wire [15:0] m0123, m4567;
    mux16 m4 (.a(m01), .b(m23), .sel(address[1]), .out(m0123));
    mux16 m5 (.a(m45), .b(m67), .sel(address[1]), .out(m4567));

    mux16 m6 (.a(m0123), .b(m4567), .sel(address[2]), .out(out));
endmodule