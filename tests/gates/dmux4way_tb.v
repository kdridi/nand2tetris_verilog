// tests/gates/dmux4way_tb.v - Unit Test for DMux4Way (1-to-4 Demultiplexer)
`timescale 1ns / 1ps

module dmux4way_tb;

    // Test signals
    reg in_data;
    reg [1:0] sel;
    wire out_a, out_b, out_c, out_d;

    // Instance of the module to be tested
    dmux4way uut (
        .in(in_data),
        .sel(sel),
        .a(out_a),
        .b(out_b),
        .c(out_c),
        .d(out_d)
    );

    // Constants for test values
    localparam LOGIC_L = 0; // Low logic level
    localparam LOGIC_H = 1; // High logic level

    // Task to check the output of the DMux4Way
    task dmux4way_check;
        input data_val;
        input [1:0] sel_val;
        input exp_a, exp_b, exp_c, exp_d;
        begin
            in_data = data_val;
            sel = sel_val;
            #10;
            $display("|  %b  | %b |  %b  |  %b  |  %b  |  %b  |  %b  |  %b  |  %b  |  %b  |", 
                     in_data, sel, exp_a, exp_b, exp_c, exp_d, out_a, out_b, out_c, out_d);

            if (out_a !== exp_a || out_b !== exp_b || out_c !== exp_c || out_d !== exp_d) begin
                $display("FAILURE: DMux4Way(in=%b,sel=%b) expected (a=%b,b=%b,c=%b,d=%b), obtained (a=%b,b=%b,c=%b,d=%b)", 
                         in_data, sel, exp_a, exp_b, exp_c, exp_d, out_a, out_b, out_c, out_d);
                $finish;
            end
        end
    endtask

    // Test complete truth table
    initial begin
        $dumpfile("dmux4way_tb.vcd");
        $dumpvars(0, dmux4way_tb);

        $display("DMux4Way (1-to-4) Computed Truth Table");
        $display("+-----+----+-----+-----+-----+-----+-----+-----+-----+-----+");
        $display("| inp |sel | a_e | b_e | c_e | d_e |  a  |  b  |  c  |  d  |");
        $display("+-----+----+-----+-----+-----+-----+-----+-----+-----+-----+");
        dmux4way_check(LOGIC_L, 2'b00, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L); // in=0,sel=00 -> all outputs 0
        dmux4way_check(LOGIC_L, 2'b01, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L); // in=0,sel=01 -> all outputs 0
        dmux4way_check(LOGIC_L, 2'b10, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L); // in=0,sel=10 -> all outputs 0
        dmux4way_check(LOGIC_L, 2'b11, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L); // in=0,sel=11 -> all outputs 0
        dmux4way_check(LOGIC_H, 2'b00, LOGIC_H, LOGIC_L, LOGIC_L, LOGIC_L); // in=1,sel=00 -> route to a
        dmux4way_check(LOGIC_H, 2'b01, LOGIC_L, LOGIC_H, LOGIC_L, LOGIC_L); // in=1,sel=01 -> route to b
        dmux4way_check(LOGIC_H, 2'b10, LOGIC_L, LOGIC_L, LOGIC_H, LOGIC_L); // in=1,sel=10 -> route to c
        dmux4way_check(LOGIC_H, 2'b11, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_H); // in=1,sel=11 -> route to d
        $display("+-----+----+-----+-----+-----+-----+-----+-----+-----+-----+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The DMux4Way (1-to-4 Demultiplexer) is fully functional.");
        $finish;
    end

endmodule