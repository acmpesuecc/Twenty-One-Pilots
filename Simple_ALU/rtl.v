module Simple_ALU (
    input [7:0] a_i,
    input [7:0] b_i,
    input [2:0] op_i,
    output reg [7:0] alu_o
);

    always @(*) begin
        case (op_i)
            3'b000: alu_o = a_i + b_i;
            3'b001: alu_o = a_i - b_i;
            3'b010: alu_o = a_i << b_i[2:0];
            3'b011: alu_o = a_i >> b_i[2:0];
            3'b100: alu_o = a_i & b_i;
            3'b101: alu_o = a_i | b_i;
            3'b110: alu_o = a_i ^ b_i;
            3'b111: alu_o = (a_i == b_i) ? 8'b00000001 : 8'b00000000;
            default: alu_o = 8'h00;
        endcase
    end
endmodule
