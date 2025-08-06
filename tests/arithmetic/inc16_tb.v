// tests/arithmetic/inc16_tb.v - Unit Test for Inc16 (16-bit Incrementer)
`timescale 1ns / 1ps

module inc16_tb;

    // Test signals
    reg [15:0] in_data;
    wire [15:0] out_data;

    // Instance of the module to be tested
    inc16 uut (
        .in(in_data),
        .out(out_data)
    );

    // Constants for test values
    localparam LOGIC_L = 0; // Low logic level
    localparam LOGIC_H = 1; // High logic level

    // Task to check the output of the Inc16
    task inc16_check;
        input [15:0] in_val;
        input [15:0] expected_out;
        begin
            in_data = in_val;
            #10;
            $display("| %04X | %04X |", in_data, out_data);

            if (out_data !== expected_out) begin
                $display("FAILURE: Inc16(in=%04X) expected out=%04X, obtained out=%04X", 
                         in_data, expected_out, out_data);
                $finish;
            end
        end
    endtask

    // Test complete truth table
    initial begin
        $dumpfile("inc16_tb.vcd");
        $dumpvars(0, inc16_tb);

        $display("Inc16 (16-bit Incrementer) Computed Truth Table");
        $display("+------+------+");
        $display("|  in  | out  |");
        $display("+------+------+");
        
        // Test cases from the original table
        inc16_check(16'h0000, 16'h0001); // 0 + 1 = 1
        inc16_check(16'hFFFF, 16'h0000); // 65535 + 1 = 0 (overflow)
        inc16_check(16'h0005, 16'h0006); // 5 + 1 = 6
        inc16_check(16'hFFFB, 16'hFFFC); // -5 + 1 = -4 (in 2's complement)

        // Additional test cases for edge conditions
        inc16_check(16'h0001, 16'h0002); // 1 + 1 = 2
        inc16_check(16'h7FFF, 16'h8000); // 32767 + 1 = -32768 (signed overflow)
        inc16_check(16'h0007, 16'h0008); // Carry propagation test
        inc16_check(16'h00FF, 16'h0100); // 8-bit boundary crossing
        inc16_check(16'h0FFF, 16'h1000); // 12-bit boundary crossing

        $display("+------+------+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The Inc16 (16-bit Incrementer) is fully functional.");
        $finish;
    end

endmodule