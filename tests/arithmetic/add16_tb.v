// tests/arithmetic/add16_tb.v - Cycle TDD 2 pour l'additionneur 16-bits
// Test complet : vérifier plusieurs additions avec différents patterns

`timescale 1ns / 1ps

module add16_tb;
    // Signaux de test
    reg [15:0] a, b;
    wire [15:0] out;
    
    // Instance du module à tester
    add16 uut (
        .a(a),
        .b(b),
        .out(out)
    );
    
    // Test complet
    initial begin
        $dumpfile("add16_tb.vcd");
        $dumpvars(0, add16_tb);
        
        $display("Test complet de l'additionneur 16-bits");
        $display("======================================");
        
        // Test 1: 0 + 0 = 0
        a = 16'h0000; b = 16'h0000; #10;
        $display("Test 1: 0x%04X + 0x%04X = 0x%04X (%d + %d = %d)", a, b, out, a, b, out);
        if (out !== 16'h0000) begin
            $display("ECHEC: attendu 0x0000");
            $finish;
        end
        
        // Test 2: 1 + 1 = 2
        a = 16'h0001; b = 16'h0001; #10;
        $display("Test 2: 0x%04X + 0x%04X = 0x%04X (%d + %d = %d)", a, b, out, a, b, out);
        if (out !== 16'h0002) begin
            $display("ECHEC: attendu 0x0002");
            $finish;
        end
        
        // Test 3: 5 + 3 = 8
        a = 16'h0005; b = 16'h0003; #10;
        $display("Test 3: 0x%04X + 0x%04X = 0x%04X (%d + %d = %d)", a, b, out, a, b, out);
        if (out !== 16'h0008) begin
            $display("ECHEC: attendu 0x0008");
            $finish;
        end
        
        // Test 4: 255 + 1 = 256 (test de propagation de retenue)
        a = 16'h00FF; b = 16'h0001; #10;
        $display("Test 4: 0x%04X + 0x%04X = 0x%04X (%d + %d = %d)", a, b, out, a, b, out);
        if (out !== 16'h0100) begin
            $display("ECHEC: attendu 0x0100");
            $finish;
        end
        
        // Test 5: 4095 + 1 = 4096 (propagation multiple)
        a = 16'h0FFF; b = 16'h0001; #10;
        $display("Test 5: 0x%04X + 0x%04X = 0x%04X (%d + %d = %d)", a, b, out, a, b, out);
        if (out !== 16'h1000) begin
            $display("ECHEC: attendu 0x1000");
            $finish;
        end
        
        // Test 6: 32767 + 1 = 32768 (test du bit de signe)
        a = 16'h7FFF; b = 16'h0001; #10;
        $display("Test 6: 0x%04X + 0x%04X = 0x%04X (%d + %d = %d)", a, b, out, a, b, out);
        if (out !== 16'h8000) begin
            $display("ECHEC: attendu 0x8000");
            $finish;
        end
        
        // Test 7: 65535 + 1 = 0 (débordement 16-bits)
        a = 16'hFFFF; b = 16'h0001; #10;
        $display("Test 7: 0x%04X + 0x%04X = 0x%04X (%d + %d = %d) [débordement]", a, b, out, a, b, out);
        if (out !== 16'h0000) begin
            $display("ECHEC: attendu 0x0000 (débordement)");
            $finish;
        end
        
        // Test 8: Addition complexe 0x1234 + 0x5678 = 0x68AC
        a = 16'h1234; b = 16'h5678; #10;
        $display("Test 8: 0x%04X + 0x%04X = 0x%04X (%d + %d = %d)", a, b, out, a, b, out);
        if (out !== 16'h68AC) begin
            $display("ECHEC: attendu 0x68AC");
            $finish;
        end
        
        // Test 9: Patterns alternants 0xAAAA + 0x5555 = 0xFFFF
        a = 16'hAAAA; b = 16'h5555; #10;
        $display("Test 9: 0x%04X + 0x%04X = 0x%04X (%d + %d = %d)", a, b, out, a, b, out);
        if (out !== 16'hFFFF) begin
            $display("ECHEC: attendu 0xFFFF");
            $finish;
        end
        
        $display("");
        $display("SUCCES: Tous les tests Add16 passés !");
        $display("L'additionneur 16-bits est fonctionnel.");
        $display("");
        $display("🎉 ADDITIONNEUR 16-BITS COMPLETE !");
        $display("Architecture arithmétique de base terminée !");
        $finish;
    end
    
endmodule