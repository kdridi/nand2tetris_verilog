// tests/gates/dmux_tb.v - Unit Test for DMUX (1-to-2 Demultiplexer)
`timescale 1ns / 1ps

module dmux_tb;

    // Test signals
    reg in_data, sel;
    wire out_a, out_b;

    // Instance of the module to be tested
    dmux uut (
        .in(in_data),
        .sel(sel),
        .a(out_a),
        .b(out_b)
    );

    // Constants for test values
    localparam LOGIC_L = 0; // Low logic level
    localparam LOGIC_H = 1; // High logic level

    // Task to check the output of the DMUX
    task dmux_check;
        input data_val, sel_val;
        input exp_a, exp_b;
        begin
            in_data = data_val;
            sel = sel_val;
            #10;
            $display("|  %b  |  %b  |  %b  |  %b  |  %b  |  %b  |", in_data, sel, exp_a, exp_b, out_a, out_b);

            if (out_a !== exp_a || out_b !== exp_b) begin
                $display("FAILURE: DMUX(in=%b,sel=%b) expected (a=%b,b=%b), obtained (a=%b,b=%b)", 
                         in_data, sel, exp_a, exp_b, out_a, out_b);
                $finish;
            end
        end
    endtask

    // Test complete truth table
    initial begin
        $dumpfile("dmux_tb.vcd");
        $dumpvars(0, dmux_tb);

        $display("DMUX (1-to-2) Computed Truth Table");
        $display("+-----+-----+-----+-----+-----+-----+");
        $display("| inp | sel | a_e | b_e |  a  |  b  |");
        $display("+-----+-----+-----+-----+-----+-----+");
        dmux_check(LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L); // in=0,sel=0 -> a=0,b=0
        dmux_check(LOGIC_L, LOGIC_H, LOGIC_L, LOGIC_L); // in=0,sel=1 -> a=0,b=0  
        dmux_check(LOGIC_H, LOGIC_L, LOGIC_H, LOGIC_L); // in=1,sel=0 -> a=1,b=0 (route to a)
        dmux_check(LOGIC_H, LOGIC_H, LOGIC_L, LOGIC_H); // in=1,sel=1 -> a=0,b=1 (route to b)
        $display("+-----+-----+-----+-----+-----+-----+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The DMUX (1-to-2 Demultiplexer) is fully functional.");
        $finish;
    end

endmodule