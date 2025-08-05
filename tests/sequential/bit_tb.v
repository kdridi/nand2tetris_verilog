// tests/sequential/bit_tb.v - Cycle TDD 2 pour le registre 1-bit
// Test complet : vérifier la charge et la conservation

`timescale 1ns / 1ps

module test_bit;
    // Signaux de test
    reg in, load, clk;
    wire out;
    
    // Instance du module à tester
    bit uut (
        .in(in),
        .load(load),
        .clk(clk),
        .out(out)
    );
    
    // Génération d'horloge
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Période de 10ns
    end
    
    // Test complet
    initial begin
        $dumpfile("test_bit.vcd");
        $dumpvars(0, test_bit);
        
        $display("Test complet du registre 1-bit");
        $display("===============================");
        
        // Initialisation
        in = 0;
        load = 0;
        #2;
        
        $display("Phase 1: Chargement d'un 1");
        // Test 1: Charger un 1
        in = 1;
        load = 1;
        $display("  Avant front: in=%b, load=%b, out=%b", in, load, out);
        @(posedge clk); #1;
        $display("  Après front: in=%b, load=%b, out=%b", in, load, out);
        if (out !== 1'b1) begin
            $display("ECHEC: out devrait être 1");
            $finish;
        end
        
        $display("Phase 2: Conservation (load=0)");
        // Test 2: Changer in mais avec load=0 (doit conserver)
        in = 0;
        load = 0;
        $display("  Avant front: in=%b, load=%b, out=%b", in, load, out);
        @(posedge clk); #1;
        $display("  Après front: in=%b, load=%b, out=%b", in, load, out);
        if (out !== 1'b1) begin // Doit rester à 1
            $display("ECHEC: out devrait rester à 1");
            $finish;
        end
        
        $display("Phase 3: Nouveau chargement d'un 0");
        // Test 3: Charger un 0
        in = 0;
        load = 1;
        $display("  Avant front: in=%b, load=%b, out=%b", in, load, out);
        @(posedge clk); #1;
        $display("  Après front: in=%b, load=%b, out=%b", in, load, out);
        if (out !== 1'b0) begin
            $display("ECHEC: out devrait être 0");
            $finish;
        end
        
        $display("Phase 4: Conservation du 0");
        // Test 4: Conserver le 0
        in = 1; // Changer in mais load=0
        load = 0;
        $display("  Avant front: in=%b, load=%b, out=%b", in, load, out);
        @(posedge clk); #1;
        $display("  Après front: in=%b, load=%b, out=%b", in, load, out);
        if (out !== 1'b0) begin // Doit rester à 0
            $display("ECHEC: out devrait rester à 0");
            $finish;
        end
        
        $display("Phase 5: Séquence alternée");
        // Test 5: Alternance charge/conserve
        in = 1; load = 1; @(posedge clk); #1;
        $display("  Charge 1: out=%b", out);
        if (out !== 1'b1) begin
            $display("ECHEC: out devrait être 1");
            $finish;
        end
        
        in = 0; load = 0; @(posedge clk); #1; // Conserve
        $display("  Conserve: out=%b", out);
        if (out !== 1'b1) begin
            $display("ECHEC: out devrait rester à 1");
            $finish;
        end
        
        in = 0; load = 1; @(posedge clk); #1; // Charge 0
        $display("  Charge 0: out=%b", out);
        if (out !== 1'b0) begin
            $display("ECHEC: out devrait être 0");
            $finish;
        end
        
        $display("");
        $display("SUCCES: Tous les tests Bit register passés !");
        $display("Le registre 1-bit avec load fonctionne correctement.");
        $display("");
        $display("🎉 REGISTRE 1-BIT COMPLETE !");
        $display("Prêt pour le registre 16-bits !");
        
        #10;
        $finish;
    end
    
endmodule