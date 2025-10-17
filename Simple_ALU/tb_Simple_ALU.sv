module tb_Simple_ALU;

logic [7:0] a_i, b_i, alu_o;
logic [2:0] op_i;

Simple_ALU dut (.*);

initial begin
    $dumpfile("dump.fst");
    $dumpvars(0, tb_Simple_ALU);

    a_i = 0; b_i = 0; op_i = 0;

    #10 a_i = 8'd5; b_i = 8'd3; op_i = 3'd0;
    #10 a_i = 8'd5; b_i = 8'd3; op_i = 3'd1;
    #10 a_i = 8'd5; b_i = 3'd2; op_i = 3'd2;
    #10 a_i = 8'd8; b_i = 3'd2; op_i = 3'd3;
    #10 a_i = 8'hF0; b_i = 8'h0F; op_i = 3'd4;
    #10 a_i = 8'hF0; b_i = 8'h0F; op_i = 3'd5;
    #10 a_i = 8'hF0; b_i = 8'h0F; op_i = 3'd6;
    #10 a_i = 8'd7; b_i = 8'd7; op_i = 3'd7;
    #10 a_i = 8'd7; b_i = 8'd9; op_i = 3'd7;

    #10 $finish;
end

endmodule