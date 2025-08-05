// tests/gates/mux16_tb.v - Cycle TDD 2 pour le multiplexeur 16-bits
// Test complet : vérifier la sélection avec différents patterns

`timescale 1ns / 1ps

module test_mux16;
    // Signaux de test
    reg [15:0] a, b;
    reg sel;
    wire [15:0] out;
    
    // Instance du module à tester
    mux16 uut (
        .a(a),
        .b(b),
        .sel(sel),
        .out(out)
    );
    
    // Test complet
    initial begin
        $dumpfile("test_mux16.vcd");
        $dumpvars(0, test_mux16);
        
        $display("Test complet du multiplexeur 16-bits");
        $display("====================================");
        
        // Test 1: sel=0, sélectionne a
        a = 16'h1234; b = 16'h5678; sel = 0; #10;
        $display("Test 1: MUX16(a=0x%04X, b=0x%04X, sel=%b) = 0x%04X", a, b, sel, out);
        if (out !== a) begin
            $display("ECHEC: attendu a=0x%04X", a);
            $finish;
        end
        
        // Test 2: sel=1, sélectionne b
        a = 16'h1234; b = 16'h5678; sel = 1; #10;
        $display("Test 2: MUX16(a=0x%04X, b=0x%04X, sel=%b) = 0x%04X", a, b, sel, out);
        if (out !== b) begin
            $display("ECHEC: attendu b=0x%04X", b);
            $finish;
        end
        
        // Test 3: sel=0, avec 0x0000 et 0xFFFF
        a = 16'h0000; b = 16'hFFFF; sel = 0; #10;
        $display("Test 3: MUX16(a=0x%04X, b=0x%04X, sel=%b) = 0x%04X", a, b, sel, out);
        if (out !== a) begin
            $display("ECHEC: attendu a=0x%04X", a);
            $finish;
        end
        
        // Test 4: sel=1, avec 0x0000 et 0xFFFF
        a = 16'h0000; b = 16'hFFFF; sel = 1; #10;
        $display("Test 4: MUX16(a=0x%04X, b=0x%04X, sel=%b) = 0x%04X", a, b, sel, out);
        if (out !== b) begin
            $display("ECHEC: attendu b=0x%04X", b);
            $finish;
        end
        
        // Test 5: sel=0, patterns alternants
        a = 16'hAAAA; b = 16'h5555; sel = 0; #10;
        $display("Test 5: MUX16(a=0x%04X, b=0x%04X, sel=%b) = 0x%04X", a, b, sel, out);
        if (out !== a) begin
            $display("ECHEC: attendu a=0x%04X", a);
            $finish;
        end
        
        // Test 6: sel=1, patterns alternants
        a = 16'hAAAA; b = 16'h5555; sel = 1; #10;
        $display("Test 6: MUX16(a=0x%04X, b=0x%04X, sel=%b) = 0x%04X", a, b, sel, out);
        if (out !== b) begin
            $display("ECHEC: attendu b=0x%04X", b);
            $finish;
        end
        
        // Test 7: sel=0, avec masques
        a = 16'hFF00; b = 16'h00FF; sel = 0; #10;
        $display("Test 7: MUX16(a=0x%04X, b=0x%04X, sel=%b) = 0x%04X", a, b, sel, out);
        if (out !== a) begin
            $display("ECHEC: attendu a=0x%04X", a);
            $finish;
        end
        
        // Test 8: sel=1, avec masques
        a = 16'hFF00; b = 16'h00FF; sel = 1; #10;
        $display("Test 8: MUX16(a=0x%04X, b=0x%04X, sel=%b) = 0x%04X", a, b, sel, out);
        if (out !== b) begin
            $display("ECHEC: attendu b=0x%04X", b);
            $finish;
        end
        
        $display("");
        $display("SUCCES: Tous les tests MUX16 passés !");
        $display("Le multiplexeur 16-bits est fonctionnel.");
        $display("");
        $display("🎉 MULTIPLEXEUR 16-BITS COMPLETE !");
        $display("Nous approchons des circuits arithmétiques !");
        $finish;
    end
    
endmodule