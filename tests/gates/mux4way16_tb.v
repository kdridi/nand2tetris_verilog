// tests/gates/mux4way16_tb.v - Unit Test for Mux4Way16 (4-way 16-bit Multiplexer)
`timescale 1ns / 1ps

module mux4way16_tb;

    // Test signals
    reg [15:0] a_data, b_data, c_data, d_data;
    reg [1:0] sel;
    wire [15:0] out_data;

    // Instance of the module to be tested
    mux4way16 uut (
        .a(a_data),
        .b(b_data),
        .c(c_data),
        .d(d_data),
        .sel(sel),
        .out(out_data)
    );

    // Constants for test values
    localparam LOGIC_L = 0; // Low logic level
    localparam LOGIC_H = 1; // High logic level



    // Task to check the output of the Mux4Way16
    task mux4way16_check;
        input [15:0] a_val, b_val, c_val, d_val;
        input [1:0] sel_val;
        input [15:0] expected_out;
        begin
            a_data = a_val;
            b_data = b_val;
            c_data = c_val;
            d_data = d_val;
            sel = sel_val;
            #10;
            $display("| %b | %b | %b | %b | %b  | %b |", 
                     a_data, b_data, c_data, d_data, sel, out_data);

            if (out_data !== expected_out) begin
                $display("FAILURE: Mux4Way16(a=%b,b=%b,c=%b,d=%b,sel=%b) expected out=%b, obtained out=%b", 
                         a_data, b_data, c_data, d_data, sel, expected_out, out_data);
                $finish;
            end
        end
    endtask

    // Test complete truth table
    initial begin
        $dumpfile("mux4way16_tb.vcd");
        $dumpvars(0, mux4way16_tb);

        $display("Mux4Way16 (4-way 16-bit) Computed Truth Table");
        $display("+------------------+------------------+------------------+------------------+-----+------------------+");
        $display("|        a         |        b         |        c         |        d         | sel |       out        |");
        $display("+------------------+------------------+------------------+------------------+-----+------------------+");
        
        // Test cases with all zeros
        mux4way16_check(16'b0000000000000000, 16'b0000000000000000, 16'b0000000000000000, 16'b0000000000000000, 2'b00, 16'b0000000000000000);
        mux4way16_check(16'b0000000000000000, 16'b0000000000000000, 16'b0000000000000000, 16'b0000000000000000, 2'b01, 16'b0000000000000000);
        mux4way16_check(16'b0000000000000000, 16'b0000000000000000, 16'b0000000000000000, 16'b0000000000000000, 2'b10, 16'b0000000000000000);
        mux4way16_check(16'b0000000000000000, 16'b0000000000000000, 16'b0000000000000000, 16'b0000000000000000, 2'b11, 16'b0000000000000000);
        
        // Test cases with different patterns
        mux4way16_check(16'b0001001000110100, 16'b1001100001110110, 16'b1010101010101010, 16'b0101010101010101, 2'b00, 16'b0001001000110100); // select a
        mux4way16_check(16'b0001001000110100, 16'b1001100001110110, 16'b1010101010101010, 16'b0101010101010101, 2'b01, 16'b1001100001110110); // select b
        mux4way16_check(16'b0001001000110100, 16'b1001100001110110, 16'b1010101010101010, 16'b0101010101010101, 2'b10, 16'b1010101010101010); // select c
        mux4way16_check(16'b0001001000110100, 16'b1001100001110110, 16'b1010101010101010, 16'b0101010101010101, 2'b11, 16'b0101010101010101); // select d
        
        $display("+------------------+------------------+------------------+------------------+------+------------------+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The Mux4Way16 (4-way 16-bit Multiplexer) is fully functional.");
        $finish;
    end

endmodule