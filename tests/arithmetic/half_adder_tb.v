// tests/arithmetic/half_adder_tb.v - Unit Test for HalfAdder (2-bit to 2-bit Adder)
`timescale 1ns / 1ps

module half_adder_tb;

    // Test signals
    reg a_data, b_data;
    wire sum_data, carry_data;

    // Instance of the module to be tested
    half_adder uut (
        .a(a_data),
        .b(b_data),
        .sum(sum_data),
        .carry(carry_data)
    );

    // Constants for test values
    localparam LOGIC_L = 0; // Low logic level
    localparam LOGIC_H = 1; // High logic level

    // Task to check the output of the HalfAdder
    task half_adder_check;
        input a_val, b_val;
        input expected_sum, expected_carry;
        begin
            a_data = a_val;
            b_data = b_val;
            #10;
            $display("|   %b   |   %b   |   %b   |   %b   |", 
                     a_data, b_data, sum_data, carry_data);

            if (sum_data !== expected_sum || carry_data !== expected_carry) begin
                $display("FAILURE: HalfAdder(a=%b,b=%b) expected (sum=%b,carry=%b), obtained (sum=%b,carry=%b)", 
                         a_data, b_data, expected_sum, expected_carry, sum_data, carry_data);
                $finish;
            end
        end
    endtask

    // Test complete truth table
    initial begin
        $dumpfile("half_adder_tb.vcd");
        $dumpvars(0, half_adder_tb);

        $display("HalfAdder (2-bit to 2-bit) Computed Truth Table");
        $display("+-------+-------+-------+-------+");
        $display("|   a   |   b   |  sum  | carry |");
        $display("+-------+-------+-------+-------+");
        
        // Test all 4 possible combinations (2^2 = 4)
        half_adder_check(LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L); // 0+0 = 0
        half_adder_check(LOGIC_L, LOGIC_H, LOGIC_H, LOGIC_L); // 0+1 = 1
        half_adder_check(LOGIC_H, LOGIC_L, LOGIC_H, LOGIC_L); // 1+0 = 1
        half_adder_check(LOGIC_H, LOGIC_H, LOGIC_L, LOGIC_H); // 1+1 = 2 (10 in binary)
        
        $display("+-------+-------+-------+-------+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The HalfAdder (2-bit to 2-bit Adder) is fully functional.");
        $finish;
    end

endmodule