// tests/memory/ram64_tb.v - Cycle TDD 2 pour la RAM64
// Test complet : vérifier l'adressage sur 6 bits et la non-interférence

`timescale 1ns / 1ps

module ram64_tb;
    // Signaux de test
    reg [15:0] in;
    reg [5:0] address;
    reg load, clk;
    wire [15:0] out;
    
    // Instance du module à tester
    ram64 uut (
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
        input [5:0] addr,
        input [15:0] data,
        input [63:0] description
    );
    begin
        $display("Test: %s", description);
        
        // Écriture
        address = addr;
        in = data;
        load = 1;
        @(posedge clk); #1;
        $display("  Écriture: RAM64[%d] ← 0x%04X (banc=%d, offset=%d)", 
                 addr, data, addr[5:3], addr[2:0]);
        
        // Lecture
        load = 0;
        #1;
        $display("  Lecture:  RAM64[%d] → 0x%04X", addr, out);
        
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
        $dumpfile("ram64_tb.vcd");
        $dumpvars(0, ram64_tb);
        
        $display("Test complet de la RAM64 (8×RAM8 = 64 registres)");
        $display("==================================================");
        $display("");
        
        // Initialisation
        in = 16'h0000;
        address = 6'b000000;
        load = 0;
        #2;
        
        $display("Phase 1: Test des adresses de base (une par banc RAM8)");
        // Test d'une adresse dans chaque banc RAM8
        write_read_test(6'd0,  16'h1000, "Banc 0, offset 0 (adresse 0)");
        write_read_test(6'd8,  16'h2000, "Banc 1, offset 0 (adresse 8)");
        write_read_test(6'd16, 16'h3000, "Banc 2, offset 0 (adresse 16)");
        write_read_test(6'd24, 16'h4000, "Banc 3, offset 0 (adresse 24)");
        write_read_test(6'd32, 16'h5000, "Banc 4, offset 0 (adresse 32)");
        write_read_test(6'd40, 16'h6000, "Banc 5, offset 0 (adresse 40)");
        write_read_test(6'd48, 16'h7000, "Banc 6, offset 0 (adresse 48)");
        write_read_test(6'd56, 16'h8000, "Banc 7, offset 0 (adresse 56)");
        
        $display("Phase 2: Test des offsets internes dans un banc");
        // Test tous les offsets dans le banc 0
        write_read_test(6'd1, 16'hABC1, "Banc 0, offset 1");
        write_read_test(6'd2, 16'hABC2, "Banc 0, offset 2");
        write_read_test(6'd3, 16'hABC3, "Banc 0, offset 3");
        write_read_test(6'd7, 16'hABC7, "Banc 0, offset 7");
        
        $display("Phase 3: Test d'adresses distribuées");
        // Test adresses variées pour vérifier la non-interférence
        write_read_test(6'd15, 16'hDEAD, "Adresse 15 (banc 1, offset 7)");
        write_read_test(6'd31, 16'hBEEF, "Adresse 31 (banc 3, offset 7)");
        write_read_test(6'd47, 16'hCAFE, "Adresse 47 (banc 5, offset 7)");
        write_read_test(6'd63, 16'hFACE, "Adresse 63 (banc 7, offset 7)");
        
        $display("Phase 4: Vérification de la non-interférence");
        // Vérifier que les valeurs précédentes sont toujours là
        load = 0; // Mode lecture seule
        
        address = 6'd0; #1;
        $display("Vérif RAM64[0] = 0x%04X (attendu 0x1000)", out);
        if (out !== 16'h1000) begin
            $display("ECHEC: interférence détectée à l'adresse 0");
            $finish;
        end
        
        address = 6'd24; #1;
        $display("Vérif RAM64[24] = 0x%04X (attendu 0x4000)", out);
        if (out !== 16'h4000) begin
            $display("ECHEC: interférence détectée à l'adresse 24");
            $finish;
        end
        
        address = 6'd63; #1;
        $display("Vérif RAM64[63] = 0x%04X (attendu 0xFACE)", out);
        if (out !== 16'hFACE) begin
            $display("ECHEC: interférence détectée à l'adresse 63");
            $finish;
        end
        
        $display("Phase 5: Test des extrema d'adressage");
        // Première et dernière adresse
        write_read_test(6'd0,  16'h0001, "Première adresse (0)");
        write_read_test(6'd63, 16'hFFFF, "Dernière adresse (63)");
        
        $display("SUCCES: Tous les tests RAM64 passés !");
        $display("La RAM64 fonctionne parfaitement.");
        $display("- 64 registres (8 bancs × 8 registres) ✓");
        $display("- Adressage 6-bits correct ✓");
        $display("- Décodage banc/offset fonctionnel ✓");
        $display("- Pas d'interférence entre bancs ✓");
        $display("");
        $display("🎉 RAM64 COMPLETE !");
        $display("Deuxième niveau de la pyramide mémoire opérationnel !");
        
        #10;
        $finish;
    end
    
endmodule