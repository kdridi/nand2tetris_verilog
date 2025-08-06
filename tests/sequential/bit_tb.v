// tests/sequential/bit_tb.v - Unit Test for 1-bit Register with Load Control
`timescale 1ns / 1ps

module bit_tb;

    // Test signals
    reg data_in, load_enable, clock_signal;
    wire data_out;

    // Instance of the module to be tested
    bit uut (
        .in(data_in),
        .load(load_enable),
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

    // Task to check bit register load operation
    task bit_load_check;
        input in_val, load_val;
        input expected_out;
        begin
            data_in = in_val;
            load_enable = load_val;
            @(posedge clock_signal); // Wait for positive clock edge
            #1; // Propagation delay
            $display("|   %b   |   %b   |   %b   |   Load   |", data_in, load_enable, data_out);

            if (data_out !== expected_out) begin
                $display("FAILURE: Bit(in=%b,load=%b) expected out=%b, obtained out=%b", 
                         data_in, load_enable, expected_out, data_out);
                $finish;
            end
        end
    endtask

    // Task to check bit register memory behavior (load=0)
    task bit_memory_check;
        input in_val;
        input expected_out;
        begin
            data_in = in_val;
            load_enable = LOGIC_L; // Disable load
            @(posedge clock_signal);
            #1;
            $display("|   %b   |   %b   |   %b   |  Memory  |", data_in, load_enable, data_out);

            if (data_out !== expected_out) begin
                $display("FAILURE: Bit memory should maintain out=%b, obtained out=%b", 
                         expected_out, data_out);
                $finish;
            end
        end
    endtask

    // Test 1-bit register functionality
    initial begin
        $dumpfile("bit_tb.vcd");
        $dumpvars(0, bit_tb);

        $display("1-bit Register with Load Control Test");
        $display("+-------+-------+-------+----------+");
        $display("|  in   | load  |  out  | Operation|");
        $display("+-------+-------+-------+----------+");

        // Initialize
        data_in = LOGIC_L;
        load_enable = LOGIC_L;
        #2; // Stabilization

        // Test 1: Load HIGH value
        bit_load_check(LOGIC_H, LOGIC_H, LOGIC_H);

        // Test 2: Memory behavior - input changes but load=0
        bit_memory_check(LOGIC_L, LOGIC_H); // Should maintain HIGH

        // Test 3: Load LOW value
        bit_load_check(LOGIC_L, LOGIC_H, LOGIC_L);

        // Test 4: Memory behavior - input changes but load=0
        bit_memory_check(LOGIC_H, LOGIC_L); // Should maintain LOW

        // Test 5: Load sequence - alternating operations
        bit_load_check(LOGIC_H, LOGIC_H, LOGIC_H);  // Load HIGH
        bit_memory_check(LOGIC_L, LOGIC_H);         // Memory HIGH
        bit_load_check(LOGIC_L, LOGIC_H, LOGIC_L);  // Load LOW

        $display("+-------+-------+-------+----------+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The 1-bit register with load control is fully functional.");
        #10;
        $finish;
    end

endmodule