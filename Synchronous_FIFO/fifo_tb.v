// Testbench for Synchronous FIFO
`timescale 1ns/1ps

module tb_sync_fifo;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter DEPTH = 16;
    parameter ADDR_WIDTH = 4;
    parameter CLK_PERIOD = 10;
    
    // Testbench signals
    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] wr_data;
    wire [DATA_WIDTH-1:0] rd_data;
    wire full;
    wire empty;
    wire [ADDR_WIDTH:0] data_count;
    
    // Instantiate the FIFO
    sync_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .full(full),
        .empty(empty),
        .data_count(data_count)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // Test sequence
    initial begin
        // Initialize signals
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        wr_data = 0;
        
        // Display header
        $display("\n=== Synchronous FIFO Testbench ===\n");
        $display("Time\tRst\tWr_En\tRd_En\tWr_Data\tRd_Data\tFull\tEmpty\tCount");
        $monitor("%0t\t%b\t%b\t%b\t%h\t%h\t%b\t%b\t%0d", 
                 $time, rst, wr_en, rd_en, wr_data, rd_data, full, empty, data_count);
        
        // Test 1: Reset
        #(CLK_PERIOD*2);
        rst = 0;
        #(CLK_PERIOD);
        $display("\n--- Test 1: Reset Complete ---");
        
        // Test 2: Write data to FIFO
        $display("\n--- Test 2: Writing 10 values to FIFO ---");
        repeat(10) begin
            @(posedge clk);
            wr_en = 1;
            wr_data = wr_data + 8'h11;
        end
        @(posedge clk);
        wr_en = 0;
        
        // Test 3: Read 5 values
        $display("\n--- Test 3: Reading 5 values from FIFO ---");
        #(CLK_PERIOD*2);
        repeat(5) begin
            @(posedge clk);
            rd_en = 1;
        end
        @(posedge clk);
        rd_en = 0;
        
        // Test 4: Simultaneous read and write
        $display("\n--- Test 4: Simultaneous Read and Write ---");
        #(CLK_PERIOD*2);
        repeat(5) begin
            @(posedge clk);
            wr_en = 1;
            rd_en = 1;
            wr_data = wr_data + 8'h11;
        end
        @(posedge clk);
        wr_en = 0;
        rd_en = 0;
        
        // Test 5: Fill FIFO completely
        $display("\n--- Test 5: Filling FIFO completely ---");
        #(CLK_PERIOD*2);
        wr_data = 8'hAA;
        repeat(20) begin  // Try to write more than capacity
            @(posedge clk);
            wr_en = 1;
            wr_data = wr_data + 1;
        end
        @(posedge clk);
        wr_en = 0;
        
        // Test 6: Empty FIFO completely
        $display("\n--- Test 6: Emptying FIFO completely ---");
        #(CLK_PERIOD*2);
        repeat(20) begin  // Try to read more than available
            @(posedge clk);
            rd_en = 1;
        end
        @(posedge clk);
        rd_en = 0;
        
        // Test 7: Check empty flag
        $display("\n--- Test 7: Verify Empty State ---");
        #(CLK_PERIOD*3);
        
        $display("\n=== All Tests Complete ===\n");
        #(CLK_PERIOD*5);
        $finish;
    end
    
    // Waveform dump
    initial begin
        $dumpfile("sync_fifo.vcd");
        $dumpvars(0, tb_sync_fifo);
    end
    
    // Check for overflow/underflow
    always @(posedge clk) begin
        if (wr_en && full)
            $display("WARNING at %0t: Write attempted when FIFO is FULL!", $time);
        if (rd_en && empty)
            $display("WARNING at %0t: Read attempted when FIFO is EMPTY!", $time);
    end

endmodule