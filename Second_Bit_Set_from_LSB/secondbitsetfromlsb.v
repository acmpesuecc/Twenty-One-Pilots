module Second_Bit_Set_from_LSB #(
  parameter WIDTH = 12
)(
  input  wire [WIDTH-1:0] vec_i,
  output wire [WIDTH-1:0] second_bit_o
);

  // Step 1: Find the first set bit (lowest 1)
  wire [WIDTH-1:0] first_bit;
  assign first_bit = vec_i & (~vec_i + 1);  // isolates lowest 1-bit

  // Step 2: Clear the first set bit
  wire [WIDTH-1:0] cleared_vec;
  assign cleared_vec = vec_i & ~first_bit;

  // Step 3: Find the second set bit (lowest 1 in cleared_vec)
  assign second_bit_o = cleared_vec & (~cleared_vec + 1);

endmodule
