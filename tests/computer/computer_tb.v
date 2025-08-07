// tests/computer/computer_tb.v - Unit Test for Complete Nand2Tetris Computer System
`timescale 1ns / 1ps

module computer_tb;

    // Test signals
    reg clk_signal, reset_signal;
    wire [15:0] pc_out;

    // Instance of the module to be tested
    computer uut (
        .clk(clk_signal),
        .reset(reset_signal),
        .pc_out(pc_out)
    );

    // Constants for test values
    localparam LOGIC_L = 0; // Low logic level
    localparam LOGIC_H = 1; // High logic level

    // Clock generation
    initial begin
        clk_signal = 0;
        forever #5 clk_signal = ~clk_signal; // 10ns period (100MHz)
    end

    // Task to monitor execution cycle
    task computer_monitor_cycle;
        input integer cycle_num;
        begin
            @(posedge clk_signal);
            #1; // Propagation delay
            $display("| %6d | 0x%04X | 0x%04X | 0x%04X | 0x%04X |    %b    |",
                     cycle_num, pc_out, uut.instruction, uut.addressM, uut.outM, uut.writeM);
        end
    endtask

    // Task to check final memory state
    task computer_check_memory;
        input [5:0] addr;
        input [15:0] expected_value;
        begin
            // Force address to read specific memory location
            force uut.data_memory.address = addr;
            #1;
            if (uut.data_memory.out !== expected_value) begin
                $display("FAILURE: Memory[%d] expected 0x%04X, obtained 0x%04X", 
                         addr, expected_value, uut.data_memory.out);
                $finish;
            end
            release uut.data_memory.address;
        end
    endtask

    // Test complete computer execution
    initial begin
        $dumpfile("temp/computer.vcd");
        $dumpvars(0, computer_tb);

        $display("Complete Nand2Tetris Computer System Test");
        $display("Program: Count-down from 10 to 0 with loop");
        $display("+--------+--------+--------+--------+--------+---------+");
        $display("| Cycle  |   PC   | Instr  |  Addr  |  OutM  | WriteM  |");
        $display("+--------+--------+--------+--------+--------+---------+");

        // Initialize program in ROM
        // Simple count-down program: COUNT = 10, loop until COUNT = 0
        uut.rom[0]  = 16'h000A;  // @10         - Load constant 10
        uut.rom[1]  = 16'hEC10;  // D=A         - D = 10
        uut.rom[2]  = 16'h000A;  // @10         - Address for COUNT variable
        uut.rom[3]  = 16'hEC08;  // M=D         - RAM[10] = 10 (initialize)
        uut.rom[4]  = 16'h000A;  // @10         - LOOP: Load COUNT address
        uut.rom[5]  = 16'hFC10;  // D=M         - D = RAM[COUNT]
        uut.rom[6]  = 16'h000C;  // @12         - Load END address
        uut.rom[7]  = 16'hE302;  // D;JEQ       - Jump to END if D==0
        uut.rom[8]  = 16'h000A;  // @10         - Load COUNT address
        uut.rom[9]  = 16'hFC88;  // M=M-1       - RAM[COUNT] = RAM[COUNT] - 1
        uut.rom[10] = 16'h0004;  // @4          - Load LOOP address
        uut.rom[11] = 16'hEA07;  // 0;JMP       - Unconditional jump to LOOP
        uut.rom[12] = 16'h000C;  // @12         - END: Load self address
        uut.rom[13] = 16'hEA07;  // 0;JMP       - Infinite loop

        // Reset computer system
        reset_signal = LOGIC_H;
        @(posedge clk_signal);
        #1;
        $display("| ------ | 0x%04X | ------ | ------ | ------ | ------- |", pc_out);
        
        if (pc_out !== 16'h0000) begin
            $display("FAILURE: PC should be 0x0000 after reset");
            $finish;
        end
        
        reset_signal = LOGIC_L;

        // Execute program: Monitor first few initialization cycles
        computer_monitor_cycle(1);  // @10
        computer_monitor_cycle(2);  // D=A
        computer_monitor_cycle(3);  // @10
        computer_monitor_cycle(4);  // M=D (initialize COUNT=10)

        // Monitor main loop iterations (limited to prevent infinite loop)
        computer_monitor_cycle(5);  // @10 (LOOP start)
        computer_monitor_cycle(6);  // D=M
        computer_monitor_cycle(7);  // @12
        computer_monitor_cycle(8);  // D;JEQ (should not jump, COUNT=10)
        computer_monitor_cycle(9);  // @10
        computer_monitor_cycle(10); // M=M-1 (COUNT becomes 9)
        computer_monitor_cycle(11); // @4
        computer_monitor_cycle(12); // 0;JMP (jump to LOOP)

        // Continue monitoring until count reaches 0 or max cycles
        begin : execution_loop
            integer cycle_count;
            cycle_count = 13;
            
            while (cycle_count < 100) begin
                computer_monitor_cycle(cycle_count);
                
                // Check if we've reached the END state (PC = 12 or 13)
                if (pc_out == 16'd12 || pc_out == 16'd13) begin
                    $display("| ------ | ------ | ------ | ------ | ------ |   END   |");
                    disable execution_loop;
                end
                
                cycle_count = cycle_count + 1;
            end
            
            if (cycle_count >= 100) begin
                $display("FAILURE: Program did not terminate within expected cycles");
                $finish;
            end
        end

        $display("+--------+--------+--------+--------+--------+---------+");

        // Verify final state: COUNT should be 0
        computer_check_memory(6'd10, 16'h0000);

        // Verify PC is in END state
        if (!(pc_out == 16'd12 || pc_out == 16'd13)) begin
            $display("FAILURE: Program counter should be at END state (12 or 13), found %d", pc_out);
            $finish;
        end

        $display("");
        $display("SUCCESS: All tests passed!");
        $display("The complete computer system correctly executed the count-down program:");
        $display("- Instruction fetch from ROM");
        $display("- CPU instruction execution");
        $display("- Data memory read/write operations");
        $display("- Program counter control and jumps");
        $display("- Arithmetic operations and condition testing");

        #10;
        $finish;
    end

endmodule