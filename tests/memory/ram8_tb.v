// tests/memory/ram8_tb.v - Cycle TDD 2 pour la RAM8
// Test complet : vérifier toutes les adresses et la non-interférence

`timescale 1ns / 1ps

module test_ram8;
    // Signaux de test
    reg [15:0] in;
    reg [2:0] address;
    reg load, clk;
    wire [15:0] out;
    
    // Instance du module à tester
    ram8 uut (
        .in(in),
        .address(address),
        .load(load),
        .clk(clk),
        .out(out)
    );
    
    // Génération d'horloge
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Période de 10ns
    end
    
    // Tâche pour test d'écriture/lecture
    task write_read_test(
        input [2:0] addr,
        input [15:0] data,
        input [47:0] description
    );
    begin
        $display("Test: %s", description);
        
        // Écriture
        address = addr;
        in = data;
        load = 1;
        @(posedge clk); #1;
        $display("  Écriture: RAM8[%d] ← 0x%04X", addr, data);
        
        // Lecture
        load = 0;
        #1;
        $display("  Lecture:  RAM8[%d] → 0x%04X", addr, out);
        
        if (out !== data) begin
            $display("  ECHEC: attendu 0x%04X", data);
            $finish;
        end
        $display("  ✓ SUCCES");
        $display("");
    end
    endtask
    
    // Test complet
    initial begin
        $dumpfile("test_ram8.vcd");
        $dumpvars(0, test_ram8);
        
        $display("Test complet de la RAM8");
        $display("=======================");
        $display("");
        
        // Initialisation
        in = 16'h0000;
        address = 3'b000;
        load = 0;
        #2;
        
        $display("Phase 1: Test de chaque adresse individuellement");
        // Test de toutes les adresses
        write_read_test(3'd0, 16'h1111, "Adresse 0");
        write_read_test(3'd1, 16'h2222, "Adresse 1");
        write_read_test(3'd2, 16'h3333, "Adresse 2");
        write_read_test(3'd3, 16'h4444, "Adresse 3");
        write_read_test(3'd4, 16'h5555, "Adresse 4");
        write_read_test(3'd5, 16'h6666, "Adresse 5");
        write_read_test(3'd6, 16'h7777, "Adresse 6");
        write_read_test(3'd7, 16'h8888, "Adresse 7");
        
        $display("Phase 2: Vérification de la non-interférence");
        // Vérifier que toutes les valeurs sont toujours présentes
        load = 0; // Mode lecture seule
        
        address = 3'd0; #1;
        $display("Vérif RAM8[0] = 0x%04X (attendu 0x1111)", out);
        if (out !== 16'h1111) begin
            $display("ECHEC: interférence détectée à l'adresse 0");
            $finish;
        end
        
        address = 3'd3; #1;
        $display("Vérif RAM8[3] = 0x%04X (attendu 0x4444)", out);
        if (out !== 16'h4444) begin
            $display("ECHEC: interférence détectée à l'adresse 3");
            $finish;
        end
        
        address = 3'd7; #1;
        $display("Vérif RAM8[7] = 0x%04X (attendu 0x8888)", out);
        if (out !== 16'h8888) begin
            $display("ECHEC: interférence détectée à l'adresse 7");
            $finish;
        end
        
        $display("Phase 3: Test de réécriture");
        // Réécrire à l'adresse 2
        address = 3'd2;
        in = 16'hABCD;
        load = 1;
        @(posedge clk); #1;
        load = 0; #1;
        
        $display("Réécriture RAM8[2]: 0x3333 → 0x%04X", out);
        if (out !== 16'hABCD) begin
            $display("ECHEC: réécriture échouée");
            $finish;
        end
        
        // Vérifier que les autres adresses n'ont pas changé
        address = 3'd1; #1;
        if (out !== 16'h2222) begin
            $display("ECHEC: réécriture a affecté l'adresse 1");
            $finish;
        end
        
        address = 3'd3; #1;
        if (out !== 16'h4444) begin
            $display("ECHEC: réécriture a affecté l'adresse 3");
            $finish;
        end
        
        $display("Phase 4: Test avec patterns particuliers");
        // Patterns extrêmes
        write_read_test(3'd0, 16'h0000, "Pattern 0x0000");
        write_read_test(3'd1, 16'hFFFF, "Pattern 0xFFFF");
        write_read_test(3'd2, 16'hAAAA, "Pattern 0xAAAA");
        write_read_test(3'd3, 16'h5555, "Pattern 0x5555");
        
        $display("SUCCES: Tous les tests RAM8 passés !");
        $display("La RAM8 fonctionne parfaitement.");
        $display("- 8 registres indépendants ✓");
        $display("- Adressage correct ✓");
        $display("- Pas d'interférence ✓");
        $display("- Réécriture fonctionnelle ✓");
        $display("");
        $display("🎉 RAM8 COMPLETE !");
        $display("Fondation de la hiérarchie mémoire opérationnelle !");
        
        #10;
        $finish;
    end
    
endmodule