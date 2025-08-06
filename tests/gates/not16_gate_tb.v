// tests/gates/not16_gate_tb.v - Unit Test for NOT16 Gate
`timescale 1ns / 1ps

module not16_gate_tb;

    // Test signals
    reg [15:0] in_data;
    wire [15:0] out;

    // Instance of the module to be tested
    not16_gate uut (
        .in(in_data),
        .out(out)
    );

    // Task to check the output of the NOT16 gate
    task not16_check;
        input [15:0] in_val, out_expected;
        begin
            in_data = in_val;
            #10;
            $display("| 0x%04X | 0x%04X | 0x%04X |", 
                     in_data, out_expected, out);

            if (out !== out_expected) begin
                $display("FAILURE: NOT16(0x%04X) expected 0x%04X, obtained 0x%04X", 
                         in_data, out_expected, out);
                $finish;
            end
        end
    endtask

    // Test comprehensive patterns
    initial begin
        $dumpfile("not16_gate_tb.vcd");
        $dumpvars(0, not16_gate_tb);

        $display("NOT16 Gate Comprehensive Test");
        $display("+--------+--------+--------+");
        $display("|   IN   |  EXP   |  OUT   |");
        $display("+--------+--------+--------+");
        not16_check(16'h0000, 16'hFFFF);
        not16_check(16'hFFFF, 16'h0000);
        not16_check(16'hAAAA, 16'h5555);
        not16_check(16'h5555, 16'hAAAA);
        not16_check(16'h00FF, 16'hFF00);
        not16_check(16'h1234, 16'hEDCB);
        $display("+--------+--------+--------+");
        not16_check(16'b0000000000000000, 16'b1111111111111111);
        not16_check(16'b1111111111111111, 16'b0000000000000000);
        not16_check(16'b1010101010101010, 16'b0101010101010101);
        not16_check(16'b0011110011000011, 16'b1100001100111100);
        not16_check(16'b0001001000110100, 16'b1110110111001011);
        $display("+--------+--------+--------+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The NOT16 gate (16-bit NOT operation) is fully functional.");
        $finish;
    end

endmodule