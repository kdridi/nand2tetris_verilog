// tests/arithmetic/half_adder_tb.v - Cycle TDD 2 pour le demi-additionneur
// Test complet : vérifier la table de vérité complète

`timescale 1ns / 1ps

module test_half_adder;
    // Signaux de test
    reg a, b;
    wire sum, carry;
    
    // Instance du module à tester
    half_adder uut (
        .a(a),
        .b(b),
        .sum(sum),
        .carry(carry)
    );
    
    // Test complet
    initial begin
        $dumpfile("test_half_adder.vcd");
        $dumpvars(0, test_half_adder);
        
        $display("Test complet du demi-additionneur (Half Adder)");
        $display("===============================================");
        $display("a | b | sum | carry | addition");
        $display("--|---|-----|-------|--------");
        
        // Test 1: 0 + 0 = 0, carry = 0
        a = 0; b = 0; #10;
        $display("%b | %b |  %b  |   %b   | %b + %b = %b%b", a, b, sum, carry, a, b, carry, sum);
        if (sum !== 1'b0 || carry !== 1'b0) begin
            $display("ECHEC: HA(0,0) -> sum=%b, carry=%b, attendu sum=0, carry=0", sum, carry);
            $finish;
        end
        
        // Test 2: 0 + 1 = 1, carry = 0
        a = 0; b = 1; #10;
        $display("%b | %b |  %b  |   %b   | %b + %b = %b%b", a, b, sum, carry, a, b, carry, sum);
        if (sum !== 1'b1 || carry !== 1'b0) begin
            $display("ECHEC: HA(0,1) -> sum=%b, carry=%b, attendu sum=1, carry=0", sum, carry);
            $finish;
        end
        
        // Test 3: 1 + 0 = 1, carry = 0
        a = 1; b = 0; #10;
        $display("%b | %b |  %b  |   %b   | %b + %b = %b%b", a, b, sum, carry, a, b, carry, sum);
        if (sum !== 1'b1 || carry !== 1'b0) begin
            $display("ECHEC: HA(1,0) -> sum=%b, carry=%b, attendu sum=1, carry=0", sum, carry);
            $finish;
        end
        
        // Test 4: 1 + 1 = 0, carry = 1 (1 + 1 = 10 en binaire)
        a = 1; b = 1; #10;
        $display("%b | %b |  %b  |   %b   | %b + %b = %b%b", a, b, sum, carry, a, b, carry, sum);
        if (sum !== 1'b0 || carry !== 1'b1) begin
            $display("ECHEC: HA(1,1) -> sum=%b, carry=%b, attendu sum=0, carry=1", sum, carry);
            $finish;
        end
        
        $display("");
        $display("SUCCES: Tous les tests Half Adder passés !");
        $display("Le demi-additionneur est fonctionnel.");
        $display("");
        $display("🎉 PREMIER CIRCUIT ARITHMETIQUE COMPLETE !");
        $display("Prêt pour le Full Adder (additionneur complet) !");
        $finish;
    end
    
endmodule