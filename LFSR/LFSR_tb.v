// Testbench for 4-bit LFSR
`timescale 1ns/1ps

module tb_LFSR;

    // Testbench signals
    reg clk;
    reg reset;
    wire [3:0] lfsr_o;
    
    // For tracking sequence
    reg [3:0] sequence [0:15];
    integer i;
    integer cycle_count;
    
    // Instantiate the LFSR
    LFSR dut (
        .clk(clk),
        .reset(reset),
        .lfsr_o(lfsr_o)
    );
    
    // Clock generation (10ns period = 100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test sequence
    initial begin
        // Initialize
        reset = 1;
        cycle_count = 0;
        
        $display("\n=== 4-bit LFSR Testbench ===");
        $display("Feedback: bit0 = bit1 XOR bit3\n");
        $display("Cycle\tReset\tLFSR_Output\tBinary");
        $display("-----\t-----\t-----------\t------");
        
        // Apply reset
        #10 reset = 0;
        
        // Monitor LFSR output for multiple cycles
        for (i = 0; i < 20; i = i + 1) begin
            @(posedge clk);
            #1; // Small delay for signal stability
            $display("%0d\t%b\t%h\t\t%b", cycle_count, reset, lfsr_o, lfsr_o);
            sequence[cycle_count % 16] = lfsr_o;
            cycle_count = cycle_count + 1;
        end
        
        // Test reset functionality
        $display("\n--- Testing Reset ---");
        reset = 1;
        #10 reset = 0;
        @(posedge clk);
        #1;
        $display("After reset: LFSR = %b (should be 0001)", lfsr_o);
        
        // Continue for a few more cycles
        $display("\n--- Continuing Sequence ---");
        for (i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
            #1;
            $display("%0d\t%b\t%h\t\t%b", cycle_count, reset, lfsr_o, lfsr_o);
            cycle_count = cycle_count + 1;
        end
        
        // Display sequence period
        $display("\n--- Sequence Analysis ---");
        $display("The LFSR generates a pseudo-random sequence.");
        $display("With XOR feedback from bit1 and bit3, the maximum");
        $display("sequence length is 15 states (2^4 - 1).");
        $display("\nNote: State 0000 is not part of the sequence");
        $display("(would lock up the LFSR).");
        
        $display("\n=== Test Complete ===\n");
        #20 $finish;
    end
    
    // Waveform dump
    initial begin
        $dumpfile("lfsr.vcd");
        $dumpvars(0, tb_LFSR);
    end
    
    // Check for lockup condition (all zeros)
    always @(posedge clk) begin
        if (!reset && lfsr_o == 4'b0000) begin
            $display("ERROR at time %0t: LFSR locked up at state 0000!", $time);
        end
    end

endmodule