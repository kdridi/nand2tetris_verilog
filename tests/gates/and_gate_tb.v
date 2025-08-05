// tests/gates/and_gate_tb.v - Cycle TDD 2 pour la porte AND
// Test complet : vérifier la table de vérité complète de AND

`timescale 1ns / 1ps

module test_and;
    // Signaux de test
    reg a, b;
    wire out;
    
    // Instance du module à tester
    and_gate uut (
        .a(a),
        .b(b),
        .out(out)
    );
    
    // Test complet de la table de vérité
    initial begin
        $dumpfile("test_and.vcd");
        $dumpvars(0, test_and);
        
        $display("Test de la table de vérité AND");
        $display("a | b | out | attendu");
        $display("--|---|-----|--------");
        
        // Test 1: AND(0,0) = 0
        a = 0; b = 0; #10;
        $display("%b | %b |  %b  |   0", a, b, out);
        if (out !== 1'b0) begin
            $display("ECHEC: AND(0,0) = %b, attendu 0", out);
            $finish;
        end
        
        // Test 2: AND(0,1) = 0
        a = 0; b = 1; #10;
        $display("%b | %b |  %b  |   0", a, b, out);
        if (out !== 1'b0) begin
            $display("ECHEC: AND(0,1) = %b, attendu 0", out);
            $finish;
        end
        
        // Test 3: AND(1,0) = 0
        a = 1; b = 0; #10;
        $display("%b | %b |  %b  |   0", a, b, out);
        if (out !== 1'b0) begin
            $display("ECHEC: AND(1,0) = %b, attendu 0", out);
            $finish;
        end
        
        // Test 4: AND(1,1) = 1
        a = 1; b = 1; #10;
        $display("%b | %b |  %b  |   1", a, b, out);
        if (out !== 1'b1) begin
            $display("ECHEC: AND(1,1) = %b, attendu 1", out);
            $finish;
        end
        
        $display("");
        $display("SUCCES: Tous les tests AND passés !");
        $display("La porte AND (construite avec NAND+NOT) est fonctionnelle.");
        $finish;
    end
    
endmodule