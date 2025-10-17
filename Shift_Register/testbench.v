`timescale 1ns/1ns

module Shift_Register_tb;

// Testbench signals
reg clk;
reg reset;
reg x_i;
wire [3:0] sr_o;

// Instantiate the Shift Register module
Shift_Register uut (
    .clk(clk),
    .reset(reset),
    .x_i(x_i),
    .sr_o(sr_o)
);

// Clock generation - 10ns period (100MHz)
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test sequence
initial begin
    // Initialize signals
    reset = 1;
    x_i = 0;
    
    // Display header
    $display("Time\tReset\tx_i\tsr_o");
    $display("====\t=====\t===\t====");
    
    // Wait for a few clock cycles with reset active
    #10;
    reset = 0;
    
    // Test Case 1: Shift in sequence 1011
    #10 x_i = 1; $display("%0t\t%b\t%b\t%b", $time, reset, x_i, sr_o);
    #10 x_i = 0; $display("%0t\t%b\t%b\t%b", $time, reset, x_i, sr_o);
    #10 x_i = 1; $display("%0t\t%b\t%b\t%b", $time, reset, x_i, sr_o);
    #10 x_i = 1; $display("%0t\t%b\t%b\t%b", $time, reset, x_i, sr_o);
    
    // Test Case 2: Continue shifting with 0s
    #10 x_i = 0; $display("%0t\t%b\t%b\t%b", $time, reset, x_i, sr_o);
    #10 x_i = 0; $display("%0t\t%b\t%b\t%b", $time, reset, x_i, sr_o);
    
    // Test Case 3: Test reset functionality
    #10 reset = 1; $display("%0t\t%b\t%b\t%b", $time, reset, x_i, sr_o);
    #10 reset = 0; $display("%0t\t%b\t%b\t%b", $time, reset, x_i, sr_o);
    
    // Test Case 4: Shift in all 1s
    #10 x_i = 1; $display("%0t\t%b\t%b\t%b", $time, reset, x_i, sr_o);
    #10 x_i = 1; $display("%0t\t%b\t%b\t%b", $time, reset, x_i, sr_o);
    #10 x_i = 1; $display("%0t\t%b\t%b\t%b", $time, reset, x_i, sr_o);
    #10 x_i = 1; $display("%0t\t%b\t%b\t%b", $time, reset, x_i, sr_o);
    
    // Wait and finish
    #20;
    $display("\nTestbench completed successfully!");
    $finish;
end

// Optional: Generate VCD file for waveform viewing
initial begin
    $dumpfile("shift_register.vcd");
    $dumpvars(0, Shift_Register_tb);
end

endmodule