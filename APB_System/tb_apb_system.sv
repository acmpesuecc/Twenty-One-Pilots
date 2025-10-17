// APB System Testbench
// Comprehensive testbench to verify the APB System functionality

`timescale 1ns/1ps

module tb_apb_system;

  // Clock and reset
  reg clk;
  reg reset;
  
  // DUT inputs
  reg read_i;
  reg write_i;
  
  // DUT outputs
  wire rd_valid_o;
  wire [31:0] rd_data_o;
  
  // Test variables
  integer test_count;
  integer pass_count;
  integer fail_count;
  
  // Instantiate DUT
  APB_System dut (
    .clk        (clk),
    .reset      (reset),
    .read_i     (read_i),
    .write_i    (write_i),
    .rd_valid_o (rd_valid_o),
    .rd_data_o  (rd_data_o)
  );
  
  // Clock generation (10ns period = 100MHz)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  // Test execution
  initial begin
    // Initialize signals
    reset = 1;
    read_i = 0;
    write_i = 0;
    test_count = 0;
    pass_count = 0;
    fail_count = 0;
    
    // Create VCD dump for waveform viewing
    $dumpfile("apb_system.vcd");
    $dumpvars(0, tb_apb_system);
    
    // Display test start
    $display("===============================================");
    $display("APB System Testbench Started");
    $display("===============================================");
    
    // Reset sequence
    #20;
    reset = 0;
    #20;
    
    // Test 1: Single write request
    $display("\nTest 1: Single Write Request");
    test_count = test_count + 1;
    @(posedge clk);
    write_i = 1;
    @(posedge clk);
    write_i = 0;
    #200;
    $display("Test 1 completed");
    
    // Test 2: Single read request
    $display("\nTest 2: Single Read Request");
    test_count = test_count + 1;
    @(posedge clk);
    read_i = 1;
    @(posedge clk);
    read_i = 0;
    
    // Wait for read data to be valid
    wait(rd_valid_o);
    @(posedge clk);
    $display("Read data received: 0x%h", rd_data_o);
    #200;
    $display("Test 2 completed");
    
    // Test 3: Multiple writes (test FIFO buffering)
    $display("\nTest 3: Multiple Write Requests (FIFO Test)");
    test_count = test_count + 1;
    repeat(5) begin
      @(posedge clk);
      write_i = 1;
      @(posedge clk);
      write_i = 0;
      @(posedge clk);
    end
    #500;
    $display("Test 3 completed");
    
    // Test 4: Multiple reads
    $display("\nTest 4: Multiple Read Requests");
    test_count = test_count + 1;
    repeat(5) begin
      @(posedge clk);
      read_i = 1;
      @(posedge clk);
      read_i = 0;
      
      // Wait for read valid
      wait(rd_valid_o);
      @(posedge clk);
      $display("Read data %0d: 0x%h", test_count, rd_data_o);
      #100;
    end
    $display("Test 4 completed");
    
    // Test 5: Write priority test (simultaneous read and write)
    $display("\nTest 5: Write Priority Test");
    test_count = test_count + 1;
    @(posedge clk);
    read_i = 1;
    write_i = 1;
    @(posedge clk);
    read_i = 0;
    write_i = 0;
    #300;
    $display("Test 5 completed - Write should be processed first");
    
    // Test 6: Read after write (data increment test)
    $display("\nTest 6: Read-Write-Read Sequence (Increment Test)");
    test_count = test_count + 1;
    
    // First read
    @(posedge clk);
    read_i = 1;
    @(posedge clk);
    read_i = 0;
    wait(rd_valid_o);
    @(posedge clk);
    $display("Initial read data: 0x%h", rd_data_o);
    #100;
    
    // Write (should increment)
    @(posedge clk);
    write_i = 1;
    @(posedge clk);
    write_i = 0;
    #300;
    
    // Second read
    @(posedge clk);
    read_i = 1;
    @(posedge clk);
    read_i = 0;
    wait(rd_valid_o);
    @(posedge clk);
    $display("After write read data: 0x%h (should be incremented)", rd_data_o);
    #100;
    $display("Test 6 completed");
    
    // Test 7: FIFO full test (16 requests)
    $display("\nTest 7: FIFO Full Test (16 requests)");
    test_count = test_count + 1;
    repeat(16) begin
      @(posedge clk);
      write_i = 1;
      @(posedge clk);
      write_i = 0;
    end
    
    // Try one more (should be blocked if FIFO is full)
    @(posedge clk);
    write_i = 1;
    @(posedge clk);
    write_i = 0;
    
    $display("Sent 17 write requests (FIFO depth is 16)");
    #2000;
    $display("Test 7 completed");
    
    // Test 8: Alternating read/write
    $display("\nTest 8: Alternating Read and Write");
    test_count = test_count + 1;
    repeat(4) begin
      @(posedge clk);
      write_i = 1;
      @(posedge clk);
      write_i = 0;
      #200;
      
      @(posedge clk);
      read_i = 1;
      @(posedge clk);
      read_i = 0;
      wait(rd_valid_o);
      @(posedge clk);
      $display("Read data: 0x%h", rd_data_o);
      #200;
    end
    $display("Test 8 completed");
    
    // Test 9: Stress test - rapid requests
    $display("\nTest 9: Stress Test - Rapid Requests");
    test_count = test_count + 1;
    repeat(10) begin
      @(posedge clk);
      if ($random % 2)
        write_i = 1;
      else
        read_i = 1;
      @(posedge clk);
      write_i = 0;
      read_i = 0;
    end
    #1000;
    $display("Test 9 completed");
    
    // Final summary
    #100;
    $display("\n===============================================");
    $display("APB System Testbench Completed");
    $display("Total Tests: %0d", test_count);
    $display("===============================================");
    
    $finish;
  end
  
  // Monitor for read valid
  always @(posedge clk) begin
    if (rd_valid_o) begin
      $display("[Time=%0t] Read Valid: Data = 0x%h", $time, rd_data_o);
    end
  end
  
  // Timeout watchdog
  initial begin
    #50000;
    $display("\n*** ERROR: Testbench timeout ***");
    $finish;
  end

endmodule
