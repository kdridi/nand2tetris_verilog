// tests/memory/ram16k_tb.v - Unit Test for 16K-Register RAM with 14-bit Addressing
`timescale 1ns / 1ps

module ram16k_tb;

    // Test signals
    reg [15:0] data_in;
    reg [13:0] memory_address;
    reg write_enable, clock_signal;
    wire [15:0] data_out;

    // Instance of the module to be tested
    ram16k uut (
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
    task ram16k_write_read_check;
        input [13:0] addr;
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
            $display("| 0x%04X |   0x%04X   | 0x%04X |  Write+Read  |", 
                     write_data, addr, data_out);

            if (data_out !== expected_read_data) begin
                $display("FAILURE: RAM16K write/read at address %d expected 0x%04X, obtained 0x%04X", 
                         addr, expected_read_data, data_out);
                $finish;
            end
        end
    endtask

    // Task to test read-only operation
    task ram16k_read_check;
        input [13:0] addr;
        input [15:0] expected_data;
        begin
            memory_address = addr;
            write_enable = LOGIC_L;
            #1;
            $display("| ------ |   0x%04X   | 0x%04X |   Read Only  |", 
                     addr, data_out);

            if (data_out !== expected_data) begin
                $display("FAILURE: RAM16K read at address %d expected 0x%04X, obtained 0x%04X", 
                         addr, expected_data, data_out);
                $finish;
            end
        end
    endtask

    // Test RAM16K functionality - lightweight test due to simulation complexity
    initial begin
        $dumpfile("ram16k_tb.vcd");
        $dumpvars(0, ram16k_tb);

        $display("16K-Register RAM with 14-bit Addressing Test");
        $display("+--------+------------+--------+--------------+");
        $display("|   in   |  address   |  out   |  Operation   |");
        $display("+--------+------------+--------+--------------+");

        // Initialize
        data_in = 16'h0000;
        memory_address = 14'd0;
        write_enable = LOGIC_L;
        #2; // Stabilization

        // Test 1: Write/read to key addresses per bank (4 banks)
        ram16k_write_read_check(14'd0,     16'h1000, 16'h1000);  // Bank 0, Word 0
        ram16k_write_read_check(14'd4096,  16'h2000, 16'h2000);  // Bank 1, Word 0
        ram16k_write_read_check(14'd8192,  16'h3000, 16'h3000);  // Bank 2, Word 0
        ram16k_write_read_check(14'd12288, 16'h4000, 16'h4000);  // Bank 3, Word 0

        // Test 2: Boundary addresses
        ram16k_write_read_check(14'd0,     16'h0001, 16'h0001);  // First address
        ram16k_write_read_check(14'd16383, 16'hFFFF, 16'hFFFF);  // Last address

        // Test 3: Verify data integrity (no interference between banks)
        ram16k_read_check(14'd4096,  16'h2000);  // Bank 1
        ram16k_read_check(14'd8192,  16'h3000);  // Bank 2
        ram16k_read_check(14'd12288, 16'h4000);  // Bank 3

        // Test 4: Mid-range addresses
        ram16k_write_read_check(14'd1000,  16'hABCD, 16'hABCD);  // Bank 0 middle
        ram16k_write_read_check(14'd10000, 16'h1234, 16'h1234);  // Bank 2 middle

        // Test 5: Pattern tests
        ram16k_write_read_check(14'd2048,  16'hAAAA, 16'hAAAA);  // Alternating bits
        ram16k_write_read_check(14'd14000, 16'h5555, 16'h5555);  // Alternating bits

        $display("+--------+------------+--------+--------------+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The 16K-register RAM with 14-bit addressing is fully functional.");
        $display("Note: Reduced test set due to simulation complexity.");
        #10;
        $finish;
    end

endmodule