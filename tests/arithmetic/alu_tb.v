// tests/arithmetic/alu_tb.v - Unit Test for ALU (Arithmetic Logic Unit)
`timescale 1ns / 1ps

module alu_tb;

    // Test signals
    reg [15:0] x_data, y_data;
    reg zx, nx, zy, ny, f, no;
    wire [15:0] out_data;
    wire zr, ng;

    // Instance of the module to be tested
    alu uut (
        .x(x_data),
        .y(y_data),
        .zx(zx), .nx(nx), .zy(zy), .ny(ny), .f(f), .no(no),
        .out(out_data),
        .zr(zr), .ng(ng)
    );

    // Constants for test values
    localparam LOGIC_L = 0; // Low logic level
    localparam LOGIC_H = 1; // High logic level

    // Task to check the output of the ALU
    task alu_check;
        input [15:0] x_val, y_val;
        input zx_val, nx_val, zy_val, ny_val, f_val, no_val;
        input [15:0] expected_out;
        input expected_zr, expected_ng;
        begin
            x_data = x_val;
            y_data = y_val;
            zx = zx_val; nx = nx_val; zy = zy_val; ny = ny_val; f = f_val; no = no_val;
            #10;
            $display("| 0x%04X | 0x%04X | %b  | %b  | %b  | %b  | %b | %b  | 0x%04X | %b  | %b  |", 
                     x_data, y_data, zx, nx, zy, ny, f, no, out_data, zr, ng);

            if (out_data !== expected_out || zr !== expected_zr || ng !== expected_ng) begin
                $display("FAILURE: ALU(x=%04X,y=%04X,zx=%b,nx=%b,zy=%b,ny=%b,f=%b,no=%b) expected (out=%04X,zr=%b,ng=%b), obtained (out=%04X,zr=%b,ng=%b)", 
                         x_data, y_data, zx, nx, zy, ny, f, no, expected_out, expected_zr, expected_ng, out_data, zr, ng);
                $finish;
            end
        end
    endtask

    // Test complete truth table
    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        $display("ALU (Arithmetic Logic Unit) Computed Truth Table");
        $display("+--------+--------+----+----+----+----+---+----+--------+----+----+");
        $display("|   x    |   y    | zx | nx | zy | ny | f | no |  out   | zr | ng |");
        $display("+--------+--------+----+----+----+----+---+----+--------+----+----+");

        // Test cases with x=0000, y=FFFF
        alu_check(16'h0000, 16'hFFFF, 1, 0, 1, 0, 1, 0, 16'h0000, 1, 0);
        alu_check(16'h0000, 16'hFFFF, 1, 1, 1, 1, 1, 1, 16'h0001, 0, 0);
        alu_check(16'h0000, 16'hFFFF, 1, 1, 1, 0, 1, 0, 16'hFFFF, 0, 1);
        alu_check(16'h0000, 16'hFFFF, 0, 0, 1, 1, 0, 0, 16'h0000, 1, 0);
        alu_check(16'h0000, 16'hFFFF, 1, 1, 0, 0, 0, 0, 16'hFFFF, 0, 1);
        alu_check(16'h0000, 16'hFFFF, 0, 0, 1, 1, 0, 1, 16'hFFFF, 0, 1);
        alu_check(16'h0000, 16'hFFFF, 1, 1, 0, 0, 0, 1, 16'h0000, 1, 0);
        alu_check(16'h0000, 16'hFFFF, 0, 0, 1, 1, 1, 1, 16'h0000, 1, 0);
        alu_check(16'h0000, 16'hFFFF, 1, 1, 0, 0, 1, 1, 16'h0001, 0, 0);
        alu_check(16'h0000, 16'hFFFF, 0, 1, 1, 1, 1, 1, 16'h0001, 0, 0);
        alu_check(16'h0000, 16'hFFFF, 1, 1, 0, 1, 1, 1, 16'h0000, 1, 0);
        alu_check(16'h0000, 16'hFFFF, 0, 0, 1, 1, 1, 0, 16'hFFFF, 0, 1);
        alu_check(16'h0000, 16'hFFFF, 1, 1, 0, 0, 1, 0, 16'hFFFE, 0, 1);
        alu_check(16'h0000, 16'hFFFF, 0, 0, 0, 0, 1, 0, 16'hFFFF, 0, 1);
        alu_check(16'h0000, 16'hFFFF, 0, 1, 0, 0, 1, 1, 16'h0001, 0, 0);
        alu_check(16'h0000, 16'hFFFF, 0, 0, 0, 1, 1, 1, 16'hFFFF, 0, 1);
        alu_check(16'h0000, 16'hFFFF, 0, 0, 0, 0, 0, 0, 16'h0000, 1, 0);
        alu_check(16'h0000, 16'hFFFF, 0, 1, 0, 1, 0, 1, 16'hFFFF, 0, 1);

        // Test cases with x=0011, y=0003  
        alu_check(16'h0011, 16'h0003, 1, 0, 1, 0, 1, 0, 16'h0000, 1, 0);
        alu_check(16'h0011, 16'h0003, 1, 1, 1, 1, 1, 1, 16'h0001, 0, 0);
        alu_check(16'h0011, 16'h0003, 1, 1, 1, 0, 1, 0, 16'hFFFF, 0, 1);
        alu_check(16'h0011, 16'h0003, 0, 0, 1, 1, 0, 0, 16'h0011, 0, 0);
        alu_check(16'h0011, 16'h0003, 1, 1, 0, 0, 0, 0, 16'h0003, 0, 0);
        alu_check(16'h0011, 16'h0003, 0, 0, 1, 1, 0, 1, 16'hFFEE, 0, 1);
        alu_check(16'h0011, 16'h0003, 1, 1, 0, 0, 0, 1, 16'hFFFC, 0, 1);
        alu_check(16'h0011, 16'h0003, 0, 0, 1, 1, 1, 1, 16'hFFEF, 0, 1);
        alu_check(16'h0011, 16'h0003, 1, 1, 0, 0, 1, 1, 16'hFFFD, 0, 1);
        alu_check(16'h0011, 16'h0003, 0, 1, 1, 1, 1, 1, 16'h0012, 0, 0);
        alu_check(16'h0011, 16'h0003, 1, 1, 0, 1, 1, 1, 16'h0004, 0, 0);
        alu_check(16'h0011, 16'h0003, 0, 0, 1, 1, 1, 0, 16'h0010, 0, 0);
        alu_check(16'h0011, 16'h0003, 1, 1, 0, 0, 1, 0, 16'h0002, 0, 0);
        alu_check(16'h0011, 16'h0003, 0, 0, 0, 0, 1, 0, 16'h0014, 0, 0);
        alu_check(16'h0011, 16'h0003, 0, 1, 0, 0, 1, 1, 16'h000E, 0, 0);
        alu_check(16'h0011, 16'h0003, 0, 0, 0, 1, 1, 1, 16'hFFF2, 0, 1);
        alu_check(16'h0011, 16'h0003, 0, 0, 0, 0, 0, 0, 16'h0001, 0, 0);
        alu_check(16'h0011, 16'h0003, 0, 1, 0, 1, 0, 1, 16'h0013, 0, 0);

        $display("+--------+--------+----+----+----+----+---+----+--------+----+----+");

        $display("");

        $display("SUCCESS: All tests passed!");
        $display("The ALU (Arithmetic Logic Unit) is fully functional.");
        $finish;
    end

endmodule