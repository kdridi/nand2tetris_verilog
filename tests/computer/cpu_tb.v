// tests/computer/cpu_tb.v - Unit Test for Nand2Tetris CPU Implementation
`timescale 1ns / 1ps

module cpu_tb;

    // Test signals
    reg clock_signal, reset_signal;
    reg [15:0] data_from_memory, current_instruction;
    wire [15:0] data_to_memory, program_counter;
    wire [14:0] memory_address;
    wire memory_write_enable;
    
    // Instance of the module to be tested
    cpu uut (
        .clk(clock_signal),
        .reset(reset_signal),
        .inM(data_from_memory),
        .instruction(current_instruction),
        .outM(data_to_memory),
        .addressM(memory_address),
        .writeM(memory_write_enable),
        .pc(program_counter)
    );

    // Constants for test values
    localparam LOGIC_L = 0; // Low logic level
    localparam LOGIC_H = 1; // High logic level
    
    // Clock generation
    initial begin
        clock_signal = 0;
        forever #5 clock_signal = ~clock_signal; // 10ns period (100MHz)
    end

    // Task to execute instruction and check results
    task cpu_execute_instruction;
        input [15:0] instruction;
        input [15:0] expected_pc;
        input [14:0] expected_address;
        input expected_write;
        input [120:0] test_name;
        begin
            current_instruction = instruction;
            @(posedge clock_signal); 
            #1; // Propagation delay
            
            $display("| 0x%04X | 0x%04X | 0x%04X |   %b     | %s |", 
                     instruction, program_counter, memory_address, memory_write_enable, test_name);

            if (program_counter !== expected_pc) begin
                $display("FAILURE: PC expected 0x%04X, obtained 0x%04X", expected_pc, program_counter);
                $finish;
            end
            
            if (memory_address !== expected_address) begin
                $display("FAILURE: Address expected 0x%04X, obtained 0x%04X", expected_address, memory_address);
                $finish;
            end
            
            if (memory_write_enable !== expected_write) begin
                $display("FAILURE: WriteM expected %b, obtained %b", expected_write, memory_write_enable);
                $finish;
            end
        end
    endtask
    
    // Test CPU functionality with jump instructions
    initial begin
        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, cpu_tb);

        $display("Nand2Tetris CPU with Jump Instructions Test");
        $display("+--------+--------+--------+---------+------------------+");
        $display("| Instr  |   PC   |  Addr  | WriteM  |    Test          |");
        $display("+--------+--------+--------+---------+------------------+");

        // Initialize
        reset_signal = LOGIC_H;
        data_from_memory = 16'h0000;
        current_instruction = 16'h0000;
        
        // Reset CPU
        @(posedge clock_signal); 
        #1;
        $display("| ------ | 0x%04X | 0x%04X |   %b     |            Reset |", 
                 program_counter, memory_address, memory_write_enable);
        
        if (program_counter !== 16'h0000) begin
            $display("FAILURE: PC should be 0x0000 after reset");
            $finish;
        end
        
        reset_signal = LOGIC_L;

        // Test 1: A-instruction - Load immediate value into A register
        cpu_execute_instruction(16'h0064, 16'h0001, 15'd100, LOGIC_L, "A-instruction");
        
        // Test 2: Another A-instruction to advance PC
        cpu_execute_instruction(16'h0001, 16'h0002, 15'd1, LOGIC_L, "A-instruction");
        
        // Test 3: Another A-instruction to advance PC
        cpu_execute_instruction(16'h0002, 16'h0003, 15'd2, LOGIC_L, "A-instruction");
        
        // Test 4: Reload target address before jump
        cpu_execute_instruction(16'h0064, 16'h0004, 15'd100, LOGIC_L, "A-instruction");
        
        // Test 5: Unconditional jump (0;JMP)
        // Binary encoding: 1110101000000111 (0xEA07)
        // Format: 111a cccccc ddd jjj
        // 0;JMP:  1110 101010 000 111
        cpu_execute_instruction(16'hEA07, 16'd100, 15'd100, LOGIC_L, "Jump (0;JMP)");
        
        // Test 6: Continue execution from new address
        cpu_execute_instruction(16'h0005, 16'd101, 15'd5, LOGIC_L, "A-instruction");

        // Test 7: C-instruction with memory write (M=1)
        // Binary encoding: 1110111111001000 (0xEFC8)
        // Format: 111a cccccc ddd jjj
        // M=1:    1110 111111 001 000 (a=0, comp=111111 for constant 1, dest=001 for M)
        cpu_execute_instruction(16'hEFC8, 16'd102, 15'd5, LOGIC_H, "Memory write");

        $display("+--------+--------+--------+---------+------------------+");
        
        $display("");
        $display("SUCCESS: All tests passed!");
        $display("The CPU correctly executes:");
        $display("- A-type instructions (immediate load)");
        $display("- C-type instructions with memory operations");
        $display("- Jump instructions with proper PC control");
        $display("- Program counter increment and jump logic");
        
        #10;
        $finish;
    end

endmodule