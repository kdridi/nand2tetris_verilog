// tests/gates/not16_gate_tb.v - Cycle TDD 2 pour la porte NOT 16-bits
// Test complet : vérifier plusieurs cas avec différents patterns

`timescale 1ns / 1ps

module test_not16;
    // Signaux de test
    reg [15:0] in;
    wire [15:0] out;
    
    // Instance du module à tester
    not16_gate uut (
        .in(in),
        .out(out)
    );
    
    // Test complet
    initial begin
        $dumpfile("test_not16.vcd");
        $dumpvars(0, test_not16);
        
        $display("Test complet de la porte NOT 16-bits");
        $display("=====================================");
        
        // Test 1: 0x0000 -> 0xFFFF
        in = 16'h0000; #10;
        $display("Test 1: NOT16(0x%04X) = 0x%04X", in, out);
        if (out !== 16'hFFFF) begin
            $display("ECHEC: attendu 0xFFFF");
            $finish;
        end
        
        // Test 2: 0xFFFF -> 0x0000
        in = 16'hFFFF; #10;
        $display("Test 2: NOT16(0x%04X) = 0x%04X", in, out);
        if (out !== 16'h0000) begin
            $display("ECHEC: attendu 0x0000");
            $finish;
        end
        
        // Test 3: 0xAAAA -> 0x5555 (pattern alternant)
        in = 16'hAAAA; #10;
        $display("Test 3: NOT16(0x%04X) = 0x%04X", in, out);
        if (out !== 16'h5555) begin
            $display("ECHEC: attendu 0x5555");
            $finish;
        end
        
        // Test 4: 0x5555 -> 0xAAAA (pattern alternant inverse)
        in = 16'h5555; #10;
        $display("Test 4: NOT16(0x%04X) = 0x%04X", in, out);
        if (out !== 16'hAAAA) begin
            $display("ECHEC: attendu 0xAAAA");
            $finish;
        end
        
        // Test 5: 0x00FF -> 0xFF00 (demi-mot)
        in = 16'h00FF; #10;
        $display("Test 5: NOT16(0x%04X) = 0x%04X", in, out);
        if (out !== 16'hFF00) begin
            $display("ECHEC: attendu 0xFF00");
            $finish;
        end
        
        // Test 6: 0x1234 -> 0xEDCB (valeur arbitraire)
        in = 16'h1234; #10;
        $display("Test 6: NOT16(0x%04X) = 0x%04X", in, out);
        if (out !== 16'hEDCB) begin
            $display("ECHEC: attendu 0xEDCB");
            $finish;
        end
        
        $display("");
        $display("SUCCES: Tous les tests NOT16 passés !");
        $display("La porte NOT 16-bits est fonctionnelle.");
        $display("");
        $display("🎉 PREMIERE PORTE MULTI-BITS COMPLETEE !");
        $finish;
    end
    
endmodule