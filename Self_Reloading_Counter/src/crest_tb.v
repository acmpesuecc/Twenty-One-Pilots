`timescale 1ns/1ps
module Self_Reloading_Counter_tb;

    reg clk;
    reg reset;
    reg load_i;
    reg [3:0] load_val_i;
    wire [3:0] count_o;

    // Instantiate the counter
    Self_Reloading_Counter uut (
        .clk(clk),
        .reset(reset),
        .load_i(load_i),
        .load_val_i(load_val_i),
        .count_o(count_o)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $monitor("Time=%0t | reset=%b | load_i=%b | load_val_i=%b | count_o=%b",
                 $time, reset, load_i, load_val_i, count_o);

        clk = 0;
        reset = 1;
        load_i = 0;
        load_val_i = 4'b0000;

        #10 reset = 0;

        #20;

        load_i = 1; load_val_i = 4'b0101;
        #10 load_i = 0;

    
        #40;

        load_i = 1; load_val_i = 4'b1100;
        #10 load_i = 0;


        #30;

        reset = 1;
        #10 reset = 0;

        #20 $finish;
    end
endmodule
