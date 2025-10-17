// Testbench for D Flip-Flop Module
// Tests all three variants: non-resettable, synchronous reset, asynchronous reset

`timescale 1ns/1ps

module tb_D_Flip_Flop;

    // Clock period definition
    parameter CLK_PERIOD = 10; // 10ns clock period (100MHz)

    // Testbench signals
    logic clk;
    logic reset;
    logic d_i;
    logic q_norst_o;
    logic q_syncrst_o;
    logic q_asyncrst_o;

    // Instantiate the DUT (Device Under Test)
    D_Flip_Flop dut (
        .clk(clk),
        .reset(reset),
        .d_i(d_i),
        .q_norst_o(q_norst_o),
        .q_syncrst_o(q_syncrst_o),
        .q_asyncrst_o(q_asyncrst_o)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Initialize signals
        reset = 0;
        d_i = 0;

        // Create VCD dump for waveform viewing
        $dumpfile("d_flip_flop.vcd");
        $dumpvars(0, tb_D_Flip_Flop);

        $display("========================================");
        $display("D Flip-Flop Testbench Started");
        $display("========================================");

        // Test 1: Initial state with no reset
        $display("\n[Test 1] Initial state (no reset)");
        #(CLK_PERIOD);
        $display("Time=%0t: d_i=%b, q_norst=%b, q_syncrst=%b, q_asyncrst=%b", 
                 $time, d_i, q_norst_o, q_syncrst_o, q_asyncrst_o);

        // Test 2: Apply D=1 and check all outputs
        $display("\n[Test 2] Apply D=1");
        d_i = 1;
        #(CLK_PERIOD);
        $display("Time=%0t: d_i=%b, q_norst=%b, q_syncrst=%b, q_asyncrst=%b", 
                 $time, d_i, q_norst_o, q_syncrst_o, q_asyncrst_o);
        
        // Test 3: Apply D=0 and check all outputs
        $display("\n[Test 3] Apply D=0");
        d_i = 0;
        #(CLK_PERIOD);
        $display("Time=%0t: d_i=%b, q_norst=%b, q_syncrst=%b, q_asyncrst=%b", 
                 $time, d_i, q_norst_o, q_syncrst_o, q_asyncrst_o);

        // Test 4: Toggle D multiple times
        $display("\n[Test 4] Toggle D input (1->0->1->0)");
        d_i = 1;
        #(CLK_PERIOD);
        $display("Time=%0t: d_i=%b, q_norst=%b, q_syncrst=%b, q_asyncrst=%b", 
                 $time, d_i, q_norst_o, q_syncrst_o, q_asyncrst_o);
        d_i = 0;
        #(CLK_PERIOD);
        $display("Time=%0t: d_i=%b, q_norst=%b, q_syncrst=%b, q_asyncrst=%b", 
                 $time, d_i, q_norst_o, q_syncrst_o, q_asyncrst_o);
        d_i = 1;
        #(CLK_PERIOD);
        $display("Time=%0t: d_i=%b, q_norst=%b, q_syncrst=%b, q_asyncrst=%b", 
                 $time, d_i, q_norst_o, q_syncrst_o, q_asyncrst_o);
        d_i = 0;
        #(CLK_PERIOD);
        $display("Time=%0t: d_i=%b, q_norst=%b, q_syncrst=%b, q_asyncrst=%b", 
                 $time, d_i, q_norst_o, q_syncrst_o, q_asyncrst_o);

        // Test 5: Synchronous Reset Test
        $display("\n[Test 5] Synchronous Reset Test");
        d_i = 1;
        #(CLK_PERIOD);
        $display("Time=%0t (before reset): d_i=%b, reset=%b, q_syncrst=%b", 
                 $time, d_i, reset, q_syncrst_o);
        
        reset = 1; // Assert reset
        #(CLK_PERIOD); // Wait for clock edge
        $display("Time=%0t (after reset): d_i=%b, reset=%b, q_syncrst=%b", 
                 $time, d_i, reset, q_syncrst_o);
        $display("NOTE: q_syncrst should be 0 (reset synchronous with clock)");
        
        reset = 0;
        #(CLK_PERIOD);
        $display("Time=%0t (reset deasserted): d_i=%b, reset=%b, q_syncrst=%b", 
                 $time, d_i, reset, q_syncrst_o);

        // Test 6: Asynchronous Reset Test
        $display("\n[Test 6] Asynchronous Reset Test");
        d_i = 1;
        #(CLK_PERIOD);
        $display("Time=%0t (before async reset): d_i=%b, reset=%b, q_asyncrst=%b", 
                 $time, d_i, reset, q_asyncrst_o);
        
        // Assert reset in middle of clock cycle to show asynchronous behavior
        #(CLK_PERIOD/4);
        reset = 1;
        #1; // Small delay to see immediate effect
        $display("Time=%0t (async reset immediate): d_i=%b, reset=%b, q_asyncrst=%b", 
                 $time, d_i, reset, q_asyncrst_o);
        $display("NOTE: q_asyncrst should be 0 immediately (asynchronous)");
        
        #(CLK_PERIOD);
        reset = 0;
        #(CLK_PERIOD);
        $display("Time=%0t (async reset deasserted): d_i=%b, reset=%b, q_asyncrst=%b", 
                 $time, d_i, reset, q_asyncrst_o);

        // Test 7: Verify non-resettable flop is unaffected by reset
        $display("\n[Test 7] Non-resettable flop with reset asserted");
        d_i = 1;
        #(CLK_PERIOD);
        $display("Time=%0t (D=1, no reset): q_norst=%b", $time, q_norst_o);
        
        reset = 1;
        d_i = 0;
        #(CLK_PERIOD);
        $display("Time=%0t (D=0, reset=1): q_norst=%b", $time, q_norst_o);
        $display("NOTE: q_norst should be 0 (follows D, ignores reset)");
        
        reset = 0;
        #(CLK_PERIOD);

        // Test 8: Final verification - all flops working correctly
        $display("\n[Test 8] Final verification");
        d_i = 1;
        #(CLK_PERIOD);
        $display("Time=%0t: All outputs should be 1", $time);
        $display("  q_norst=%b, q_syncrst=%b, q_asyncrst=%b", 
                 q_norst_o, q_syncrst_o, q_asyncrst_o);
        
        if (q_norst_o === 1'b1 && q_syncrst_o === 1'b1 && q_asyncrst_o === 1'b1) begin
            $display("  ✓ PASS: All outputs correct");
        end else begin
            $display("  ✗ FAIL: Output mismatch");
        end

        // End simulation
        $display("\n========================================");
        $display("D Flip-Flop Testbench Completed");
        $display("========================================");
        #(CLK_PERIOD*2);
        $finish;
    end

    // Monitor for continuous observation
    initial begin
        $monitor("Time=%0t | clk=%b reset=%b d_i=%b | q_norst=%b q_syncrst=%b q_asyncrst=%b", 
                 $time, clk, reset, d_i, q_norst_o, q_syncrst_o, q_asyncrst_o);
    end

endmodule