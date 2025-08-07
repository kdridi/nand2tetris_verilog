// tests/memory/memory_tb.v - Unit Test for Complete Hack Memory System with I/O
`timescale 1ns / 1ps

module memory_tb;

    // Test signals
    reg [15:0] data_in;
    reg [14:0] memory_address;
    reg write_enable, clock_signal;
    wire [15:0] data_out;

    // Instance of the module to be tested
    memory uut (
        .in(data_in),
        .address(memory_address),
        .load(write_enable),
        .clk(clock_signal),
        .out(data_out)
    );

    // Constants for test values
    localparam LOGIC_L = 0; // Low logic level
    localparam LOGIC_H = 1; // High logic level
    
    // Memory map constants
    localparam RAM_BASE    = 15'h0000;  // RAM: 0x0000-0x3FFF
    localparam RAM_END     = 15'h3FFF;
    localparam SCREEN_BASE = 15'h4000;  // Screen: 0x4000-0x5FFF
    localparam SCREEN_END  = 15'h5FFF;
    localparam KEYBOARD    = 15'h6000;  // Keyboard: 0x6000

    // Clock generation
    initial begin
        clock_signal = 0;
        forever #5 clock_signal = ~clock_signal; // 10ns period (100MHz)
    end

    // Task to test memory read/write
    task memory_test_rw;
        input [14:0] addr;
        input [15:0] write_data;
        input [15:0] expected_read_data;
        input [120:0] region_name;
        begin
            // Write operation
            memory_address = addr;
            data_in = write_data;
            write_enable = LOGIC_H;
            @(posedge clock_signal); // Write on clock edge
            #1; // Propagation delay
            
            // Read operation  
            write_enable = LOGIC_L;
            #1;
            $display("| 0x%04X | 0x%04X | 0x%04X | %s |", 
                     write_data, addr, data_out, region_name);

            if (data_out !== expected_read_data) begin
                $display("FAILURE: Memory write/read at address 0x%04X expected 0x%04X, obtained 0x%04X", 
                         addr, expected_read_data, data_out);
                $finish;
            end
        end
    endtask

    // Task to test read-only access
    task memory_test_ro;
        input [14:0] addr;
        input [15:0] expected_data;
        input [120:0] region_name;
        begin
            memory_address = addr;
            write_enable = LOGIC_L;
            #1;
            $display("| ------ | 0x%04X | 0x%04X | %s |", 
                     addr, data_out, region_name);

            if (data_out !== expected_data) begin
                $display("FAILURE: Memory read at address 0x%04X expected 0x%04X, obtained 0x%04X", 
                         addr, expected_data, data_out);
                $finish;
            end
        end
    endtask

    // Test complete memory system
    initial begin
        $dumpfile("temp/memory.vcd");
        $dumpvars(0, memory_tb);

        $display("Complete Hack Memory System Test (RAM16K + Screen + Keyboard)");
        $display("+--------+--------+--------+------------------+");
        $display("|  Write | Address|  Read  |     Region       |");
        $display("+--------+--------+--------+------------------+");

        // Initialize
        data_in = 16'h0000;
        memory_address = 15'h0000;
        write_enable = LOGIC_L;
        #2; // Stabilization

        // Test 1: RAM16K region (0x0000-0x3FFF)
        memory_test_rw(15'h0000, 16'h1234, 16'h1234, "RAM Start");
        memory_test_rw(15'h1000, 16'h5678, 16'h5678, "RAM Middle");
        memory_test_rw(15'h3FFF, 16'h9ABC, 16'h9ABC, "RAM End");
        
        // Test 2: Verify RAM data persistence
        memory_test_ro(15'h0000, 16'h1234, "RAM Persistence");
        memory_test_ro(15'h1000, 16'h5678, "RAM Persistence");

        // Test 3: Screen Memory region (0x4000-0x5FFF)  
        memory_test_rw(15'h4000, 16'hF0F0, 16'hF0F0, "Screen Start");
        memory_test_rw(15'h5000, 16'h0F0F, 16'h0F0F, "Screen Middle");
        memory_test_rw(15'h5FFF, 16'hAAAA, 16'hAAAA, "Screen End");

        // Test 4: Verify Screen data persistence
        memory_test_ro(15'h4000, 16'hF0F0, "Screen Persistence");
        memory_test_ro(15'h5FFF, 16'hAAAA, "Screen Persistence");

        // Test 5: Keyboard region (0x6000) - Read-only
        memory_test_ro(15'h6000, 16'h0000, "Keyboard (no key)");
        
        // Test 6: Attempt to write to keyboard (should be ignored)
        memory_address = 15'h6000;
        data_in = 16'hDEAD;
        write_enable = LOGIC_H;
        @(posedge clock_signal);
        #1;
        write_enable = LOGIC_L;
        #1;
        $display("| 0xDEAD | 0x6000 | 0x%04X | Keyboard (write test) |", data_out);
        
        if (data_out !== 16'h0000) begin
            $display("FAILURE: Keyboard should remain 0x0000 after write attempt");
            $finish;
        end

        // Test 7: Address boundary verification
        memory_test_rw(15'h3FFE, 16'h1111, 16'h1111, "RAM Boundary");
        memory_test_rw(15'h4001, 16'h2222, 16'h2222, "Screen Boundary");

        // Test 8: Memory isolation test (ensure regions don't interfere)
        memory_test_rw(15'h2000, 16'hBEEF, 16'hBEEF, "RAM Isolation");
        memory_test_rw(15'h5000, 16'hFACE, 16'hFACE, "Screen Isolation");
        memory_test_ro(15'h2000, 16'hBEEF, "RAM Still Isolated");

        $display("+--------+--------+--------+------------------+");

        $display("");
        $display("SUCCESS: All tests passed!");
        $display("The complete memory system correctly implements:");
        $display("- RAM16K: 16K words main memory (0x0000-0x3FFF)");
        $display("- Screen: 8K words display buffer (0x4000-0x5FFF)");
        $display("- Keyboard: Read-only register (0x6000)");
        $display("- Proper address decoding and memory isolation");
        $display("- Full Hack computer memory architecture");

        #10;
        $finish;
    end

endmodule