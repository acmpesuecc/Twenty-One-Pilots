
module Simple_ALU (
    input  logic [7:0] a_i,      
    input  logic [7:0] b_i,     
    input  logic [2:0] op_i,   
    output logic [7:0] alu_o   
);

  logic [7:0] add_sub;       
  logic [7:0] sll_res;        
  logic [7:0] lsr_res;         
  logic [7:0] and_res;         
  logic [7:0] or_res;          
  logic [7:0] xor_res;         
  logic [7:0] eql_res;         

  assign add_sub = (op_i == 3'b000) ? (a_i + b_i) :
                   (op_i == 3'b001) ? (a_i - b_i) : 8'h00;

  assign sll_res = a_i << b_i[2:0];

  assign lsr_res = a_i >> b_i[2:0];

  assign and_res = a_i & b_i;
  assign or_res  = a_i | b_i;
  assign xor_res = a_i ^ b_i;

  assign eql_res = (a_i == b_i) ? 8'h01 : 8'h00;

  
  always_comb
    unique case (op_i)
      3'b000: alu_o = add_sub;
      3'b001: alu_o = add_sub;
      3'b010: alu_o = sll_res;
      3'b011: alu_o = lsr_res;
      3'b100: alu_o = and_res;
      3'b101: alu_o = or_res;
      3'b110: alu_o = xor_res;
      3'b111: alu_o = eql_res;
      default: alu_o = 8'h00;
    endcase

endmodule