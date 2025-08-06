// tests/gates/dmux8way_tb.v - Unit Test for DMux8Way (1-to-8 Demultiplexer)
`timescale 1ns / 1ps

module dmux8way_tb;

    // Test signals
    reg in_data;
    reg [2:0] sel;
    wire out_a, out_b, out_c, out_d, out_e, out_f, out_g, out_h;

    // Instance of the module to be tested
    dmux8way uut (
        .in(in_data),
        .sel(sel),
        .a(out_a),
        .b(out_b),
        .c(out_c),
        .d(out_d),
        .e(out_e),
        .f(out_f),
        .g(out_g),
        .h(out_h)
    );

    // Constants for test values
    localparam LOGIC_L = 0; // Low logic level
    localparam LOGIC_H = 1; // High logic level

    // Task to check the output of the DMux8Way
    task dmux8way_check;
        input data_val;
        input [2:0] sel_val;
        input exp_a, exp_b, exp_c, exp_d, exp_e, exp_f, exp_g, exp_h;
        begin
            in_data = data_val;
            sel = sel_val;
            #10;
            $display("|  %b  | %b |  %b  |  %b  |  %b  |  %b  |  %b  |  %b  |  %b  |  %b  |  %b  |  %b  |  %b  |  %b  |  %b  |  %b  |  %b  |  %b  |", 
                     in_data, sel, exp_a, exp_b, exp_c, exp_d, exp_e, exp_f, exp_g, exp_h, out_a, out_b, out_c, out_d, out_e, out_f, out_g, out_h);

            if (out_a !== exp_a || out_b !== exp_b || out_c !== exp_c || out_d !== exp_d || out_e !== exp_e || out_f !== exp_f || out_g !== exp_g || out_h !== exp_h)
            begin
                $display("FAILURE: DMux8Way(in=%b,sel=%b) expected (a=%b,b=%b,c=%b,d=%b,e=%b,f=%b,g=%b,h=%b), obtained (a=%b,b=%b,c=%b,d=%b,e=%b,f=%b,g=%b,h=%b)", 
                         in_data, sel, exp_a, exp_b, exp_c, exp_d, exp_e, exp_f, exp_g, exp_h,
                         out_a, out_b, out_c, out_d, out_e, out_f, out_g, out_h);
                $finish;
            end
        end
    endtask

    // Test complete truth table
    initial begin
        $dumpfile("dmux8way_tb.vcd");
        $dumpvars(0, dmux8way_tb);

        $display("DMux8Way (1-to-8) Computed Truth Table");
        $display("+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+");
        $display("| inp | sel | a_e | b_e | c_e | d_e | e_e | f_e | g_e | h_e |  a  |  b  |  c  |  d  |  e  |  f  |  g  |  h  |");
        $display("+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+");
        
        // Test cases with in=0 (all outputs should be 0)
        dmux8way_check(LOGIC_L, 3'b000, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L);
        dmux8way_check(LOGIC_L, 3'b001, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L);
        dmux8way_check(LOGIC_L, 3'b010, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L);
        dmux8way_check(LOGIC_L, 3'b011, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L);
        dmux8way_check(LOGIC_L, 3'b100, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L);
        dmux8way_check(LOGIC_L, 3'b101, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L);
        dmux8way_check(LOGIC_L, 3'b110, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L);
        dmux8way_check(LOGIC_L, 3'b111, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L);
        
        // Test cases with in=1 (one output active per selector)
        dmux8way_check(LOGIC_H, 3'b000, LOGIC_H, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L); // route to a
        dmux8way_check(LOGIC_H, 3'b001, LOGIC_L, LOGIC_H, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L); // route to b
        dmux8way_check(LOGIC_H, 3'b010, LOGIC_L, LOGIC_L, LOGIC_H, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L); // route to c
        dmux8way_check(LOGIC_H, 3'b011, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_H, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L); // route to d
        dmux8way_check(LOGIC_H, 3'b100, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_H, LOGIC_L, LOGIC_L, LOGIC_L); // route to e
        dmux8way_check(LOGIC_H, 3'b101, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_H, LOGIC_L, LOGIC_L); // route to f
        dmux8way_check(LOGIC_H, 3'b110, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_H, LOGIC_L); // route to g
        dmux8way_check(LOGIC_H, 3'b111, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_L, LOGIC_H); // route to h
        
        $display("+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The DMux8Way (1-to-8 Demultiplexer) is fully functional.");
        $finish;
    end

endmodule