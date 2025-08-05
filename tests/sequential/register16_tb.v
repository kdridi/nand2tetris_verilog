// tests/sequential/register16_tb.v - Cycle TDD 2 pour le registre 16-bits
// Test complet : vérifier la charge et conservation de mots 16-bits

`timescale 1ns / 1ps

module register16_tb;
    // Signaux de test
    reg [15:0] in;
    reg load, clk;
    wire [15:0] out;
    
    // Instance du module à tester
    register16 uut (
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
        $dumpfile("register16_tb.vcd");
        $dumpvars(0, register16_tb);
        
        $display("Test complet du registre 16-bits");
        $display("=================================");
        
        // Initialisation
        in = 16'h0000;
        load = 0;
        #2;
        
        $display("Phase 1: Chargement de 0x1234");
        // Test 1: Charger 0x1234
        in = 16'h1234;
        load = 1;
        $display("  Avant front: in=0x%04X, load=%b, out=0x%04X", in, load, out);
        @(posedge clk); #1;
        $display("  Après front: in=0x%04X, load=%b, out=0x%04X", in, load, out);
        if (out !== 16'h1234) begin
            $display("ECHEC: out devrait être 0x1234");
            $finish;
        end
        
        $display("Phase 2: Conservation (load=0)");
        // Test 2: Changer in mais avec load=0
        in = 16'h5678;
        load = 0;
        $display("  Avant front: in=0x%04X, load=%b, out=0x%04X", in, load, out);
        @(posedge clk); #1;
        $display("  Après front: in=0x%04X, load=%b, out=0x%04X", in, load, out);
        if (out !== 16'h1234) begin // Doit rester à 0x1234
            $display("ECHEC: out devrait rester à 0x1234");
            $finish;
        end
        
        $display("Phase 3: Nouveau chargement de 0xABCD");
        // Test 3: Charger 0xABCD
        in = 16'hABCD;
        load = 1;
        $display("  Avant front: in=0x%04X, load=%b, out=0x%04X", in, load, out);
        @(posedge clk); #1;
        $display("  Après front: in=0x%04X, load=%b, out=0x%04X", in, load, out);
        if (out !== 16'hABCD) begin
            $display("ECHEC: out devrait être 0xABCD");
            $finish;
        end
        
        $display("Phase 4: Test avec patterns spéciaux");
        // Test 4: Patterns alternants
        in = 16'hAAAA;
        load = 1;
        @(posedge clk); #1;
        $display("  Pattern 0xAAAA: out=0x%04X", out);
        if (out !== 16'hAAAA) begin
            $display("ECHEC: out devrait être 0xAAAA");
            $finish;
        end
        
        in = 16'h5555;
        load = 1;
        @(posedge clk); #1;
        $display("  Pattern 0x5555: out=0x%04X", out);
        if (out !== 16'h5555) begin
            $display("ECHEC: out devrait être 0x5555");
            $finish;
        end
        
        $display("Phase 5: Test des extrema");
        // Test 5: Valeurs extrêmes
        in = 16'h0000;
        load = 1;
        @(posedge clk); #1;
        $display("  Zéro: out=0x%04X", out);
        if (out !== 16'h0000) begin
            $display("ECHEC: out devrait être 0x0000");
            $finish;
        end
        
        in = 16'hFFFF;
        load = 1;
        @(posedge clk); #1;
        $display("  Maximum: out=0x%04X", out);
        if (out !== 16'hFFFF) begin
            $display("ECHEC: out devrait être 0xFFFF");
            $finish;
        end
        
        $display("Phase 6: Conservation du maximum");
        // Test 6: Conserver 0xFFFF
        in = 16'h0000; // Changer in mais ne pas charger
        load = 0;
        @(posedge clk); #1;
        $display("  Conservation: out=0x%04X", out);
        if (out !== 16'hFFFF) begin
            $display("ECHEC: out devrait rester à 0xFFFF");
            $finish;
        end
        
        $display("");
        $display("SUCCES: Tous les tests Register16 passés !");
        $display("Le registre 16-bits fonctionne parfaitement.");
        $display("");
        $display("🎉 REGISTRE 16-BITS COMPLETE !");
        $display("Architecture mémoire de base terminée !");
        
        #10;
        $finish;
    end
    
endmodule