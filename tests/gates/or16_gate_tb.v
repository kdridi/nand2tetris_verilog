// tests/gates/or16_gate_tb.v - Cycle TDD 2 pour la porte OR 16-bits
// Test complet : vérifier plusieurs cas avec différents patterns

`timescale 1ns / 1ps

module test_or16;
    // Signaux de test
    reg [15:0] a, b;
    wire [15:0] out;
    
    // Instance du module à tester
    or16_gate uut (
        .a(a),
        .b(b),
        .out(out)
    );
    
    // Test complet
    initial begin
        $dumpfile("test_or16.vcd");
        $dumpvars(0, test_or16);
        
        $display("Test complet de la porte OR 16-bits");
        $display("==================================");
        
        // Test 1: 0x0000 OR 0x0000 = 0x0000
        a = 16'h0000; b = 16'h0000; #10;
        $display("Test 1: OR16(0x%04X, 0x%04X) = 0x%04X", a, b, out);
        if (out !== 16'h0000) begin
            $display("ECHEC: attendu 0x0000");
            $finish;
        end
        
        // Test 2: 0xFFFF OR 0x0000 = 0xFFFF
        a = 16'hFFFF; b = 16'h0000; #10;
        $display("Test 2: OR16(0x%04X, 0x%04X) = 0x%04X", a, b, out);
        if (out !== 16'hFFFF) begin
            $display("ECHEC: attendu 0xFFFF");
            $finish;
        end
        
        // Test 3: 0x0000 OR 0xFFFF = 0xFFFF
        a = 16'h0000; b = 16'hFFFF; #10;
        $display("Test 3: OR16(0x%04X, 0x%04X) = 0x%04X", a, b, out);
        if (out !== 16'hFFFF) begin
            $display("ECHEC: attendu 0xFFFF");
            $finish;
        end
        
        // Test 4: 0xFFFF OR 0xFFFF = 0xFFFF
        a = 16'hFFFF; b = 16'hFFFF; #10;
        $display("Test 4: OR16(0x%04X, 0x%04X) = 0x%04X", a, b, out);
        if (out !== 16'hFFFF) begin
            $display("ECHEC: attendu 0xFFFF");
            $finish;
        end
        
        // Test 5: 0xAAAA OR 0x5555 = 0xFFFF (patterns alternants complémentaires)
        a = 16'hAAAA; b = 16'h5555; #10;
        $display("Test 5: OR16(0x%04X, 0x%04X) = 0x%04X", a, b, out);
        if (out !== 16'hFFFF) begin
            $display("ECHEC: attendu 0xFFFF");
            $finish;
        end
        
        // Test 6: 0xAAAA OR 0xAAAA = 0xAAAA
        a = 16'hAAAA; b = 16'hAAAA; #10;
        $display("Test 6: OR16(0x%04X, 0x%04X) = 0x%04X", a, b, out);
        if (out !== 16'hAAAA) begin
            $display("ECHEC: attendu 0xAAAA");
            $finish;
        end
        
        // Test 7: 0x1234 OR 0x5678 = 0x567C
        a = 16'h1234; b = 16'h5678; #10;
        $display("Test 7: OR16(0x%04X, 0x%04X) = 0x%04X", a, b, out);
        if (out !== 16'h567C) begin
            $display("ECHEC: attendu 0x567C");
            $finish;
        end
        
        // Test 8: 0xFF00 OR 0x00FF = 0xFFFF (masques complémentaires)
        a = 16'hFF00; b = 16'h00FF; #10;
        $display("Test 8: OR16(0x%04X, 0x%04X) = 0x%04X", a, b, out);
        if (out !== 16'hFFFF) begin
            $display("ECHEC: attendu 0xFFFF");
            $finish;
        end
        
        $display("");
        $display("SUCCES: Tous les tests OR16 passés !");
        $display("La porte OR 16-bits est fonctionnelle.");
        $display("");
        $display("🎉 PORTES LOGIQUES 16-BITS COMPLETEES !");
        $display("Nous avons maintenant NOT16, AND16 et OR16 !");
        $finish;
    end
    
endmodule