// tests/gates/and16_gate_tb.v - Unit Test for AND16 Gate
`timescale 1ns / 1ps

module and16_gate_tb;

    // Test signals
    reg [15:0] in_a, in_b;
    wire [15:0] out;

    // Instance of the module to be tested
    and16_gate uut (
        .a(in_a),
        .b(in_b),
        .out(out)
    );
    
    // Task to check the output of the AND16 gate
    task and16_check;
        input [15:0] a_val, b_val, out_expected;
        begin
            in_a = a_val;
            in_b = b_val;
            #10;
            $display("| 0x%04X | 0x%04X | 0x%04X | 0x%04X |", 
                     in_a, in_b, out_expected, out);

            if (out !== out_expected) begin
                $display("FAILURE: AND16(0x%04X,0x%04X) expected 0x%04X, obtained 0x%04X", 
                         in_a, in_b, out_expected, out);
                $finish;
            end
        end
    endtask

    // Test comprehensive patterns
    initial begin
        $dumpfile("and16_gate_tb.vcd");
        $dumpvars(0, and16_gate_tb);

        $display("AND16 Gate Comprehensive Test");
        $display("+--------+--------+--------+--------+");
        $display("|   A    |   B    |  EXP   |  OUT   |");
        $display("+--------+--------+--------+--------+");
        and16_check(16'hFFFF, 16'hFFFF, 16'hFFFF);
        and16_check(16'hFFFF, 16'h0000, 16'h0000);
        and16_check(16'h0000, 16'hFFFF, 16'h0000);
        and16_check(16'h0000, 16'h0000, 16'h0000);
        and16_check(16'hAAAA, 16'h5555, 16'h0000);
        and16_check(16'hAAAA, 16'hAAAA, 16'hAAAA);
        and16_check(16'h1234, 16'h5678, 16'h1230);
        and16_check(16'hFF00, 16'h00FF, 16'h0000);
        $display("+--------+--------+--------+--------+");

        $display("");
        
        $display("SUCCESS: All tests passed!");
        $display("The AND16 gate (16-bit AND operation) is fully functional.");
        $finish;
    end

endmodule