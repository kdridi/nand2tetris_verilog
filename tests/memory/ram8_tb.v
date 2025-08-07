// tests/memory/ram8_tb.v - Unit Test for 8-Register RAM with 3-bit Addressing
`timescale 1ns / 1ps

module ram8_tb;

    // Test signals
    reg [15:0] data_in;
    reg [2:0] memory_address;
    reg write_enable, clock_signal;
    wire [15:0] data_out;

    // Instance of the module to be tested
    ram8 uut (
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
    task ram8_write_read_check;
        input [2:0] addr;
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
            $display("| 0x%04X |    %d     | 0x%04X |  Write+Read  |", write_data, addr, data_out);

            if (data_out !== expected_read_data) begin
                $display("FAILURE: RAM8 write/read at address %d expected 0x%04X, obtained 0x%04X", 
                         addr, expected_read_data, data_out);
                $finish;
            end
        end
    endtask

    // Task to test read-only operation
    task ram8_read_check;
        input [2:0] addr;
        input [15:0] expected_data;
        begin
            memory_address = addr;
            write_enable = LOGIC_L;
            #1;
            $display("| ------ |    %d     | 0x%04X |   Read Only  |", addr, data_out);

            if (data_out !== expected_data) begin
                $display("FAILURE: RAM8 read at address %d expected 0x%04X, obtained 0x%04X", 
                         addr, expected_data, data_out);
                $finish;
            end
        end
    endtask

    // Test RAM8 functionality
    initial begin
        $dumpfile("ram8_tb.vcd");
        $dumpvars(0, ram8_tb);

        $display("8-Register RAM with 3-bit Addressing Test");
        $display("+--------+----------+--------+--------------+");
        $display("|   in   | address  |  out   |  Operation   |");
        $display("+--------+----------+--------+--------------+");

        // Initialize
        data_in = 16'h0000;
        memory_address = 3'd0;
        write_enable = LOGIC_L;
        #2; // Stabilization

        // Test 1: Write/read to each address
        ram8_write_read_check(3'd0, 16'h1111, 16'h1111);
        ram8_write_read_check(3'd1, 16'h2222, 16'h2222);
        ram8_write_read_check(3'd2, 16'h3333, 16'h3333);
        ram8_write_read_check(3'd3, 16'h4444, 16'h4444);
        ram8_write_read_check(3'd4, 16'h5555, 16'h5555);
        ram8_write_read_check(3'd5, 16'h6666, 16'h6666);
        ram8_write_read_check(3'd6, 16'h7777, 16'h7777);
        ram8_write_read_check(3'd7, 16'h8888, 16'h8888);

        // Test 2: Verify data integrity (no interference)
        ram8_read_check(3'd0, 16'h1111);
        ram8_read_check(3'd3, 16'h4444);
        ram8_read_check(3'd7, 16'h8888);

        // Test 3: Overwrite test
        ram8_write_read_check(3'd2, 16'hABCD, 16'hABCD);

        // Test 4: Verify other addresses unchanged
        ram8_read_check(3'd1, 16'h2222);
        ram8_read_check(3'd2, 16'hABCD);
        ram8_read_check(3'd3, 16'h4444);

        // Test 5: Boundary value patterns
        ram8_write_read_check(3'd0, 16'h0000, 16'h0000);
        ram8_write_read_check(3'd7, 16'hFFFF, 16'hFFFF);
        ram8_write_read_check(3'd4, 16'hAAAA, 16'hAAAA);
        ram8_write_read_check(3'd5, 16'h5555, 16'h5555);

        // Test 6: Read-only all addresses
        ram8_read_check(3'd0, 16'h0000);
        ram8_read_check(3'd1, 16'h2222);
        ram8_read_check(3'd2, 16'hABCD);
        ram8_read_check(3'd3, 16'h4444);
        ram8_read_check(3'd4, 16'hAAAA);
        ram8_read_check(3'd5, 16'h5555);
        ram8_read_check(3'd6, 16'h7777);
        ram8_read_check(3'd7, 16'hFFFF);

        $display("+--------+----------+--------+--------------+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The 8-register RAM with 3-bit addressing is fully functional.");
        #10;
        $finish;
    end

endmodule