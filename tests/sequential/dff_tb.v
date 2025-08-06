// tests/sequential/dff_tb.v - Unit Test for D-Flip-Flop (Basic Memory Element)
`timescale 1ns / 1ps

module dff_tb;

    // Test signals
    reg data_in, clock_signal;
    wire data_out;

    // Instance of the module to be tested
    dff uut (
        .d(data_in),
        .clk(clock_signal),
        .q(data_out)
    );

    // Constants for test values
    localparam LOGIC_L = 0; // Low logic level
    localparam LOGIC_H = 1; // High logic level

    // Clock generation
    initial begin
        clock_signal = 0;
        forever #5 clock_signal = ~clock_signal; // 10ns period (100MHz)
    end

    // Task to check DFF behavior on clock edge
    task dff_edge_check;
        input d_val;
        input expected_q;
        begin
            data_in = d_val;
            @(posedge clock_signal); // Wait for positive clock edge
            #1; // Propagation delay
            $display("|   %b   |   %b   | Clock Edge |", data_in, data_out);

            if (data_out !== expected_q) begin
                $display("FAILURE: DFF(d=%b) expected q=%b, obtained q=%b", data_in, expected_q, data_out);
                $finish;
            end
        end
    endtask

    // Task to check DFF memory behavior (no clock edge)
    task dff_memory_check;
        input d_val;
        input expected_q;
        begin
            data_in = d_val;
            #3; // Wait without clock edge
            $display("|   %b   |   %b   |  No Edge   |", data_in, data_out);

            if (data_out !== expected_q) begin
                $display("FAILURE: DFF memory should maintain q=%b, obtained q=%b", expected_q, data_out);
                $finish;
            end
        end
    endtask

    // Test sequential behavior
    initial begin
        $dumpfile("dff_tb.vcd");
        $dumpvars(0, dff_tb);

        $display("D-Flip-Flop Sequential Logic Test");
        $display("+-------+-------+------------+");
        $display("|   d   |   q   |   Event    |");
        $display("+-------+-------+------------+");

        // Initialize
        data_in = LOGIC_L;
        #2; // Stabilization

        // Test 1: Store logic HIGH
        dff_edge_check(LOGIC_H, LOGIC_H);

        // Test 2: Memory behavior - d changes but no clock edge
        dff_memory_check(LOGIC_L, LOGIC_H); // q should remain HIGH

        // Test 3: Store logic LOW on next clock edge
        dff_edge_check(LOGIC_L, LOGIC_L);

        // Test 4: Rapid alternation
        dff_edge_check(LOGIC_H, LOGIC_H);
        dff_edge_check(LOGIC_L, LOGIC_L);
        dff_edge_check(LOGIC_H, LOGIC_H);

        $display("+-------+-------+------------+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The D-Flip-Flop (basic memory element) is fully functional.");
        #10;
        $finish;
    end

endmodule