// tests/gates/mux_tb.v - Unit Test for MUX (2-to-1 Multiplexer)
`timescale 1ns / 1ps

module mux_tb;

    // Test signals
    reg in_a, in_b, sel;
    wire out;

    // Instance of the module to be tested
    mux uut (
        .a(in_a),
        .b(in_b),
        .sel(sel),
        .out(out)
    );

    // Constants for test values
    localparam LOGIC_L = 0; // Low logic level
    localparam LOGIC_H = 1; // High logic level

    // Task to check the output of the MUX
    task mux_check;
        input a_val, b_val, sel_val, out_expected;
        begin
            in_a = a_val;
            in_b = b_val;
            sel = sel_val;
            #10;
            $display("|  %b  |  %b  |  %b  |  %b  |  %b  |", in_a, in_b, sel, out_expected, out);

            if (out !== out_expected) begin
                $display("FAILURE: MUX(a=%b,b=%b,sel=%b) expected %b, obtained %b", 
                         in_a, in_b, sel, out_expected, out);
                $finish;
            end
        end
    endtask

    // Test complete truth table
    initial begin
        $dumpfile("mux_tb.vcd");
        $dumpvars(0, mux_tb);

        $display("MUX (2-to-1) Computed Truth Table");
        $display("+-----+-----+-----+-----+-----+");
        $display("|  a  |  b  | sel | exp | out |");
        $display("+-----+-----+-----+-----+-----+");
        mux_check(LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L); // sel=0 -> a=0
        mux_check(LOGIC_H, LOGIC_L, LOGIC_L, LOGIC_H); // sel=0 -> a=1
        mux_check(LOGIC_L, LOGIC_H, LOGIC_L, LOGIC_L); // sel=0 -> a=0
        mux_check(LOGIC_H, LOGIC_H, LOGIC_L, LOGIC_H); // sel=0 -> a=1
        mux_check(LOGIC_L, LOGIC_L, LOGIC_H, LOGIC_L); // sel=1 -> b=0
        mux_check(LOGIC_H, LOGIC_L, LOGIC_H, LOGIC_L); // sel=1 -> b=0
        mux_check(LOGIC_L, LOGIC_H, LOGIC_H, LOGIC_H); // sel=1 -> b=1
        mux_check(LOGIC_H, LOGIC_H, LOGIC_H, LOGIC_H); // sel=1 -> b=1
        $display("+-----+-----+-----+-----+-----+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The MUX (2-to-1 Multiplexer) is fully functional.");
        $finish;
    end

endmodule