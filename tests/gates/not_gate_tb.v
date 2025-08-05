// tests/gates/not_gate_tb.v - Unit Test for NOT Gate
`timescale 1ns / 1ps

module not_gate_tb;

    // Test signals
    reg in_a;
    wire out;

    // Instance of the module to be tested
    not_gate uut (
        .in(in_a),
        .out(out)
    );

    // Constants for test values
    localparam LOGIC_L = 0; // Low logic level
    localparam LOGIC_H = 1; // High logic level

    // Task to check the output of the NOT gate
    task not_gate_check;
        input a_val, out_expected;
        begin
            in_a = a_val;
            #10;
            $display("|  %b  |  %b  |  %b  |", in_a, out_expected, out);

            if (out !== out_expected) begin
                $display("FAILURE: NOT(%b) expected %b, obtained %b", in_a, out_expected, out);
                $finish;
            end
        end
    endtask

    // Test complete truth table
    initial begin
        $dumpfile("not_gate_tb.vcd");
        $dumpvars(0, not_gate_tb);

        $display("NOT Computed Truth Table");
        $display("+-----+-----+-----+");
        $display("| in  | exp | out |");
        $display("+-----+-----+-----+");
        not_gate_check(LOGIC_L, LOGIC_H);
        not_gate_check(LOGIC_H, LOGIC_L);
        $display("+-----+-----+-----+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The NOT gate (built with NAND) is fully functional.");
        $finish;
    end

endmodule