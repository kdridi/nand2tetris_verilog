// tests/gates/dmux_tb.v - Cycle TDD 2 pour le démultiplexeur 1-vers-2
// Test complet : vérifier tous les cas du démultiplexeur

`timescale 1ns / 1ps

module test_dmux;
    // Signaux de test
    reg in, sel;
    wire a, b;
    
    // Instance du module à tester
    dmux uut (
        .in(in),
        .sel(sel),
        .a(a),
        .b(b)
    );
    
    // Test complet
    initial begin
        $dumpfile("test_dmux.vcd");
        $dumpvars(0, test_dmux);
        
        $display("Test complet du démultiplexeur 1-vers-2");
        $display("in | sel | a | b | attendu (sel=0→a=in,b=0 / sel=1→a=0,b=in)");
        $display("---|-----|---|---|---------------------------------------");
        
        // Test 1: in=0, sel=0 -> a=0, b=0
        in = 0; sel = 0; #10;
        $display(" %b |  %b  | %b | %b | a=%b, b=%b (sel=0, dirige vers a)", in, sel, a, b, in, 1'b0);
        if (a !== 1'b0 || b !== 1'b0) begin
            $display("ECHEC: DMUX(in=0, sel=0) -> a=%b, b=%b, attendu a=0, b=0", a, b);
            $finish;
        end
        
        // Test 2: in=1, sel=0 -> a=1, b=0
        in = 1; sel = 0; #10;
        $display(" %b |  %b  | %b | %b | a=%b, b=%b (sel=0, dirige vers a)", in, sel, a, b, in, 1'b0);
        if (a !== 1'b1 || b !== 1'b0) begin
            $display("ECHEC: DMUX(in=1, sel=0) -> a=%b, b=%b, attendu a=1, b=0", a, b);
            $finish;
        end
        
        // Test 3: in=0, sel=1 -> a=0, b=0
        in = 0; sel = 1; #10;
        $display(" %b |  %b  | %b | %b | a=%b, b=%b (sel=1, dirige vers b)", in, sel, a, b, 1'b0, in);
        if (a !== 1'b0 || b !== 1'b0) begin
            $display("ECHEC: DMUX(in=0, sel=1) -> a=%b, b=%b, attendu a=0, b=0", a, b);
            $finish;
        end
        
        // Test 4: in=1, sel=1 -> a=0, b=1
        in = 1; sel = 1; #10;
        $display(" %b |  %b  | %b | %b | a=%b, b=%b (sel=1, dirige vers b)", in, sel, a, b, 1'b0, in);
        if (a !== 1'b0 || b !== 1'b1) begin
            $display("ECHEC: DMUX(in=1, sel=1) -> a=%b, b=%b, attendu a=0, b=1", a, b);
            $finish;
        end
        
        $display("");
        $display("SUCCES: Tous les tests DMUX 1-vers-2 passés !");
        $display("Le démultiplexeur est fonctionnel.");
        $display("");
        $display("🎉 CIRCUITS COMBINATOIRES DE BASE COMPLETES !");
        $display("Nous avons maintenant :");
        $display("  - Toutes les portes logiques (NAND, NOT, AND, OR, XOR)");
        $display("  - Multiplexeur 2-vers-1 (Mux)");
        $display("  - Démultiplexeur 1-vers-2 (Dmux)");
        $finish;
    end
    
endmodule