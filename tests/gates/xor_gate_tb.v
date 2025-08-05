// tests/gates/xor_gate_tb.v - Cycle TDD 2 pour la porte XOR
// Test complet : vérifier la table de vérité complète de XOR

`timescale 1ns / 1ps

module test_xor;
    // Signaux de test
    reg a, b;
    wire out;
    
    // Instance du module à tester
    xor_gate uut (
        .a(a),
        .b(b),
        .out(out)
    );
    
    // Test complet de la table de vérité
    initial begin
        $dumpfile("test_xor.vcd");
        $dumpvars(0, test_xor);
        
        $display("Test de la table de vérité XOR");
        $display("a | b | out | attendu");
        $display("--|---|-----|--------");
        
        // Test 1: XOR(0,0) = 0
        a = 0; b = 0; #10;
        $display("%b | %b |  %b  |   0", a, b, out);
        if (out !== 1'b0) begin
            $display("ECHEC: XOR(0,0) = %b, attendu 0", out);
            $finish;
        end
        
        // Test 2: XOR(0,1) = 1
        a = 0; b = 1; #10;
        $display("%b | %b |  %b  |   1", a, b, out);
        if (out !== 1'b1) begin
            $display("ECHEC: XOR(0,1) = %b, attendu 1", out);
            $finish;
        end
        
        // Test 3: XOR(1,0) = 1
        a = 1; b = 0; #10;
        $display("%b | %b |  %b  |   1", a, b, out);
        if (out !== 1'b1) begin
            $display("ECHEC: XOR(1,0) = %b, attendu 1", out);
            $finish;
        end
        
        // Test 4: XOR(1,1) = 0
        a = 1; b = 1; #10;
        $display("%b | %b |  %b  |   0", a, b, out);
        if (out !== 1'b0) begin
            $display("ECHEC: XOR(1,1) = %b, attendu 0", out);
            $finish;
        end
        
        $display("");
        $display("SUCCES: Tous les tests XOR passés !");
        $display("La porte XOR (construite avec AND+OR+NOT) est fonctionnelle.");
        $display("");
        $display("🎉 ETAPE MAJEURE COMPLETEE !");
        $display("Toutes les portes logiques de base sont implémentées :");
        $display("  - NAND (primitive)");
        $display("  - NOT  (à partir de NAND)");
        $display("  - AND  (à partir de NAND+NOT)");
        $display("  - OR   (à partir de NAND+NOT)");
        $display("  - XOR  (à partir de AND+OR+NOT)");
        $finish;
    end
    
endmodule