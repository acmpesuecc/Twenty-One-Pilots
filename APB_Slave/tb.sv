`timescale 1ns / 1ps

module APB_Slave_tb;

  // Inputs
  logic        clk;
  logic        reset;
  logic        psel_i;
  logic        penable_i;
  logic [9:0]  paddr_i;
  logic        pwrite_i;
  logic [31:0] pwdata_i;

  // Outputs
  wire [31:0] prdata_o;
  wire        pready_o;

  // Instantiate the DUT
  APB_Slave dut (
    .clk(clk),
    .reset(reset),
    .psel_i(psel_i),
    .penable_i(penable_i),
    .paddr_i(paddr_i),
    .pwrite_i(pwrite_i),
    .pwdata_i(pwdata_i),
    .prdata_o(prdata_o),
    .pready_o(pready_o)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test sequence
  initial begin
    // Initialize inputs
    reset = 1;
    psel_i = 0;
    penable_i = 0;
    paddr_i = 0;
    pwrite_i = 0;
    pwdata_i = 0;

    // Apply reset
    #10;
    reset = 0;
    #10;

    // -- Write to memory --
    psel_i = 1;
    paddr_i = 4'hA;
    pwrite_i = 1;
    pwdata_i = 32'hDEADBEEF;
    @(posedge clk);
    penable_i = 1; // Assert penable in the ACCESS phase
    
    // Wait for the transaction to be acknowledged
    wait (pready_o);
    @(posedge clk);

    // De-assert signals to end the transaction
    psel_i = 0;
    penable_i = 0;

    // -- Read from memory --
    #20;
    psel_i = 1;
    paddr_i = 4'hA;
    pwrite_i = 0; // Set for a read operation
    @(posedge clk);
    penable_i = 1;
    
    // Wait for acknowledgement
    wait (pready_o);

    // Check the output on the next clock edge
    @(posedge clk);
    if (prdata_o == 32'hDEADBEEF) begin
      $display("SUCCESS: Read data matches written data!");
    end else begin
      $error("FAILURE: Read data mismatch! Expected 0x%h, Got 0x%h", 32'hDEADBEEF, prdata_o);
    end

    psel_i = 0;
    penable_i = 0;
    
    #100;
    $finish;
  end

endmodule