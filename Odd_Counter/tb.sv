`timescale 1ns/1ps

module tb_Odd_Counter;
    logic clk;
    logic reset;
    logic [7:0] cnt_o;

    Odd_Counter uut (
        .clk(clk),
        .reset(reset),
        .cnt_o(cnt_o)
    );

    always #5 clk = ~clk;


    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        #10;
        reset = 0; // Deassert reset

        repeat (10) @(posedge clk);

        $finish;
    end

    initial begin
        $display("Time(ns)\tReset\tCount");
        $monitor("%0t\t%b\t%0h", $time, reset, cnt_o);
    end

endmodule
