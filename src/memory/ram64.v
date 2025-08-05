// src/memory/ram64.v – Mémoire 64 mots × 16 bits (8 × RAM8)
// Adresse [5:3]  ➜ choix du banc RAM8
// Adresse [2:0]  ➜ adresse interne dans ce banc
`timescale 1ns / 1ps

module ram64 (
    input  wire [15:0] in,        // données à écrire
    input  wire [5:0]  address,   // [5:3]=banc, [2:0]=offset
    input  wire        load,      // 1 = écrire
    input  wire        clk,       // horloge
    output wire [15:0] out        // données lues
);
    // ------------------------------------------------------------------
    // 1) Décodage du signal LOAD vers un unique banc (DMUX en 3 niveaux)
    // ------------------------------------------------------------------
    wire load_lo4, load_hi4;
    dmux d0 (.in(load), .sel(address[5]), .a(load_lo4), .b(load_hi4));

    wire load_lo2, load_lo3;
    dmux d1 (.in(load_lo4), .sel(address[4]), .a(load_lo2), .b(load_lo3));

    wire load_hi2, load_hi3;
    dmux d2 (.in(load_hi4), .sel(address[4]), .a(load_hi2), .b(load_hi3));

    wire load0, load1, load2, load3, load4, load5, load6, load7;
    dmux d3 (.in(load_lo2), .sel(address[3]), .a(load0), .b(load1));
    dmux d4 (.in(load_lo3), .sel(address[3]), .a(load2), .b(load3));
    dmux d5 (.in(load_hi2), .sel(address[3]), .a(load4), .b(load5));
    dmux d6 (.in(load_hi3), .sel(address[3]), .a(load6), .b(load7));

    // ------------------------------------------------------------------
    // 2) Huit bancs RAM8 partageant la même adresse interne [2:0]
    // ------------------------------------------------------------------
    wire [15:0] r0, r1, r2, r3, r4, r5, r6, r7;
    ram8 b0 (.in(in), .address(address[2:0]), .load(load0), .clk(clk), .out(r0));
    ram8 b1 (.in(in), .address(address[2:0]), .load(load1), .clk(clk), .out(r1));
    ram8 b2 (.in(in), .address(address[2:0]), .load(load2), .clk(clk), .out(r2));
    ram8 b3 (.in(in), .address(address[2:0]), .load(load3), .clk(clk), .out(r3));
    ram8 b4 (.in(in), .address(address[2:0]), .load(load4), .clk(clk), .out(r4));
    ram8 b5 (.in(in), .address(address[2:0]), .load(load5), .clk(clk), .out(r5));
    ram8 b6 (.in(in), .address(address[2:0]), .load(load6), .clk(clk), .out(r6));
    ram8 b7 (.in(in), .address(address[2:0]), .load(load7), .clk(clk), .out(r7));

    // ------------------------------------------------------------------
    // 3) Multiplexeur de lecture (MUX16 en 3 niveaux)
    // ------------------------------------------------------------------
    wire [15:0] m01, m23, m45, m67, m0123, m4567;
    mux16 m0 (.a(r0), .b(r1), .sel(address[3]), .out(m01));
    mux16 m1 (.a(r2), .b(r3), .sel(address[3]), .out(m23));
    mux16 m2 (.a(r4), .b(r5), .sel(address[3]), .out(m45));
    mux16 m3 (.a(r6), .b(r7), .sel(address[3]), .out(m67));

    mux16 m4 (.a(m01),  .b(m23),  .sel(address[4]), .out(m0123));
    mux16 m5 (.a(m45),  .b(m67),  .sel(address[4]), .out(m4567));

    mux16 m6 (.a(m0123), .b(m4567), .sel(address[5]), .out(out));
endmodule
