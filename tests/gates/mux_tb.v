// tests/gates/mux_tb.v - Cycle TDD 2 pour le multiplexeur 2-vers-1
// Test complet : vérifier tous les cas du multiplexeur

`timescale 1ns / 1ps

module test_mux;
    // Signaux de test
    reg a, b, sel;
    wire out;
    
    // Instance du module à tester
    mux uut (
        .a(a),
        .b(b),
        .sel(sel),
        .out(out)
    );
    
    // Test complet
    initial begin
        $dumpfile("test_mux.vcd");
        $dumpvars(0, test_mux);
        
        $display("Test complet du multiplexeur 2-vers-1");
        $display("a | b | sel | out | attendu (sel=0→a, sel=1→b)");
        $display("--|---|-----|-----|-------------------------");
        
        // Test 1: sel=0, a=0, b=0 -> out=a=0
        a = 0; b = 0; sel = 0; #10;
        $display("%b | %b |  %b  |  %b  | %b (sélectionne a)", a, b, sel, out, a);
        if (out !== a) begin
            $display("ECHEC: MUX(a=%b, b=%b, sel=0) = %b, attendu %b", a, b, out, a);
            $finish;
        end
        
        // Test 2: sel=0, a=1, b=0 -> out=a=1
        a = 1; b = 0; sel = 0; #10;
        $display("%b | %b |  %b  |  %b  | %b (sélectionne a)", a, b, sel, out, a);
        if (out !== a) begin
            $display("ECHEC: MUX(a=%b, b=%b, sel=0) = %b, attendu %b", a, b, out, a);
            $finish;
        end
        
        // Test 3: sel=0, a=0, b=1 -> out=a=0
        a = 0; b = 1; sel = 0; #10;
        $display("%b | %b |  %b  |  %b  | %b (sélectionne a)", a, b, sel, out, a);
        if (out !== a) begin
            $display("ECHEC: MUX(a=%b, b=%b, sel=0) = %b, attendu %b", a, b, out, a);
            $finish;
        end
        
        // Test 4: sel=0, a=1, b=1 -> out=a=1
        a = 1; b = 1; sel = 0; #10;
        $display("%b | %b |  %b  |  %b  | %b (sélectionne a)", a, b, sel, out, a);
        if (out !== a) begin
            $display("ECHEC: MUX(a=%b, b=%b, sel=0) = %b, attendu %b", a, b, out, a);
            $finish;
        end
        
        // Test 5: sel=1, a=0, b=0 -> out=b=0
        a = 0; b = 0; sel = 1; #10;
        $display("%b | %b |  %b  |  %b  | %b (sélectionne b)", a, b, sel, out, b);
        if (out !== b) begin
            $display("ECHEC: MUX(a=%b, b=%b, sel=1) = %b, attendu %b", a, b, out, b);
            $finish;
        end
        
        // Test 6: sel=1, a=1, b=0 -> out=b=0
        a = 1; b = 0; sel = 1; #10;
        $display("%b | %b |  %b  |  %b  | %b (sélectionne b)", a, b, sel, out, b);
        if (out !== b) begin
            $display("ECHEC: MUX(a=%b, b=%b, sel=1) = %b, attendu %b", a, b, out, b);
            $finish;
        end
        
        // Test 7: sel=1, a=0, b=1 -> out=b=1
        a = 0; b = 1; sel = 1; #10;
        $display("%b | %b |  %b  |  %b  | %b (sélectionne b)", a, b, sel, out, b);
        if (out !== b) begin
            $display("ECHEC: MUX(a=%b, b=%b, sel=1) = %b, attendu %b", a, b, out, b);
            $finish;
        end
        
        // Test 8: sel=1, a=1, b=1 -> out=b=1
        a = 1; b = 1; sel = 1; #10;
        $display("%b | %b |  %b  |  %b  | %b (sélectionne b)", a, b, sel, out, b);
        if (out !== b) begin
            $display("ECHEC: MUX(a=%b, b=%b, sel=1) = %b, attendu %b", a, b, out, b);
            $finish;
        end
        
        $display("");
        $display("SUCCES: Tous les tests MUX 2-vers-1 passés !");
        $display("Le multiplexeur est fonctionnel.");
        $finish;
    end
    
endmodule