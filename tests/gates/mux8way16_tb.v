// tests/gates/mux8way16_tb.v - Unit Test for Mux8Way16 (8-way 16-bit Multiplexer)
`timescale 1ns / 1ps

module mux8way16_tb;

    // Test signals
    reg [15:0] a_data, b_data, c_data, d_data, e_data, f_data, g_data, h_data;
    reg [2:0] sel;
    wire [15:0] out_data;

    // Instance of the module to be tested
    mux8way16 uut (
        .a(a_data),
        .b(b_data),
        .c(c_data),
        .d(d_data),
        .e(e_data),
        .f(f_data),
        .g(g_data),
        .h(h_data),
        .sel(sel),
        .out(out_data)
    );

    // Constants for test values
    localparam LOGIC_L = 0; // Low logic level
    localparam LOGIC_H = 1; // High logic level

    // Task to check the output of the Mux8Way16
    task mux8way16_check;
        input [15:0] a_val, b_val, c_val, d_val, e_val, f_val, g_val, h_val;
        input [2:0] sel_val;
        input [15:0] expected_out;
        begin
            a_data = a_val;
            b_data = b_val;
            c_data = c_val;
            d_data = d_val;
            e_data = e_val;
            f_data = f_val;
            g_data = g_val;
            h_data = h_val;
            sel = sel_val;
            #10;
            $display("| 0x%04X | 0x%04X | 0x%04X | 0x%04X | 0x%04X | 0x%04X | 0x%04X | 0x%04X | %b | 0x%04X |", 
                     a_data, b_data, c_data, d_data, e_data, f_data, g_data, h_data, sel, out_data);

            if (out_data !== expected_out) begin
                $display("FAILURE: Mux8Way16(a=%04X,b=%04X,c=%04X,d=%04X,e=%04X,f=%04X,g=%04X,h=%04X,sel=%b) expected out=%04X, obtained out=%04X", 
                         a_data, b_data, c_data, d_data, e_data, f_data, g_data, h_data, sel, expected_out, out_data);
                $finish;
            end
        end
    endtask

    // Test complete truth table
    initial begin
        $dumpfile("mux8way16_tb.vcd");
        $dumpvars(0, mux8way16_tb);

        $display("Mux8Way16 (8-way 16-bit) Computed Truth Table");
        $display("+--------+--------+--------+--------+--------+--------+--------+--------+-----+--------+");
        $display("|   a    |   b    |   c    |   d    |   e    |   f    |   g    |   h    | sel |  out   |");
        $display("+--------+--------+--------+--------+--------+--------+--------+--------+-----+--------+");

        // Test cases with all zeros
        mux8way16_check(16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 3'b000, 16'h0000);
        mux8way16_check(16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 3'b001, 16'h0000);
        mux8way16_check(16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 3'b010, 16'h0000);
        mux8way16_check(16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 3'b011, 16'h0000);
        mux8way16_check(16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 3'b100, 16'h0000);
        mux8way16_check(16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 3'b101, 16'h0000);
        mux8way16_check(16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 3'b110, 16'h0000);
        mux8way16_check(16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 3'b111, 16'h0000);
        
        // Test cases with different patterns
        mux8way16_check(16'h1234, 16'h2345, 16'h3456, 16'h4567, 16'h5678, 16'h6789, 16'h789A, 16'h89AB, 3'b000, 16'h1234); // select a
        mux8way16_check(16'h1234, 16'h2345, 16'h3456, 16'h4567, 16'h5678, 16'h6789, 16'h789A, 16'h89AB, 3'b001, 16'h2345); // select b
        mux8way16_check(16'h1234, 16'h2345, 16'h3456, 16'h4567, 16'h5678, 16'h6789, 16'h789A, 16'h89AB, 3'b010, 16'h3456); // select c
        mux8way16_check(16'h1234, 16'h2345, 16'h3456, 16'h4567, 16'h5678, 16'h6789, 16'h789A, 16'h89AB, 3'b011, 16'h4567); // select d
        mux8way16_check(16'h1234, 16'h2345, 16'h3456, 16'h4567, 16'h5678, 16'h6789, 16'h789A, 16'h89AB, 3'b100, 16'h5678); // select e
        mux8way16_check(16'h1234, 16'h2345, 16'h3456, 16'h4567, 16'h5678, 16'h6789, 16'h789A, 16'h89AB, 3'b101, 16'h6789); // select f
        mux8way16_check(16'h1234, 16'h2345, 16'h3456, 16'h4567, 16'h5678, 16'h6789, 16'h789A, 16'h89AB, 3'b110, 16'h789A); // select g
        mux8way16_check(16'h1234, 16'h2345, 16'h3456, 16'h4567, 16'h5678, 16'h6789, 16'h789A, 16'h89AB, 3'b111, 16'h89AB); // select h
        
        $display("+--------+--------+--------+--------+--------+--------+--------+--------+-----+--------+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The Mux8Way16 (8-way 16-bit Multiplexer) is fully functional.");
        $finish;
    end

endmodule