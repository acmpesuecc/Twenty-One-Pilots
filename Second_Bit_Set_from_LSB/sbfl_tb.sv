`timescale 1ns/1ns

module tb_Second_Bit_Set_from_LSB;
    parameter WIDTH = 12;
    
    reg [WIDTH-1:0] vec_i;
    wire [WIDTH-1:0] second_bit_o;
    
    // Instantiate the design
    Second_Bit_Set_from_LSB #(.WIDTH(WIDTH)) uut (
        .vec_i(vec_i),
        .second_bit_o(second_bit_o)
    );
    
    initial begin
        // Create VCD file for waveform
        $dumpfile("waves.vcd");
        $dumpvars(0, tb_Second_Bit_Set_from_LSB); // Dump all variables
        
        $display("=== Testing Second Bit Set from LSB ===");
        
        // Test case 1: Multiple bits set
        vec_i = 12'b0010_1100_1101; #10;
        $display("Input: %b, Output: %b", vec_i, second_bit_o);
        
        // Test case 2: Consecutive bits
        vec_i = 12'b0000_0000_1111; #10;
        $display("Input: %b, Output: %b", vec_i, second_bit_o);
        
        // Test case 3: Only one bit set
        vec_i = 12'b0000_0000_1000; #10;
        $display("Input: %b, Output: %b", vec_i, second_bit_o);
        
        // Test case 4: No bits set
        vec_i = 12'b0000_0000_0000; #10;
        $display("Input: %b, Output: %b", vec_i, second_bit_o);
        
        // Test case 5: Edge case
        vec_i = 12'b1100_0000_0001; #10;
        $display("Input: %b, Output: %b", vec_i, second_bit_o);
        
        $display("=== Test Complete ===");
        $finish;
    end
endmodule