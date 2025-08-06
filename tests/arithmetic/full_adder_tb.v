// tests/arithmetic/full_adder_tb.v - Unit Test for FullAdder (3-bit to 2-bit Adder)
`timescale 1ns / 1ps

module full_adder_tb;

    // Test signals
    reg a_data, b_data, c_data;
    wire sum_data, carry_data;

    // Instance of the module to be tested
    full_adder uut (
        .a(a_data),
        .b(b_data),
        .c(c_data),
        .sum(sum_data),
        .carry(carry_data)
    );

    // Constants for test values
    localparam LOGIC_L = 0; // Low logic level
    localparam LOGIC_H = 1; // High logic level

    // Task to check the output of the FullAdder
    task full_adder_check;
        input a_val, b_val, c_val;
        input expected_sum, expected_carry;
        begin
            a_data = a_val;
            b_data = b_val;
            c_data = c_val;
            #10;
            $display("|   %b   |   %b   |   %b   |   %b   |   %b   |", 
                     a_data, b_data, c_data, sum_data, carry_data);

            if (sum_data !== expected_sum || carry_data !== expected_carry) begin
                $display("FAILURE: FullAdder(a=%b,b=%b,c=%b) expected (sum=%b,carry=%b), obtained (sum=%b,carry=%b)", 
                         a_data, b_data, c_data, expected_sum, expected_carry, sum_data, carry_data);
                $finish;
            end
        end
    endtask

    // Test complete truth table
    initial begin
        $dumpfile("full_adder_tb.vcd");
        $dumpvars(0, full_adder_tb);

        $display("FullAdder (3-bit to 2-bit) Computed Truth Table");
        $display("+-------+-------+-------+-------+-------+");
        $display("|   a   |   b   |   c   |  sum  | carry |");
        $display("+-------+-------+-------+-------+-------+");
        
        // Test all 8 possible combinations (2^3 = 8)
        full_adder_check(LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L); // 0+0+0 = 0
        full_adder_check(LOGIC_L, LOGIC_L, LOGIC_H, LOGIC_H, LOGIC_L); // 0+0+1 = 1
        full_adder_check(LOGIC_L, LOGIC_H, LOGIC_L, LOGIC_H, LOGIC_L); // 0+1+0 = 1
        full_adder_check(LOGIC_L, LOGIC_H, LOGIC_H, LOGIC_L, LOGIC_H); // 0+1+1 = 2
        full_adder_check(LOGIC_H, LOGIC_L, LOGIC_L, LOGIC_H, LOGIC_L); // 1+0+0 = 1
        full_adder_check(LOGIC_H, LOGIC_L, LOGIC_H, LOGIC_L, LOGIC_H); // 1+0+1 = 2
        full_adder_check(LOGIC_H, LOGIC_H, LOGIC_L, LOGIC_L, LOGIC_H); // 1+1+0 = 2
        full_adder_check(LOGIC_H, LOGIC_H, LOGIC_H, LOGIC_H, LOGIC_H); // 1+1+1 = 3
        
        $display("+-------+-------+-------+-------+-------+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The FullAdder (3-bit to 2-bit Adder) is fully functional.");
        $finish;
    end

endmodule