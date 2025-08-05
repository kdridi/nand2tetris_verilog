// tests/arithmetic/alu_tb.v - Cycle TDD 2 pour l'ALU
// Test complet : vérifier les principales opérations de l'ALU Nand2Tetris

`timescale 1ns / 1ps

module alu_tb;
    // Signaux de test
    reg [15:0] x, y;
    reg zx, nx, zy, ny, f, no;
    wire [15:0] out;
    wire zr, ng;
    
    // Instance du module à tester
    alu uut (
        .x(x), .y(y),
        .zx(zx), .nx(nx), .zy(zy), .ny(ny), .f(f), .no(no),
        .out(out), .zr(zr), .ng(ng)
    );
    
    // Tâche pour afficher un test
    task test_task(
        input [15:0] test_x, test_y,
        input test_zx, test_nx, test_zy, test_ny, test_f, test_no,
        input [15:0] expected_out,
        input expected_zr, expected_ng,
        input [47:0] description
    );
    begin
        x = test_x; y = test_y;
        zx = test_zx; nx = test_nx; zy = test_zy; ny = test_ny; f = test_f; no = test_no;
        #10;
        
        $display("Test: %s", description);
        $display("  Entrées: x=%d, y=%d, contrôles: zx=%b nx=%b zy=%b ny=%b f=%b no=%b", 
                 x, y, zx, nx, zy, ny, f, no);
        $display("  Résultat: out=%d (0x%04X), zr=%b, ng=%b", out, out, zr, ng);
        
        if (out !== expected_out) begin
            $display("  ECHEC: out attendu %d (0x%04X)", expected_out, expected_out);
            $finish;
        end
        if (zr !== expected_zr) begin
            $display("  ECHEC: zr attendu %b", expected_zr);
            $finish;
        end
        if (ng !== expected_ng) begin
            $display("  ECHEC: ng attendu %b", expected_ng);
            $finish;
        end
        $display("  ✓ SUCCES");
        $display("");
    end
    endtask
    
    // Test complet
    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);
        
        $display("Test complet de l'ALU Nand2Tetris");
        $display("==================================");
        $display("");
        
        // Test des constantes
        test_task(16'd0, 16'd0, 1, 0, 1, 0, 1, 0, 16'd0, 1, 0, "Constante 0");
        test_task(16'd0, 16'd0, 1, 1, 1, 1, 1, 1, 16'd1, 0, 0, "Constante 1");
        test_task(16'd0, 16'd0, 1, 1, 1, 0, 1, 0, 16'hFFFF, 0, 1, "Constante -1");
        
        // Test de x
        test_task(16'd5, 16'd0, 0, 0, 1, 1, 0, 0, 16'd5, 0, 0, "Sortir x");
        test_task(16'd5, 16'd0, 0, 0, 1, 1, 0, 1, 16'hFFFA, 0, 1, "Sortir !x");
        test_task(16'hFFFA, 16'd0, 0, 0, 1, 1, 0, 1, 16'd5, 0, 0, "Sortir !x (négatif)");
        
        // Test de y  
        test_task(16'd0, 16'd7, 1, 1, 0, 0, 0, 0, 16'd7, 0, 0, "Sortir y");
        test_task(16'd0, 16'd7, 1, 1, 0, 0, 0, 1, 16'hFFF8, 0, 1, "Sortir !y");
        
        // Test d'addition
        test_task(16'd2, 16'd3, 0, 0, 0, 0, 1, 0, 16'd5, 0, 0, "x + y = 2 + 3");
        test_task(16'd10, 16'd5, 0, 0, 0, 0, 1, 0, 16'd15, 0, 0, "x + y = 10 + 5");
        test_task(16'd0, 16'd0, 0, 0, 0, 0, 1, 0, 16'd0, 1, 0, "x + y = 0 + 0");
        
        // Test avec manipulation des entrées
        test_task(16'd10, 16'd3, 0, 0, 0, 1, 1, 0, 16'd6, 0, 0, "x + !y = 10 + !3");
        test_task(16'd10, 16'd3, 0, 1, 0, 0, 1, 0, 16'hFFF8, 0, 1, "!x + y = !10 + 3");
        
        // Test ET logique
        test_task(16'hF0F0, 16'h0F0F, 0, 0, 0, 0, 0, 0, 16'h0000, 1, 0, "x & y = 0xF0F0 & 0x0F0F");
        test_task(16'hFFFF, 16'h5555, 0, 0, 0, 0, 0, 0, 16'h5555, 0, 0, "x & y = 0xFFFF & 0x5555");
        
        // Test OU logique (via De Morgan: x | y = !((!x) & (!y)))
        test_task(16'hF0F0, 16'h0F0F, 0, 1, 0, 1, 0, 1, 16'hFFFF, 0, 1, "x | y = 0xF0F0 | 0x0F0F");
        
        $display("SUCCES: Tous les tests ALU passés !");
        $display("L'ALU Nand2Tetris est complètement fonctionnelle.");
        $display("");
        $display("🎉 ALU COMPLETE !");
        $display("Le cœur computationnel est opérationnel !");
        
        $finish;
    end
    
endmodule