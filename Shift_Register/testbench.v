// Testbench for the 4-bit Shift Register module
// This file tests the functionality of Shift_Register.v

`timescale 1ns/1ps

module testbench;
    // --- Signals needed for the testbench ---
    // These `reg` signals drive the inputs of your module-under-test (DUT)
    reg clk;
    reg reset;
    reg x_i;

    // These `wire` signals monitor the outputs of your DUT
    wire [3:0] sr_o;

    // --- Instantiate the module under test (DUT) ---
    // This connects the testbench signals to the module's ports
    Shift_Register DUT (
        .clk(clk),
        .reset(reset),
        .x_i(x_i),
        .sr_o(sr_o)
    );

    // --- Clock generation ---
    // The `initial` and `forever` blocks create a free-running clock signal
    // It starts at 0 and toggles every 5 time units (5 ns), giving a 10 ns period.
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // --- Test scenario ---
    // The `initial` block defines the test sequence for inputs
    initial begin
        // --- 1. Generate waveform data ---
        // These system tasks tell the simulator to create a VCD file
        // that can be viewed in a waveform viewer like GTKWave.
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);

        // --- 2. Initial state and reset ---
        reset = 1;     // Assert reset
        x_i = 0;       // Set x_i to a known value
        #10;           // Hold reset for 10 ns (one full clock cycle)
        reset = 0;     // De-assert reset
        #10;           // Wait for one clock cycle to observe a cleared state

        // --- 3. Shift in a sequence of bits ---
        // The following sequence shifts in the binary pattern '1011'
        // First bit: '1'
        x_i = 1;
        #10;

        // Second bit: '0'
        x_i = 0;
        #10;

        // Third bit: '1'
        x_i = 1;
        #10;

        // Fourth bit: '1'
        x_i = 1;
        #10;

        // --- 4. Final state and simulation end ---
        // Wait a few more cycles to observe the final state
        #20;

        // End the simulation
        $finish;
    end

endmodule
