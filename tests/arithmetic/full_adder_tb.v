// tests/arithmetic/full_adder_tb.v - Cycle TDD 2 pour l'additionneur complet
// Test complet : vérifier la table de vérité complète (8 cas)

`timescale 1ns / 1ps

module full_adder_tb;
    // Signaux de test
    reg a, b, carry_in;
    wire sum, carry_out;
    
    // Instance du module à tester
    full_adder uut (
        .a(a),
        .b(b),
        .carry_in(carry_in),
        .sum(sum),
        .carry_out(carry_out)
    );
    
    // Test complet
    initial begin
        $dumpfile("full_adder_tb.vcd");
        $dumpvars(0, full_adder_tb);
        
        $display("Test complet de l'additionneur complet (Full Adder)");
        $display("===================================================");
        $display("a | b | carry_in | sum | carry_out | addition");
        $display("--|---|----------|-----|-----------|--------");
        
        // Test 1: 0 + 0 + 0 = 0
        a = 0; b = 0; carry_in = 0; #10;
        $display("%b | %b |    %b     |  %b  |     %b     | %b+%b+%b=%b%b", a, b, carry_in, sum, carry_out, a, b, carry_in, carry_out, sum);
        if (sum !== 1'b0 || carry_out !== 1'b0) begin
            $display("ECHEC: FA(0,0,0) -> sum=%b, carry_out=%b, attendu sum=0, carry_out=0", sum, carry_out);
            $finish;
        end
        
        // Test 2: 0 + 0 + 1 = 1
        a = 0; b = 0; carry_in = 1; #10;
        $display("%b | %b |    %b     |  %b  |     %b     | %b+%b+%b=%b%b", a, b, carry_in, sum, carry_out, a, b, carry_in, carry_out, sum);
        if (sum !== 1'b1 || carry_out !== 1'b0) begin
            $display("ECHEC: FA(0,0,1) -> sum=%b, carry_out=%b, attendu sum=1, carry_out=0", sum, carry_out);
            $finish;
        end
        
        // Test 3: 0 + 1 + 0 = 1
        a = 0; b = 1; carry_in = 0; #10;
        $display("%b | %b |    %b     |  %b  |     %b     | %b+%b+%b=%b%b", a, b, carry_in, sum, carry_out, a, b, carry_in, carry_out, sum);
        if (sum !== 1'b1 || carry_out !== 1'b0) begin
            $display("ECHEC: FA(0,1,0) -> sum=%b, carry_out=%b, attendu sum=1, carry_out=0", sum, carry_out);
            $finish;
        end
        
        // Test 4: 0 + 1 + 1 = 0, carry = 1
        a = 0; b = 1; carry_in = 1; #10;
        $display("%b | %b |    %b     |  %b  |     %b     | %b+%b+%b=%b%b", a, b, carry_in, sum, carry_out, a, b, carry_in, carry_out, sum);
        if (sum !== 1'b0 || carry_out !== 1'b1) begin
            $display("ECHEC: FA(0,1,1) -> sum=%b, carry_out=%b, attendu sum=0, carry_out=1", sum, carry_out);
            $finish;
        end
        
        // Test 5: 1 + 0 + 0 = 1
        a = 1; b = 0; carry_in = 0; #10;
        $display("%b | %b |    %b     |  %b  |     %b     | %b+%b+%b=%b%b", a, b, carry_in, sum, carry_out, a, b, carry_in, carry_out, sum);
        if (sum !== 1'b1 || carry_out !== 1'b0) begin
            $display("ECHEC: FA(1,0,0) -> sum=%b, carry_out=%b, attendu sum=1, carry_out=0", sum, carry_out);
            $finish;
        end
        
        // Test 6: 1 + 0 + 1 = 0, carry = 1
        a = 1; b = 0; carry_in = 1; #10;
        $display("%b | %b |    %b     |  %b  |     %b     | %b+%b+%b=%b%b", a, b, carry_in, sum, carry_out, a, b, carry_in, carry_out, sum);
        if (sum !== 1'b0 || carry_out !== 1'b1) begin
            $display("ECHEC: FA(1,0,1) -> sum=%b, carry_out=%b, attendu sum=0, carry_out=1", sum, carry_out);
            $finish;
        end
        
        // Test 7: 1 + 1 + 0 = 0, carry = 1
        a = 1; b = 1; carry_in = 0; #10;
        $display("%b | %b |    %b     |  %b  |     %b     | %b+%b+%b=%b%b", a, b, carry_in, sum, carry_out, a, b, carry_in, carry_out, sum);
        if (sum !== 1'b0 || carry_out !== 1'b1) begin
            $display("ECHEC: FA(1,1,0) -> sum=%b, carry_out=%b, attendu sum=0, carry_out=1", sum, carry_out);
            $finish;
        end
        
        // Test 8: 1 + 1 + 1 = 1, carry = 1
        a = 1; b = 1; carry_in = 1; #10;
        $display("%b | %b |    %b     |  %b  |     %b     | %b+%b+%b=%b%b", a, b, carry_in, sum, carry_out, a, b, carry_in, carry_out, sum);
        if (sum !== 1'b1 || carry_out !== 1'b1) begin
            $display("ECHEC: FA(1,1,1) -> sum=%b, carry_out=%b, attendu sum=1, carry_out=1", sum, carry_out);
            $finish;
        end
        
        $display("");
        $display("SUCCES: Tous les tests Full Adder passés !");
        $display("L'additionneur complet est fonctionnel.");
        $display("");
        $display("🎉 ADDITIONNEUR COMPLET TERMINE !");
        $display("Prêt pour l'additionneur 16-bits !");
        $finish;
    end
    
endmodule