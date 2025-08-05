// test_computer.v - Test programme complet "Hello CPU"
// Programme : compteur de 10 à 0 avec boucle et RAM

`timescale 1ns / 1ps

module test_computer;
    // Signaux système
    reg clk, reset;
    
    // Signaux CPU
    wire [15:0] cpu_outM, cpu_pc;
    wire [14:0] cpu_addressM;
    wire cpu_writeM;
    wire [15:0] cpu_inM;
    wire [15:0] instruction;
    
    // ROM (programme en mémoire)
    reg [15:0] rom [0:15]; // 16 instructions max
    
    // Instance CPU
    cpu cpu_core (
        .clk(clk),
        .reset(reset),
        .inM(cpu_inM),
        .instruction(instruction),
        .outM(cpu_outM),
        .addressM(cpu_addressM),
        .writeM(cpu_writeM),
        .pc(cpu_pc)
    );
    
    // Instance RAM64 comme mémoire de données
    ram64 data_memory (
        .in(cpu_outM),
        .address(cpu_addressM[5:0]), // Utilise seulement 6 bits pour RAM64
        .load(cpu_writeM),
        .clk(clk),
        .out(cpu_inM)
    );
    
    // Lecture ROM : instruction = rom[pc]
    assign instruction = (cpu_pc < 16) ? rom[cpu_pc] : 16'h0000;
    
    // Génération d'horloge
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Période de 10ns
    end
    
    // Programme "Hello CPU" - Compteur de 10 à 0
    initial begin
        // Initialisation de la ROM avec le programme
        // Adresse COUNT = 10
        
        // 0: @10        // Charge la constante 10
        rom[0] = 16'h000A;
        // 1: D=A        // D = 10
        rom[1] = 16'hEC10;
        // 2: @10        // Adresse où stocker (COUNT = adresse 10)
        rom[2] = 16'h000A;
        // 3: M=D        // RAM[10] = 10 (initialise le compteur)
        rom[3] = 16'hEC08;
        
        // LOOP (adresse 4):
        // 4: @10        // Adresse COUNT
        rom[4] = 16'h000A;
        // 5: D=M        // D = RAM[COUNT] (lit le compteur)
        rom[5] = 16'hFC10;
        // 6: @12        // Adresse END
        rom[6] = 16'h000C;
        // 7: D;JEQ      // Si D==0, sauter à END
        rom[7] = 16'hE302;
        
        // 8: @10        // Adresse COUNT
        rom[8] = 16'h000A;
        // 9: M=M-1      // RAM[COUNT] = RAM[COUNT] - 1
        rom[9] = 16'hFC82;
        // 10: @4        // Adresse LOOP
        rom[10] = 16'h0004;
        // 11: 0;JMP     // Saut inconditionnel vers LOOP
        rom[11] = 16'hEA87;
        
        // END (adresse 12):
        // 12: @12       // Boucle infinie sur place
        rom[12] = 16'h000C;
        // 13: 0;JMP
        rom[13] = 16'hEA87;
        
        // Remplir le reste avec des NOPs
        rom[14] = 16'h0000;
        rom[15] = 16'h0000;
    end
    
    // Variables pour le monitoring
    integer iteration;
    integer last_count;
    integer cycles;
    
    // Test et monitoring
    initial begin
        $dumpfile("test_computer.vcd");
        $dumpvars(0, test_computer);
        
        $display("=== PROGRAMME HELLO CPU ===");
        $display("Compteur de 10 à 0 avec boucle");
        $display("===============================");
        
        // Reset système
        reset = 1;
        @(posedge clk); #1;
        $display("Reset: PC=0x%04X", cpu_pc);
        reset = 0;
        
        // Monitoring des premières instructions
        $display("\nPhase d'initialisation:");
        repeat(4) begin
            @(posedge clk); #1;
            $display("PC=0x%04X, Instr=0x%04X, A=0x%04X, writeM=%b", 
                     cpu_pc, instruction, cpu_addressM, cpu_writeM);
            if (cpu_writeM) begin
                $display("  -> Écriture RAM[%d] = %d", cpu_addressM, cpu_outM);
            end
        end
        
        // Vérifier l'initialisation
        if (data_memory.out !== 16'd10) begin
            // Forcer la lecture à l'adresse 10
            force data_memory.address = 6'd10;
            #1;
            if (data_memory.out !== 16'd10) begin
                $display("ERREUR: RAM[10] devrait être 10, trouvé %d", data_memory.out);
                $finish;
            end
            release data_memory.address;
        end
        
        $display("\nDébut de la boucle de décompte:");
        $display("Compteur initial: 10");
        
        // Suivre les itérations de la boucle
        iteration = 0;
        last_count = 10;
        cycles = 0;
        
        begin : main_loop
        while (iteration < 12 && cycles < 200) begin // Protection anti-boucle infinie
            @(posedge clk); #1;
            cycles = cycles + 1;
            
            // Détecter quand on lit le compteur (PC=5, instruction @10 puis D=M)
            if (cpu_pc == 16'd5) begin
                @(posedge clk); #1; cycles = cycles + 1; // Exécuter D=M
                
                // Observer la valeur dans D (on peut l'inférer du comportement suivant)
                // Attendre le test JEQ
                @(posedge clk); #1; cycles = cycles + 1; // @12
                @(posedge clk); #1; cycles = cycles + 1; // D;JEQ
                
                if (cpu_pc == 16'd12) begin
                    // Saut vers END, le compteur était à 0
                    $display("Itération %d: Compteur = 0 -> FIN", iteration + 1);
                    disable main_loop;
                end else begin
                    // Pas de saut, décrémenter
                    iteration = iteration + 1;
                    $display("Itération %d: Compteur = %d", iteration, last_count - iteration);
                end
            end
        end
        end
        
        if (cycles >= 200) begin
            $display("ERREUR: Trop de cycles, possible boucle infinie");
            $finish;
        end
        
        // Vérifications finales
        $display("\nVérifications finales:");
        $display("PC final: 0x%04X (devrait être 12 ou 13)", cpu_pc);
        
        // Lire RAM[10] pour vérifier qu'elle vaut 0
        force data_memory.address = 6'd10;
        #1;
        $display("RAM[10] final: %d (devrait être 0)", data_memory.out);
        
        if (data_memory.out !== 16'd0) begin
            $display("ERREUR: Le compteur final devrait être 0");
            $finish;
        end
        
        release data_memory.address;
        
        $display("\n🎉 SUCCES TOTAL !");
        $display("Notre CPU a exécuté un programme complet avec:");
        $display("- Initialisation de variables ✓");
        $display("- Boucle avec condition ✓");
        $display("- Arithmétique (décrémentation) ✓");
        $display("- Accès mémoire lecture/écriture ✓");
        $display("- Sauts conditionnels et inconditionnels ✓");
        $display("");
        $display("🚀 NOTRE PROCESSEUR NAND2TETRIS EST VIVANT !");
        
        #50;
        $finish;
    end
    
endmodule