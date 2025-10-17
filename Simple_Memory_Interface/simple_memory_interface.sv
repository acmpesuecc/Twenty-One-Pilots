// Simple Memory Interface
// 16x32 memory with valid/ready protocol

module Simple_Memory_Interface (
  input       wire        clk,
  input       wire        reset,

  input       wire        req_i,        // Valid request input remains asserted until ready is seen
  input       wire        req_rnw_i,    // Read-not-write (1-read, 0-write)
  input       wire[3:0]   req_addr_i,   // 4-bit Memory address
  input       wire[31:0]  req_wdata_i,  // 32-bit write data
  output      reg         req_ready_o,  // Ready output when request accepted
  output      reg[31:0]   req_rdata_o   // Read data from memory
);

  // Memory array
  reg [31:0] mem [0:15];
  
  // Random delay generation
  reg [2:0] delay_counter;
  reg [2:0] random_delay;
  
  // LFSR for random delay generation (3-bit)
  reg [2:0] lfsr;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      lfsr <= 3'b101;  // Non-zero seed
    end else begin
      // Simple LFSR: feedback from bits [2] and [1]
      lfsr <= {lfsr[1:0], lfsr[2] ^ lfsr[1]};
    end
  end
  
  // Generate random delay (1 to 7 cycles)
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      random_delay <= 3'd1;
    end else if (req_i && !req_ready_o && delay_counter == 0) begin
      random_delay <= (lfsr == 3'b000) ? 3'd1 : lfsr;
    end
  end
  
  // Delay counter and ready generation
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      delay_counter <= 3'd0;
      req_ready_o <= 1'b0;
      req_rdata_o <= 32'd0;
    end else begin
      if (req_i) begin
        if (delay_counter == 0) begin
          // Start new request
          delay_counter <= random_delay;
          req_ready_o <= 1'b0;
        end else if (delay_counter == 1) begin
          // Request is ready
          delay_counter <= 3'd0;
          req_ready_o <= 1'b1;
          
          // Perform memory operation
          if (req_rnw_i) begin
            // Read operation
            req_rdata_o <= mem[req_addr_i];
          end else begin
            // Write operation
            mem[req_addr_i] <= req_wdata_i;
          end
        end else begin
          // Counting down
          delay_counter <= delay_counter - 1'b1;
          req_ready_o <= 1'b0;
        end
      end else begin
        delay_counter <= 3'd0;
        req_ready_o <= 1'b0;
      end
    end
  end
  
  // Initialize memory
  integer i;
  initial begin
    for (i = 0; i < 16; i = i + 1) begin
      mem[i] = 32'd0;
    end
  end

endmodule
