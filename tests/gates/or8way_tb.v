// tests/gates/or8way_tb.v - Unit Test for Or8Way (8-way OR)
`timescale 1ns / 1ps

module or8way_tb;

    // Test signals
    reg [7:0] in_data;
    wire out_data;

    // Instance of the module to be tested
    or8way uut (
        .in(in_data),
        .out(out_data)
    );

    // Constants for test values
    localparam LOGIC_L = 0; // Low logic level
    localparam LOGIC_H = 1; // High logic level

    // Task to check the output of the Or8Way
    task or8way_check;
        input [7:0] in_val;
        input expected_out;
        begin
            in_data = in_val;
            #10;
            $display("| %b |  %b  |", in_data, out_data);

            if (out_data !== expected_out) begin
                $display("FAILURE: Or8Way(in=%b) expected out=%b, obtained out=%b", 
                         in_data, expected_out, out_data);
                $finish;
            end
        end
    endtask

    // Test complete truth table
    initial begin
        $dumpfile("or8way_tb.vcd");
        $dumpvars(0, or8way_tb);

        $display("Or8Way (8-way OR) Computed Truth Table");
        $display("+----------+-----+");
        $display("|    in    | out |");
        $display("+----------+-----+");
        
        // Test cases from the original table
        or8way_check(8'b00000000, LOGIC_L); // All zeros -> 0
        or8way_check(8'b11111111, LOGIC_H); // All ones -> 1
        or8way_check(8'b00010000, LOGIC_H); // Single bit set -> 1
        or8way_check(8'b00000001, LOGIC_H); // LSB set -> 1
        or8way_check(8'b00100110, LOGIC_H); // Multiple bits set -> 1
        
        // Additional test cases for completeness
        or8way_check(8'b10000000, LOGIC_H); // MSB set -> 1
        or8way_check(8'b01010101, LOGIC_H); // Alternating pattern -> 1
        or8way_check(8'b10101010, LOGIC_H); // Alternating pattern -> 1
        
        $display("+----------+-----+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The Or8Way (8-way OR) is fully functional.");
        $finish;
    end

endmodule