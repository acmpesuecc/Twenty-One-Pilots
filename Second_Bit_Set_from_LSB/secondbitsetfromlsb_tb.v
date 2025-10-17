`timescale 1ns/1ps
module Second_Bit_Set_from_LSB_tb;

  reg [11:0] vec_i;
  wire [11:0] second_bit_o;

  Second_Bit_Set_from_LSB #(.WIDTH(12)) dut (
    .vec_i(vec_i),
    .second_bit_o(second_bit_o)
  );

  initial begin
    $dumpfile("second_bit.vcd");
    $dumpvars(0, Second_Bit_Set_from_LSB_tb);

    // Test 1
    vec_i = 12'b001001000000;
    #10;

    // Test 2 - only one bit set
    vec_i = 12'b000000100000;
    #10;

    // Test 3 - no bits set
    vec_i = 12'b000000000000;
    #10;

    // Test 4 - multiple bits
    vec_i = 12'b111100001111;
    #10;

    $finish;
  end

  initial begin
    $monitor("Time=%0t | vec_i=%b | second_bit_o=%b", $time, vec_i, second_bit_o);
  end

endmodule
