// tests/gates/or_gate_tb.v - Cycle TDD 2 pour la porte OR
// Test complet : vérifier la table de vérité complète de OR

`timescale 1ns / 1ps

module test_or;
    // Signaux de test
    reg a, b;
    wire out;
    
    // Instance du module à tester
    or_gate uut (
        .a(a),
        .b(b),
        .out(out)
    );
    
    // Test complet de la table de vérité
    initial begin
        $dumpfile("test_or.vcd");
        $dumpvars(0, test_or);
        
        $display("Test de la table de vérité OR");
        $display("a | b | out | attendu");
        $display("--|---|-----|--------");
        
        // Test 1: OR(0,0) = 0
        a = 0; b = 0; #10;
        $display("%b | %b |  %b  |   0", a, b, out);
        if (out !== 1'b0) begin
            $display("ECHEC: OR(0,0) = %b, attendu 0", out);
            $finish;
        end
        
        // Test 2: OR(0,1) = 1
        a = 0; b = 1; #10;
        $display("%b | %b |  %b  |   1", a, b, out);
        if (out !== 1'b1) begin
            $display("ECHEC: OR(0,1) = %b, attendu 1", out);
            $finish;
        end
        
        // Test 3: OR(1,0) = 1
        a = 1; b = 0; #10;
        $display("%b | %b |  %b  |   1", a, b, out);
        if (out !== 1'b1) begin
            $display("ECHEC: OR(1,0) = %b, attendu 1", out);
            $finish;
        end
        
        // Test 4: OR(1,1) = 1
        a = 1; b = 1; #10;
        $display("%b | %b |  %b  |   1", a, b, out);
        if (out !== 1'b1) begin
            $display("ECHEC: OR(1,1) = %b, attendu 1", out);
            $finish;
        end
        
        $display("");
        $display("SUCCES: Tous les tests OR passés !");
        $display("La porte OR (construite avec NAND+NOT) est fonctionnelle.");
        $finish;
    end
    
endmodule