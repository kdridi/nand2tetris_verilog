// tests/arithmetic/add16_tb.v - Unit Test for Add16 (16-bit Adder)
`timescale 1ns / 1ps

module add16_tb;

    // Test signals
    reg [15:0] a_data, b_data;
    wire [15:0] out_data;

    // Instance of the module to be tested
    add16 uut (
        .a(a_data),
        .b(b_data),
        .out(out_data)
    );

    // Constants for test values
    localparam LOGIC_L = 0; // Low logic level
    localparam LOGIC_H = 1; // High logic level

    // Task to check the output of the Add16
    task add16_check;
        input [15:0] a_val, b_val;
        input [15:0] expected_out;
        begin
            a_data = a_val;
            b_data = b_val;
            #10;
            $display("| %04X | %04X | %04X |", a_data, b_data, out_data);

            if (out_data !== expected_out) begin
                $display("FAILURE: Add16(a=%04X,b=%04X) expected out=%04X, obtained out=%04X", 
                         a_data, b_data, expected_out, out_data);
                $finish;
            end
        end
    endtask

    // Test complete truth table
    initial begin
        $dumpfile("add16_tb.vcd");
        $dumpvars(0, add16_tb);

        $display("Add16 (16-bit Adder) Computed Truth Table");
        $display("+------+------+------+");
        $display("|  a   |  b   | out  |");
        $display("+------+------+------+");
        
        // Test cases from the original table
        add16_check(16'h0000, 16'h0000, 16'h0000); // 0 + 0 = 0
        add16_check(16'h0000, 16'hFFFF, 16'hFFFF); // 0 + (-1) = -1
        add16_check(16'hFFFF, 16'hFFFF, 16'hFFFE); // (-1) + (-1) = -2 (with overflow)
        add16_check(16'hAAAA, 16'h5555, 16'hFFFF); // alternating patterns sum
        add16_check(16'h3CC3, 16'h0FF0, 16'h4CB3); // mixed pattern addition
        add16_check(16'h1234, 16'h9876, 16'hAAAA); // specific test case

        // Additional test cases for edge conditions
        add16_check(16'h0001, 16'h0001, 16'h0002); // 1 + 1 = 2
        add16_check(16'h7FFF, 16'h0001, 16'h8000); // max positive + 1 = min negative
        add16_check(16'h8000, 16'h8000, 16'h0000); // min negative + min negative = 0 (overflow)

        $display("+------+------+------+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The Add16 (16-bit Adder) is fully functional.");
        $finish;
    end

endmodule