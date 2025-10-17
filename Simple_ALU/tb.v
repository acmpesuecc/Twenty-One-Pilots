`timescale 1ns/1ps

module Simple_ALU_tb;
    reg [7:0] a_i;
    reg [7:0] b_i;
    reg [2:0] op_i;
    wire [7:0] alu_o;

    Simple_ALU dut (
        .a_i(a_i),
        .b_i(b_i),
        .op_i(op_i),
        .alu_o(alu_o)
    );

    initial begin
        $dumpfile("Simple_ALU.vcd");
        $dumpvars(0, Simple_ALU_tb);

        a_i = 8'd10; b_i = 8'd5; op_i = 3'b000; #10; // ADD
        a_i = 8'd20; b_i = 8'd5; op_i = 3'b001; #10; // SUB
        a_i = 8'd8;  b_i = 8'd1; op_i = 3'b010; #10; // SLL
        a_i = 8'd8;  b_i = 8'd1; op_i = 3'b011; #10; // LSR
        a_i = 8'hAA; b_i = 8'h55; op_i = 3'b100; #10; // AND
        a_i = 8'hAA; b_i = 8'h55; op_i = 3'b101; #10; // OR
        a_i = 8'hAA; b_i = 8'h55; op_i = 3'b110; #10; // XOR
        a_i = 8'd25; b_i = 8'd25; op_i = 3'b111; #10; // EQL

        $finish;
    end
endmodule
