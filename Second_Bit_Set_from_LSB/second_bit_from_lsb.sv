module Second_Bit_Set_from_LSB #(
    parameter WIDTH = 12
)(
    input wire [WIDTH-1:0] vec_i,
    output wire [WIDTH-1:0] second_bit_o
);

    wire [WIDTH-1:0] first_bit; 
    assign first_bit = vec_i & ((~vec_i) + 1);// obtaining the first bit ( all th 0's become 1 so when adding 1, all ones are flipped except the first 1 which becomes 0 which then becomes 1)

    wire [WIDTH-1:0] first_cleared;
    assign first_cleared = (~first_bit) & vec_i; //clearing the first bit from the vector

    assign second_bit_o = first_cleared & ((~first_cleared) + 1); // obtaining the second bit


endmodule
