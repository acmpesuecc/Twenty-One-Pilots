`timescale 1ns/1ps

module tb_LFSR;

    reg clk;
    reg reset;
    wire [3:0] lfsr_o;

    // Instantiate the LFSR module
    LFSR uut (
        .clk(clk),
        .reset(reset),
        .lfsr_o(lfsr_o)
    );

    // Generate clock signal (toggles every 5 time units)
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        reset = 1;
        #10;            // Wait 10 time units

        reset = 0;      // Release reset
        #100;           // Run for 100 time units

        $finish;        // End simulation
    end

    // Monitor the output every time it changes
    initial begin
        $monitor("Time=%0t | LFSR = %b", $time, lfsr_o);
    end

endmodule
