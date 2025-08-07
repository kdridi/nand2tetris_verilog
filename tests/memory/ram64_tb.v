// tests/memory/ram64_tb.v - Unit Test for 64-Register RAM with 6-bit Addressing
`timescale 1ns / 1ps

module ram64_tb;

    // Test signals
    reg [15:0] data_in;
    reg [5:0] memory_address;
    reg write_enable, clock_signal;
    wire [15:0] data_out;

    // Instance of the module to be tested
    ram64 uut (
        .in(data_in),
        .address(memory_address),
        .load(write_enable),
        .clk(clock_signal),
        .out(data_out)
    );

    // Constants for test values
    localparam LOGIC_L = 0; // Low logic level
    localparam LOGIC_H = 1; // High logic level

    // Clock generation
    initial begin
        clock_signal = 0;
        forever #5 clock_signal = ~clock_signal; // 10ns period (100MHz)
    end

    // Task to test write/read operation
    task ram64_write_read_check;
        input [5:0] addr;
        input [15:0] write_data;
        input [15:0] expected_read_data;
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
            $display("| 0x%04X |  0x%04X | 0x%04X |  Write+Read  |", 
                     write_data, addr, data_out);

            if (data_out !== expected_read_data) begin
                $display("FAILURE: RAM64 write/read at address %d expected 0x%04X, obtained 0x%04X", 
                         addr, expected_read_data, data_out);
                $finish;
            end
        end
    endtask

    // Task to test read-only operation
    task ram64_read_check;
        input [5:0] addr;
        input [15:0] expected_data;
        begin
            memory_address = addr;
            write_enable = LOGIC_L;
            #1;
            $display("| ------ |  0x%04X | 0x%04X |   Read Only  |", 
                     addr, data_out);

            if (data_out !== expected_data) begin
                $display("FAILURE: RAM64 read at address %d expected 0x%04X, obtained 0x%04X", 
                         addr, expected_data, data_out);
                $finish;
            end
        end
    endtask

    // Test RAM64 functionality
    initial begin
        $dumpfile("ram64_tb.vcd");
        // $dumpvars(0, ram64_tb);

        $display("64-Register RAM with 6-bit Addressing Test");
        $display("+--------+---------+--------+--------------+");
        $display("|   in   | address |  out   |  Operation   |");
        $display("+--------+---------+--------+--------------+");

        // Initialize
        data_in = 16'h0000;
        memory_address = 6'd0;
        write_enable = LOGIC_L;
        #2; // Stabilization

        // Test 1: Write/read to one address per bank (8 banks × 1 address)
        ram64_write_read_check(6'd0,  16'h1000, 16'h1000);  // Bank 0, Word 0
        ram64_write_read_check(6'd8,  16'h2000, 16'h2000);  // Bank 1, Word 0
        ram64_write_read_check(6'd16, 16'h3000, 16'h3000);  // Bank 2, Word 0
        ram64_write_read_check(6'd24, 16'h4000, 16'h4000);  // Bank 3, Word 0
        ram64_write_read_check(6'd32, 16'h5000, 16'h5000);  // Bank 4, Word 0
        ram64_write_read_check(6'd40, 16'h6000, 16'h6000);  // Bank 5, Word 0
        ram64_write_read_check(6'd48, 16'h7000, 16'h7000);  // Bank 6, Word 0
        ram64_write_read_check(6'd56, 16'h8000, 16'h8000);  // Bank 7, Word 0

        // Test 2: Test different word addresses within same bank (Bank 0)
        ram64_write_read_check(6'd1, 16'hABC1, 16'hABC1);   // Bank 0, Word 1
        ram64_write_read_check(6'd2, 16'hABC2, 16'hABC2);   // Bank 0, Word 2
        ram64_write_read_check(6'd7, 16'hABC7, 16'hABC7);   // Bank 0, Word 7

        // Test 3: Distributed addresses across different banks
        ram64_write_read_check(6'd15, 16'hDEAD, 16'hDEAD);  // Bank 1, Word 7
        ram64_write_read_check(6'd31, 16'hBEEF, 16'hBEEF);  // Bank 3, Word 7
        ram64_write_read_check(6'd63, 16'hFACE, 16'hFACE);  // Bank 7, Word 7

        // Test 4: Verify data integrity (no interference between banks)
        ram64_read_check(6'd0,  16'h1000);  // Bank 0, Word 0
        ram64_read_check(6'd24, 16'h4000);  // Bank 3, Word 0
        ram64_read_check(6'd56, 16'h8000);  // Bank 7, Word 0

        // Test 5: Boundary addresses
        ram64_write_read_check(6'd0,  16'h0001, 16'h0001);  // First address
        ram64_write_read_check(6'd63, 16'hFFFF, 16'hFFFF);  // Last address

        // Test 6: Pattern tests
        ram64_write_read_check(6'd10, 16'hAAAA, 16'hAAAA);  // Alternating bits
        ram64_write_read_check(6'd53, 16'h5555, 16'h5555);  // Alternating bits

        $display("+--------+---------+--------+--------------+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The 64-register RAM with 6-bit addressing is fully functional.");
        #10;
        $finish;
    end

endmodule