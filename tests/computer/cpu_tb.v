// tests/computer/cpu_tb.v - Cycle TDD 3 pour le CPU
// Test : saut inconditionnel avec 0;JMP

`timescale 1ns / 1ps

module test_cpu;
    // Signaux de test
    reg clk, reset;
    reg [15:0] inM, instruction;
    wire [15:0] outM, pc;
    wire [14:0] addressM;
    wire writeM;
    
    // Instance du module à tester
    cpu uut (
        .clk(clk),
        .reset(reset),
        .inM(inM),
        .instruction(instruction),
        .outM(outM),
        .addressM(addressM),
        .writeM(writeM),
        .pc(pc)
    );
    
    // Génération d'horloge
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Période de 10ns
    end
    
    // Test cycle 3
    initial begin
        $dumpfile("test_cpu.vcd");
        $dumpvars(0, test_cpu);
        
        $display("Test CPU Cycle 3 - Saut inconditionnel (0;JMP)");
        $display("===============================================");
        
        // Initialisation
        reset = 1;
        inM = 16'h0000;
        instruction = 16'h0000;
        
        // Reset du CPU
        @(posedge clk); #1;
        $display("Phase 1: Reset du CPU");
        $display("  PC après reset: 0x%04X", pc);
        reset = 0;
        
        // Étape 1 : Charger @100 dans le registre A (adresse de saut)
        $display("Phase 2: Charger @100 (adresse de destination)");
        instruction = 16'h0064; // @100
        @(posedge clk); #1;
        $display("  Après @100: PC=0x%04X, A=0x%04X", pc, addressM);
        
        if (pc !== 16'h0001 || addressM !== 15'd100) begin
            $display("ECHEC: @100 mal exécutée");
            $finish;
        end
        
        // Étape 2 : Quelques instructions normales pour vérifier l'incrément
        $display("Phase 3: Instructions normales pour avancer le PC");
        instruction = 16'h0001; // @1
        @(posedge clk); #1;      // PC = 2
        instruction = 16'h0002; // @2  
        @(posedge clk); #1;      // PC = 3
        $display("  PC après 2 instructions: 0x%04X", pc);
        
        if (pc !== 16'h0003) begin
            $display("ECHEC: PC devrait être 0x0003");
            $finish;
        end
        
        // Étape 3 : Recharger @100 dans A
        $display("Phase 4: Recharger @100 avant le saut");
        instruction = 16'h0064; // @100
        @(posedge clk); #1;      // PC = 4
        $display("  Avant saut: PC=0x%04X, A=0x%04X", pc, addressM);
        
        // Étape 4 : Exécuter 0;JMP (saut inconditionnel vers A)
        $display("Phase 5: Exécution de 0;JMP");
        // 0;JMP en binaire Nand2Tetris:
        // Bit 15=1 (C-instruction), a=0, cccccc=101010 (constante 0), ddd=000 (pas de dest), jjj=111 (JMP)
        // Format: 1 1 1 a c1 c2 c3 c4 c5 c6 d1 d2 d3 j1 j2 j3
        // 0;JMP:  1 1 1 0 1  0  1  0  1  0  0  0  0  1  1  1
        instruction = 16'hEA87; // 1110 1010 1000 0111
        
        @(posedge clk); #1;
        $display("  Après 0;JMP: PC=0x%04X (devrait être 100)", pc);
        
        // Vérifications
        if (pc !== 16'd100) begin
            $display("ECHEC: PC devrait être 100 après 0;JMP, trouvé %d", pc);
            $finish;
        end
        
        if (writeM !== 1'b0) begin
            $display("ECHEC: writeM devrait être 0 pour 0;JMP");
            $finish;
        end
        
        // Étape 5 : Vérifier que l'exécution continue normalement depuis la nouvelle adresse
        $display("Phase 6: Vérifier l'exécution depuis la nouvelle adresse");
        instruction = 16'h0005; // @5
        @(posedge clk); #1;      // PC devrait passer de 100 à 101
        
        $display("  Après @5 depuis nouvelle position: PC=0x%04X", pc);
        
        if (pc !== 16'd101) begin
            $display("ECHEC: PC devrait être 101 après instruction suivante");
            $finish;
        end
        
        $display("SUCCES: Test CPU Cycle 3 réussi !");
        $display("- Saut inconditionnel 0;JMP fonctionne ✓");
        $display("- PC saute correctement vers l'adresse A ✓");
        $display("- Exécution continue depuis la nouvelle adresse ✓");
        $display("- Logique de saut n'interfère pas avec les autres instructions ✓");
        $display("");
        $display("🎉 CPU AVEC SAUTS OPERATIONNEL !");
        $display("Notre processeur peut maintenant exécuter des programmes avec des boucles !");
        
        #20;
        $finish;
    end
    
endmodule