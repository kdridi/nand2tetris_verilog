// tests/gates/nand_gate_tb.v - Unit Test for NAND Gate
`timescale 1ns / 1ps

module test_nand;

    // Test signals
    reg in_a, in_b;
    wire out;

    // Instance of the module to be tested
    nand_gate uut (
        .a(in_a),
        .b(in_b),
        .out(out)
    );

    // Constants for test values
    localparam LOGIC_L = 0; // Low logic level
    localparam LOGIC_H = 1; // High logic level

    // Task to check the out of the NAND gate
    task nand_gate_check;
        input a_val, b_val, out_expected;
        begin
            in_a = a_val;
            in_b = b_val;
            #10;
            $display("|  %b  |  %b  |  %b  |  %b  |", in_a, in_b, out_expected, out);

            if (out !== out_expected) begin
                $display("FAILURE: NAND(%b,%b) expected %b, obtained %b", in_a, in_b, out_expected, out);
                $finish;
            end
        end
    endtask

    // Test complete truth table
    initial begin
        $dumpfile("test_nand.vcd");
        $dumpvars(0, test_nand);

        $display("NAND Computed Truth Table");
        $display("+-----+-----+-----+-----+");
        $display("|  a  |  b  | exp | out |");
        $display("+-----+-----+-----+-----+");
        nand_gate_check(LOGIC_L, LOGIC_L, LOGIC_H);
        nand_gate_check(LOGIC_L, LOGIC_H, LOGIC_H);
        nand_gate_check(LOGIC_H, LOGIC_L, LOGIC_H);
        nand_gate_check(LOGIC_H, LOGIC_H, LOGIC_L);
        $display("+-----+-----+-----+-----+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The NAND gate is fully functional.");
        $finish;
    end

endmodule
