// Testbench for 4-bit Parallel to Serial Converter
`timescale 1ns/1ps

module tb_parallel_to_serial;

    // Testbench signals
    reg clk;
    reg rst;
    reg load;
    reg [3:0] p_data;
    wire s_data;
    wire valid;
    wire empty;

    // Instantiate the DUT (Device Under Test)
    parallel_to_serial dut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .p_data(p_data),
        .s_data(s_data),
        .valid(valid),
        .empty(empty)
    );

    // Clock generation (10ns period = 100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize signals
        rst = 0;
        load = 0;
        p_data = 4'b0000;

        // Display header
        $display("Time\tRst\tLoad\tP_Data\tS_Data\tValid\tEmpty\tBit_Count");
        $monitor("%0t\t%b\t%b\t%b\t%b\t%b\t%b", 
                 $time, rst, load, p_data, s_data, valid, empty);

        // Test 1: Reset
        #10 rst = 1;
        #10 rst = 0;
        $display("\n--- Test 1: Reset Complete ---");

        // Test 2: Load data 1010
        #10 p_data = 4'b1010;
        load = 1;
        #10 load = 0;
        $display("\n--- Test 2: Loading 1010 ---");
        
        // Wait for all bits to be transmitted
        #50;

        // Test 3: Load data 1111
        #10 p_data = 4'b1111;
        load = 1;
        #10 load = 0;
        $display("\n--- Test 3: Loading 1111 ---");
        
        #50;

        // Test 4: Load data 0101
        #10 p_data = 4'b0101;
        load = 1;
        #10 load = 0;
        $display("\n--- Test 4: Loading 0101 ---");
        
        #50;

        // Test 5: Check empty state
        $display("\n--- Test 5: Verify Empty State ---");
        #20;

        $display("\n--- All Tests Complete ---");
        $finish;
    end

    // Waveform dump for viewing in GTKWave or similar
    initial begin
        $dumpfile("parallel_to_serial.vcd");
        $dumpvars(0, tb_parallel_to_serial);
    end

endmodule