// tests/sequential/register16_tb.v - Unit Test for 16-bit Register with Load Control
`timescale 1ns / 1ps

module register16_tb;

    // Test signals
    reg [15:0] data_in;
    reg load_enable, clock_signal;
    wire [15:0] data_out;

    // Instance of the module to be tested
    register16 uut (
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

    // Task to check register16 load operation
    task register16_load_check;
        input [15:0] in_val;
        input load_val;
        input [15:0] expected_out;
        begin
            data_in = in_val;
            load_enable = load_val;
            @(posedge clock_signal); // Wait for positive clock edge
            #1; // Propagation delay
            $display("| 0x%04X |   %b   | 0x%04X |   Load   |", data_in, load_enable, data_out);

            if (data_out !== expected_out) begin
                $display("FAILURE: Register16(in=0x%04X,load=%b) expected out=0x%04X, obtained out=0x%04X", 
                         data_in, load_enable, expected_out, data_out);
                $finish;
            end
        end
    endtask

    // Task to check register16 memory behavior (load=0)
    task register16_memory_check;
        input [15:0] in_val;
        input [15:0] expected_out;
        begin
            data_in = in_val;
            load_enable = LOGIC_L; // Disable load
            @(posedge clock_signal);
            #1;
            $display("| 0x%04X |   %b   | 0x%04X |  Memory  |", data_in, load_enable, data_out);

            if (data_out !== expected_out) begin
                $display("FAILURE: Register16 memory should maintain out=0x%04X, obtained out=0x%04X", 
                         expected_out, data_out);
                $finish;
            end
        end
    endtask

    // Test 16-bit register functionality
    initial begin
        $dumpfile("register16_tb.vcd");
        $dumpvars(0, register16_tb);

        $display("16-bit Register with Load Control Test");
        $display("+--------+-------+--------+----------+");
        $display("|   in   | load  |  out   | Operation|");
        $display("+--------+-------+--------+----------+");

        // Initialize
        data_in = 16'h0000;
        load_enable = LOGIC_L;
        #2; // Stabilization

        // Test 1: Load basic test pattern
        register16_load_check(16'h1234, LOGIC_H, 16'h1234);

        // Test 2: Memory behavior - input changes but load=0
        register16_memory_check(16'h5678, 16'h1234); // Should maintain 16'h1234

        // Test 3: Load new pattern
        register16_load_check(16'hABCD, LOGIC_H, 16'hABCD);

        // Test 4: Test alternating bit patterns
        register16_load_check(16'hAAAA, LOGIC_H, 16'hAAAA);  // Alternating bits
        register16_load_check(16'h5555, LOGIC_H, 16'h5555);  // Alternating bits

        // Test 5: Test boundary values
        register16_load_check(16'h0000, LOGIC_H, 16'h0000);  // Zero
        register16_load_check(16'hFFFF, LOGIC_H, 16'hFFFF);  // Maximum

        // Test 6: Memory behavior with maximum value
        register16_memory_check(16'h0000, 16'hFFFF);         // Should maintain 16'hFFFF

        $display("+--------+-------+--------+----------+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The 16-bit register with load control is fully functional.");
        #10;
        $finish;
    end

endmodule