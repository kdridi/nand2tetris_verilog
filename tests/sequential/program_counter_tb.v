// tests/sequential/program_counter_tb.v - Cycle TDD 2 pour le Program Counter
// Test complet : vérifier reset, load, inc et les priorités

`timescale 1ns / 1ps

module test_pc;
    // Signaux de test
    reg [15:0] in;
    reg load, inc, reset, clk;
    wire [15:0] out;
    
    // Instance du module à tester
    program_counter uut (
        .in(in),
        .load(load),
        .inc(inc),
        .reset(reset),
        .clk(clk),
        .out(out)
    );
    
    // Génération d'horloge
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Période de 10ns
    end
    
    // Test complet
    initial begin
        $dumpfile("test_pc.vcd");
        $dumpvars(0, test_pc);
        
        $display("Test complet du Program Counter");
        $display("================================");
        
        // Initialisation
        in = 16'h0000;
        load = 0;
        inc = 0;
        reset = 0;
        #2;
        
        $display("Phase 1: Reset initial");
        // Test 1: Reset
        reset = 1;
        @(posedge clk); #1;
        $display("  Reset: out=0x%04X", out);
        if (out !== 16'h0000) begin
            $display("ECHEC: reset devrait donner 0x0000");
            $finish;
        end
        
        $display("Phase 2: Incrémentation");
        // Test 2: Incrémenter depuis 0
        reset = 0;
        inc = 1;
        @(posedge clk); #1;
        $display("  Inc 0→1: out=0x%04X", out);
        if (out !== 16'h0001) begin
            $display("ECHEC: inc devrait donner 0x0001");
            $finish;
        end
        
        // Test 3: Continuer à incrémenter  
        @(posedge clk); #1;
        $display("  Inc 1→2: out=0x%04X", out);
        if (out !== 16'h0002) begin
            $display("ECHEC: inc devrait donner 0x0002");
            $finish;
        end
        
        @(posedge clk); #1;
        $display("  Inc 2→3: out=0x%04X", out);
        if (out !== 16'h0003) begin
            $display("ECHEC: inc devrait donner 0x0003");
            $finish;
        end
        
        $display("Phase 3: Chargement (load)");
        // Test 4: Load une valeur
        inc = 0;
        load = 1;
        in = 16'h1234;
        @(posedge clk); #1;
        $display("  Load 0x1234: out=0x%04X", out);
        if (out !== 16'h1234) begin
            $display("ECHEC: load devrait donner 0x1234");
            $finish;
        end
        
        $display("Phase 4: Conservation (hold)");
        // Test 5: Ne rien faire (hold)
        load = 0;
        inc = 0;
        @(posedge clk); #1;
        $display("  Hold: out=0x%04X", out);
        if (out !== 16'h1234) begin
            $display("ECHEC: hold devrait conserver 0x1234");
            $finish;
        end
        
        $display("Phase 5: Incrémentation depuis valeur chargée");
        // Test 6: Incrémenter depuis 0x1234
        inc = 1;
        @(posedge clk); #1;
        $display("  Inc 0x1234→0x1235: out=0x%04X", out);
        if (out !== 16'h1235) begin
            $display("ECHEC: inc devrait donner 0x1235");
            $finish;
        end
        
        $display("Phase 6: Test des priorités");
        // Test 7: load ET inc → load gagne
        load = 1;
        inc = 1;
        in = 16'h5678;
        @(posedge clk); #1;
        $display("  Load+Inc (load gagne): out=0x%04X", out);
        if (out !== 16'h5678) begin
            $display("ECHEC: load devrait avoir priorité sur inc");
            $finish;
        end
        
        // Test 8: reset ET load ET inc → reset gagne
        reset = 1;
        load = 1;
        inc = 1;
        in = 16'hABCD;
        @(posedge clk); #1;
        $display("  Reset+Load+Inc (reset gagne): out=0x%04X", out);
        if (out !== 16'h0000) begin
            $display("ECHEC: reset devrait avoir priorité absolue");
            $finish;
        end
        
        $display("Phase 7: Débordement");
        // Test 9: Débordement 16-bits
        reset = 0;
        load = 1;
        inc = 0;
        in = 16'hFFFF;
        @(posedge clk); #1;
        load = 0;
        inc = 1;
        @(posedge clk); #1;
        $display("  Débordement 0xFFFF→0x0000: out=0x%04X", out);
        if (out !== 16'h0000) begin
            $display("ECHEC: débordement devrait donner 0x0000");
            $finish;
        end
        
        $display("");
        $display("SUCCES: Tous les tests Program Counter passés !");
        $display("Le PC fonctionne parfaitement.");
        $display("");
        $display("🎉 PROGRAM COUNTER COMPLETE !");
        $display("Le chef d'orchestre des instructions est opérationnel !");
        
        #10;
        $finish;
    end
    
endmodule