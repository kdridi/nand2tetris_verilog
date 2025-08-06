// tests/gates/mux16_tb.v - Unit Test for MUX16 (16-bit 2-to-1 Multiplexer)
`timescale 1ns / 1ps

module mux16_tb;

    // Test signals
    reg [15:0] in_a, in_b;
    reg sel;
    wire [15:0] out;

    // Instance of the module to be tested
    mux16 uut (
        .a(in_a),
        .b(in_b),
        .sel(sel),
        .out(out)
    );

    // Constants for logic levels only
    localparam LOGIC_L = 0; // Low logic level
    localparam LOGIC_H = 1; // High logic level

    // Task to check the output of the MUX16
    task mux16_check;
        input [15:0] a_val, b_val;
        input sel_val;
        input [15:0] out_expected;
        begin
            in_a = a_val;
            in_b = b_val;
            sel = sel_val;
            #10;
            $display("| 0x%04X | 0x%04X | %b | 0x%04X | 0x%04X |", 
                     in_a, in_b, sel, out_expected, out);

            if (out !== out_expected) begin
                $display("FAILURE: MUX16(a=0x%04X,b=0x%04X,sel=%b) expected 0x%04X, obtained 0x%04X", 
                         in_a, in_b, sel, out_expected, out);
                $finish;
            end
        end
    endtask

    // Test comprehensive patterns
    initial begin
        $dumpfile("mux16_tb.vcd");
        $dumpvars(0, mux16_tb);

        $display("MUX16 (16-bit 2-to-1) Comprehensive Test");
        $display("+--------+--------+---+--------+--------+");
        $display("|   A    |   B    |SEL|  EXP   |  OUT   |");
        $display("+--------+--------+---+--------+--------+");
        mux16_check(16'h1234, 16'h5678, LOGIC_L, 16'h1234); // sel=0 -> a
        mux16_check(16'h1234, 16'h5678, LOGIC_H, 16'h5678); // sel=1 -> b
        mux16_check(16'h0000, 16'hFFFF, LOGIC_L, 16'h0000); // sel=0 -> a
        mux16_check(16'h0000, 16'hFFFF, LOGIC_H, 16'hFFFF); // sel=1 -> b
        mux16_check(16'hAAAA, 16'h5555, LOGIC_L, 16'hAAAA); // sel=0 -> a
        mux16_check(16'hAAAA, 16'h5555, LOGIC_H, 16'h5555); // sel=1 -> b
        mux16_check(16'hFF00, 16'h00FF, LOGIC_L, 16'hFF00); // sel=0 -> a
        mux16_check(16'hFF00, 16'h00FF, LOGIC_H, 16'h00FF); // sel=1 -> b
        $display("+--------+--------+---+--------+--------+");
        mux16_check(16'b0000000000000000, 16'b0000000000000000, 0, 16'b0000000000000000);
        mux16_check(16'b0000000000000000, 16'b0000000000000000, 1, 16'b0000000000000000);
        mux16_check(16'b0000000000000000, 16'b0001001000110100, 0, 16'b0000000000000000);
        mux16_check(16'b0000000000000000, 16'b0001001000110100, 1, 16'b0001001000110100);
        mux16_check(16'b1001100001110110, 16'b0000000000000000, 0, 16'b1001100001110110);
        mux16_check(16'b1001100001110110, 16'b0000000000000000, 1, 16'b0000000000000000);
        mux16_check(16'b1010101010101010, 16'b0101010101010101, 0, 16'b1010101010101010);
        mux16_check(16'b1010101010101010, 16'b0101010101010101, 1, 16'b0101010101010101);
        $display("+--------+--------+---+--------+--------+");

        $display("");
        
        $display("SUCCESS: All tests passed!");
        $display("The MUX16 (16-bit 2-to-1 Multiplexer) is fully functional.");
        $finish;
    end

endmodule