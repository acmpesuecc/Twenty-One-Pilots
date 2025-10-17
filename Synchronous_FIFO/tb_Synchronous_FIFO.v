`timescale 1ns/1ps

module tb_Synchronous_FIFO;

  parameter DEPTH  = 8;
  parameter DATA_W = 8;

  reg clk, reset;
  reg push_i, pop_i;
  reg [DATA_W-1:0] push_data_i;
  wire [DATA_W-1:0] pop_data_o;
  wire full_o, empty_o;

  // Instantiate the DUT (Device Under Test)
  Synchronous_FIFO #(
    .DEPTH(DEPTH),
    .DATA_W(DATA_W)
  ) dut (
    .clk(clk),
    .reset(reset),
    .push_i(push_i),
    .push_data_i(push_data_i),
    .pop_i(pop_i),
    .pop_data_o(pop_data_o),
    .full_o(full_o),
    .empty_o(empty_o)
  );

  // Clock generation (10ns period)
  always #5 clk = ~clk;

  initial begin
    $dumpfile("fifo.vcd");      // Output waveform file
    $dumpvars(0, tb_Synchronous_FIFO);

    clk = 0;
    reset = 1;
    push_i = 0;
    pop_i = 0;
    push_data_i = 0;

    // Release reset
    #10 reset = 0;

    $display("\n--- PUSHING 4 values ---");
    repeat(4) begin
      @(negedge clk);
      push_i = 1;
      push_data_i = $random;
      $display("PUSH: %0d", push_data_i);
    end
    @(negedge clk) push_i = 0;

    $display("\n--- POP 2 values ---");
    repeat(2) begin
      @(negedge clk);
      pop_i = 1;
      $display("POP : %0d", pop_data_o);
    end
    @(negedge clk) pop_i = 0;

    $display("\n--- PUSH 3 more values ---");
    repeat(3) begin
      @(negedge clk);
      push_i = 1;
      push_data_i = $random;
      $display("PUSH: %0d", push_data_i);
    end
    @(negedge clk) push_i = 0;

    $display("\n--- POP remaining until empty ---");
    while(!empty_o) begin
      @(negedge clk);
      pop_i = 1;
      $display("POP : %0d", pop_data_o);
    end
    @(negedge clk) pop_i = 0;

    #20;
    $display("\n--- Simulation Complete ---");
    $finish;
  end

endmodule
