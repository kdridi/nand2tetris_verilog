// tests/gates/and16_gate_tb.v - Cycle TDD 2 pour la porte AND 16-bits
// Test complet : vérifier plusieurs cas avec différents patterns

`timescale 1ns / 1ps

module test_and16;
    // Signaux de test
    reg [15:0] a, b;
    wire [15:0] out;
    
    // Instance du module à tester
    and16_gate uut (
        .a(a),
        .b(b),
        .out(out)
    );
    
    // Test complet
    initial begin
        $dumpfile("test_and16.vcd");
        $dumpvars(0, test_and16);
        
        $display("Test complet de la porte AND 16-bits");
        $display("====================================");
        
        // Test 1: 0xFFFF AND 0xFFFF = 0xFFFF
        a = 16'hFFFF; b = 16'hFFFF; #10;
        $display("Test 1: AND16(0x%04X, 0x%04X) = 0x%04X", a, b, out);
        if (out !== 16'hFFFF) begin
            $display("ECHEC: attendu 0xFFFF");
            $finish;
        end
        
        // Test 2: 0xFFFF AND 0x0000 = 0x0000
        a = 16'hFFFF; b = 16'h0000; #10;
        $display("Test 2: AND16(0x%04X, 0x%04X) = 0x%04X", a, b, out);
        if (out !== 16'h0000) begin
            $display("ECHEC: attendu 0x0000");
            $finish;
        end
        
        // Test 3: 0x0000 AND 0xFFFF = 0x0000
        a = 16'h0000; b = 16'hFFFF; #10;
        $display("Test 3: AND16(0x%04X, 0x%04X) = 0x%04X", a, b, out);
        if (out !== 16'h0000) begin
            $display("ECHEC: attendu 0x0000");
            $finish;
        end
        
        // Test 4: 0x0000 AND 0x0000 = 0x0000
        a = 16'h0000; b = 16'h0000; #10;
        $display("Test 4: AND16(0x%04X, 0x%04X) = 0x%04X", a, b, out);
        if (out !== 16'h0000) begin
            $display("ECHEC: attendu 0x0000");
            $finish;
        end
        
        // Test 5: 0xAAAA AND 0x5555 = 0x0000 (patterns alternants)
        a = 16'hAAAA; b = 16'h5555; #10;
        $display("Test 5: AND16(0x%04X, 0x%04X) = 0x%04X", a, b, out);
        if (out !== 16'h0000) begin
            $display("ECHEC: attendu 0x0000");
            $finish;
        end
        
        // Test 6: 0xAAAA AND 0xAAAA = 0xAAAA
        a = 16'hAAAA; b = 16'hAAAA; #10;
        $display("Test 6: AND16(0x%04X, 0x%04X) = 0x%04X", a, b, out);
        if (out !== 16'hAAAA) begin
            $display("ECHEC: attendu 0xAAAA");
            $finish;
        end
        
        // Test 7: 0x1234 AND 0x5678 = 0x1230
        a = 16'h1234; b = 16'h5678; #10;
        $display("Test 7: AND16(0x%04X, 0x%04X) = 0x%04X", a, b, out);
        if (out !== 16'h1230) begin
            $display("ECHEC: attendu 0x1230");
            $finish;
        end
        
        // Test 8: 0xFF00 AND 0x00FF = 0x0000 (masques complémentaires)
        a = 16'hFF00; b = 16'h00FF; #10;
        $display("Test 8: AND16(0x%04X, 0x%04X) = 0x%04X", a, b, out);
        if (out !== 16'h0000) begin
            $display("ECHEC: attendu 0x0000");
            $finish;
        end
        
        $display("");
        $display("SUCCES: Tous les tests AND16 passés !");
        $display("La porte AND 16-bits est fonctionnelle.");
        $finish;
    end
    
endmodule