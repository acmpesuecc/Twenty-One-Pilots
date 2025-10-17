// tb.sv
// Testbench for Sequence_Detector (Verilog-2001 compatible)
`timescale 1ns/1ps

module tb_Sequence_Detector();
    reg clk;
    reg reset;
    reg x_i;
    wire det_o;

    // Instantiate DUT
    Sequence_Detector dut (
        .clk(clk),
        .reset(reset),
        .x_i(x_i),
        .det_o(det_o)
    );

    // Testbench constants
    reg [11:0] PATTERN = 12'b1110_1101_1011;
    reg [9:0] OVERLAP_APPEND = 10'b10_1101_1011;

    // Clock generator
    initial clk = 0;
    always #5 clk = ~clk;

    // Helper task
    task drive_bit(input b);
        begin
            x_i = b;
            @(posedge clk);
        end
    endtask

    initial begin
        // --- Declarations must be at the top of the block ---
        integer i;

        // --- Setup Waveform Dumping ---
        $dumpfile("sequence_detector.vcd");
        $dumpvars(0, tb_Sequence_Detector);

        // --- Test Sequence ---
        $display("Starting Test...");

        // 1. Assert reset
        reset = 1;
        x_i = 0;
        repeat (2) @(posedge clk);
        reset = 0;
        @(posedge clk);
        $display("Reset released. Driving idle bits.");

        // 2. Drive idle bits
        repeat (5) drive_bit(0);

        // 3. Drive the first clean sequence
        $display("Driving first full pattern...");
        for (i = 11; i >= 0; i = i - 1) begin
            drive_bit(PATTERN[i]);
        end

        // 4. Drive a true overlapping sequence
        $display("Driving overlapping sequence part...");
        for (i = 9; i >= 0; i = i - 1) begin
            drive_bit(OVERLAP_APPEND[i]);
        end

        // 5. Drive random data
        $display("Driving random data...");
        repeat (20) drive_bit($random % 2); // Using $random for max compatibility

        // 6. Drive another clean sequence
        $display("Driving second full pattern...");
        for (i = 11; i >= 0; i = i - 1) begin
            drive_bit(PATTERN[i]);
        end

        // --- Finish Simulation ---
        $display("Test finished.");
        repeat (5) @(posedge clk);
        $finish;
    end

endmodule