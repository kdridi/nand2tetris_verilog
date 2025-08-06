// tests/sequential/program_counter_tb.v - Unit Test for 16-bit Program Counter
`timescale 1ns / 1ps

module program_counter_tb;

    // Test signals
    reg [15:0] address_in;
    reg load_enable, increment_enable, reset_enable, clock_signal;
    wire [15:0] pc_out;

    // Instance of the module to be tested
    program_counter uut (
        .in(address_in),
        .load(load_enable),
        .inc(increment_enable),
        .reset(reset_enable),
        .clk(clock_signal),
        .out(pc_out)
    );

    // Constants for test values
    localparam LOGIC_L = 0; // Low logic level
    localparam LOGIC_H = 1; // High logic level

    // Clock generation
    initial begin
        clock_signal = 0;
        forever #5 clock_signal = ~clock_signal; // 10ns period (100MHz)
    end

    // Task to check PC operation
    task pc_operation_check;
        input [15:0] in_val;
        input load_val, inc_val, reset_val;
        input [15:0] expected_out;
        input [88:0] operation_name;
        begin
            address_in = in_val;
            load_enable = load_val;
            increment_enable = inc_val;
            reset_enable = reset_val;
            @(posedge clock_signal); // Wait for positive clock edge
            #1; // Propagation delay
            $display("| 0x%04X |   %b   |   %b   |   %b   | 0x%04X | %s |", 
                     address_in, load_enable, increment_enable, reset_enable, pc_out, operation_name);

            if (pc_out !== expected_out) begin
                $display("FAILURE: PC(in=0x%04X,load=%b,inc=%b,reset=%b) expected 0x%04X, obtained 0x%04X", 
                         address_in, load_enable, increment_enable, reset_enable, expected_out, pc_out);
                $finish;
            end
        end
    endtask

    // Test program counter functionality
    initial begin
        $dumpfile("program_counter_tb.vcd");
        $dumpvars(0, program_counter_tb);

        $display("16-bit Program Counter Test");
        $display("+--------+-------+-------+-------+--------+--------------+");
        $display("|   in   | load  |  inc  | reset |  out   |   Operation  |");
        $display("+--------+-------+-------+-------+--------+--------------+");

        // Initialize
        address_in = 16'h0000;
        load_enable = LOGIC_L;
        increment_enable = LOGIC_L;
        reset_enable = LOGIC_L;
        #2; // Stabilization

        // Test 1: Reset operation (highest priority)
        pc_operation_check(16'h0000, LOGIC_L, LOGIC_L, LOGIC_H, 16'h0000, "Reset");

        // Test 2: Increment from 0
        pc_operation_check(16'h0000, LOGIC_L, LOGIC_H, LOGIC_L, 16'h0001, "Inc 0->1");

        // Test 3: Continue incrementing
        pc_operation_check(16'h0000, LOGIC_L, LOGIC_H, LOGIC_L, 16'h0002, "Inc 1->2");
        pc_operation_check(16'h0000, LOGIC_L, LOGIC_H, LOGIC_L, 16'h0003, "Inc 2->3");

        // Test 4: Load operation
        pc_operation_check(16'h1234, LOGIC_H, LOGIC_L, LOGIC_L, 16'h1234, "Load 0x1234");

        // Test 5: Hold operation
        pc_operation_check(16'h5678, LOGIC_L, LOGIC_L, LOGIC_L, 16'h1234, "Hold");

        // Test 6: Increment from loaded value
        pc_operation_check(16'h0000, LOGIC_L, LOGIC_H, LOGIC_L, 16'h1235, "Inc loaded");

        // Test 7: Priority test - load over inc
        pc_operation_check(16'h5678, LOGIC_H, LOGIC_H, LOGIC_L, 16'h5678, "Load>Inc");

        // Test 8: Priority test - reset over all
        pc_operation_check(16'hABCD, LOGIC_H, LOGIC_H, LOGIC_H, 16'h0000, "Reset>All");

        // Test 9: Overflow test
        pc_operation_check(16'hFFFF, LOGIC_H, LOGIC_L, LOGIC_L, 16'hFFFF, "Load 0xFFFF");
        pc_operation_check(16'h0000, LOGIC_L, LOGIC_H, LOGIC_L, 16'h0000, "Overflow");

        $display("+--------+-------+-------+-------+--------+--------------+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The 16-bit program counter is fully functional.");
        #10;
        $finish;
    end

endmodule