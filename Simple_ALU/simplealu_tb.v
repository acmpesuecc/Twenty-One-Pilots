module tb_Simple_ALU;

    logic [7:0] a, b;
    logic [2:0] op;
    logic [7:0] result;

   
    Simple_ALU dut (
        .a_i(a),
        .b_i(b),
        .op_i(op),
        .alu_o(result)
    );

   
    initial begin
        //Sample inputs
        a = 8'h3C;
        b = 8'h0F;

        $display("Testing Simple_ALU...");
        for (int i = 0; i < 8; i++) begin
            op = i[2:0];
            #1; 
            $display("op=%b a=%h b=%h result=%h", op, a, b, result);
        end

        //case 1:a == b
        a = 8'hAA;
        b = 8'hAA;
        op = 3'b111;
        #1;
        $display("EQL test: a=%h b=%h result=%h", a, b, result);

        //case 2: shift by max (7)
        a = 8'h01;
        b = 8'h07;
        op = 3'b010; 
        #1;
        $display("SLL test: a=%h b=%h result=%h", a, b, result);

        $finish;
    end

endmodule