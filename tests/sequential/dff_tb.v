// tests/sequential/dff_tb.v - Cycle TDD 2 pour le D Flip-Flop
// Test complet : vérifier le stockage et la mémorisation

`timescale 1ns / 1ps

module dff_tb;
    // Signaux de test
    reg d, clk;
    wire q;
    
    // Instance du module à tester
    dff uut (
        .d(d),
        .clk(clk),
        .q(q)
    );
    
    // Génération d'horloge
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Période de 10ns (100MHz)
    end
    
    // Test complet
    initial begin
        $dumpfile("dff_tb.vcd");
        $dumpvars(0, dff_tb);
        
        $display("Test complet du D Flip-Flop");
        $display("===========================");
        
        // Initialisation
        d = 0;
        #2; // Stabilisation
        
        $display("Phase 1: Stockage d'un 1");
        // Test 1: Stocker un 1
        d = 1;
        $display("  Avant front: d=%b, q=%b", d, q);
        @(posedge clk);
        #1; // Délai de propagation
        $display("  Après front: d=%b, q=%b", d, q);
        if (q !== 1'b1) begin
            $display("ECHEC: q devrait être 1");
            $finish;
        end
        
        $display("Phase 2: Mémorisation (d change mais pas sur front d'horloge)");
        // Test 2: Changer d entre les fronts d'horloge
        #2;
        d = 0; // Changer d mais pas sur un front
        #2;
        $display("  d changé à 0 entre fronts: d=%b, q=%b", d, q);
        if (q !== 1'b1) begin // q doit rester à 1
            $display("ECHEC: q devrait rester à 1");
            $finish;
        end
        
        $display("Phase 3: Nouveau stockage d'un 0");
        // Test 3: Stocker un 0 sur le prochain front
        @(posedge clk);
        #1;
        $display("  Après front avec d=0: d=%b, q=%b", d, q);
        if (q !== 1'b0) begin
            $display("ECHEC: q devrait être 0");
            $finish;
        end
        
        $display("Phase 4: Alternance rapide");
        // Test 4: Plusieurs alternances
        d = 1;
        @(posedge clk); #1;
        $display("  Cycle 1: d=%b, q=%b", d, q);
        if (q !== 1'b1) begin
            $display("ECHEC: q devrait être 1");
            $finish;
        end
        
        d = 0;
        @(posedge clk); #1;
        $display("  Cycle 2: d=%b, q=%b", d, q);
        if (q !== 1'b0) begin
            $display("ECHEC: q devrait être 0");
            $finish;
        end
        
        d = 1;
        @(posedge clk); #1;
        $display("  Cycle 3: d=%b, q=%b", d, q);
        if (q !== 1'b1) begin
            $display("ECHEC: q devrait être 1");
            $finish;
        end
        
        $display("");
        $display("SUCCES: Tous les tests DFF passés !");
        $display("Le D Flip-Flop fonctionne correctement.");
        $display("");
        $display("🎉 ELEMENT DE MEMOIRE DE BASE COMPLETE !");
        $display("Prêt pour les registres multi-bits !");
        
        #10;
        $finish;
    end
    
endmodule