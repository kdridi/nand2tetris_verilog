// tests/gates/not_gate_tb.v - Cycle TDD 2 pour la porte NOT
// Test complet : vérifier la table de vérité complète de NOT

`timescale 1ns / 1ps

module test_not;
    // Signaux de test
    reg in;
    wire out;
    
    // Instance du module à tester
    not_gate uut (
        .in(in),
        .out(out)
    );
    
    // Test complet de la table de vérité
    initial begin
        $dumpfile("test_not.vcd");
        $dumpvars(0, test_not);
        
        $display("Test de la table de vérité NOT");
        $display("in | out | attendu");
        $display("---|-----|--------");
        
        // Test 1: NOT(0) = 1
        in = 0; #10;
        $display(" %b |  %b  |   1", in, out);
        if (out !== 1'b1) begin
            $display("ECHEC: NOT(0) = %b, attendu 1", out);
            $finish;
        end
        
        // Test 2: NOT(1) = 0
        in = 1; #10;
        $display(" %b |  %b  |   0", in, out);
        if (out !== 1'b0) begin
            $display("ECHEC: NOT(1) = %b, attendu 0", out);
            $finish;
        end
        
        $display("");
        $display("SUCCES: Tous les tests NOT passés !");
        $display("La porte NOT (construite avec NAND) est fonctionnelle.");
        $finish;
    end
    
endmodule