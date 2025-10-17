module Simple_Memory_Interface (
  input       wire        clk,
  input       wire        reset,

  input       wire        req_i,        // Valid request input remains asserted until ready is seen
  input       wire        req_rnw_i,    // Read-not-write (1-read, 0-write)
  input       wire[3:0]   req_addr_i,   // 4-bit Memory address
  input       wire[31:0]  req_wdata_i,  // 32-bit write data
  output      wire        req_ready_o,  // Ready output when request accepted
  output      wire[31:0]  req_rdata_o   // Read data from memory
);

  // Memory array
  logic [31:0] mem [0:15];
  
  // Internal signals
  logic [2:0] delay_counter;
  logic [2:0] random_delay;
  logic       pending_request;
  logic [3:0] saved_addr;
  logic       saved_rnw;
  logic [31:0] saved_wdata;
  logic [7:0] lfsr;
  
  // Generate random delay using LFSR
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      lfsr <= 8'hA5;
    end else if (req_ready_o || !pending_request) begin
      lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
    end
  end
  
  // Request handling and delay counter
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      delay_counter <= 3'b0;
      random_delay <= 3'b1;
      pending_request <= 1'b0;
      saved_addr <= 4'b0;
      saved_rnw <= 1'b0;
      saved_wdata <= 32'b0;
      
      // Initialize memory
      for (int i = 0; i < 16; i++) begin
        mem[i] <= 32'b0;
      end
    end else begin
      if (pending_request) begin
        // Count down delay
        if (delay_counter != 3'b0) begin
          delay_counter <= delay_counter - 1;
        end
        
        // When ready is generated, process request
        if (req_ready_o) begin
          pending_request <= 1'b0;
          
          // Write operation
          if (!saved_rnw) begin
            mem[saved_addr] <= saved_wdata;
          end
        end
      end else if (req_i) begin
        // New request - capture parameters and start random delay
        pending_request <= 1'b1;
        saved_addr <= req_addr_i;
        saved_rnw <= req_rnw_i;
        saved_wdata <= req_wdata_i;
        
        // Generate random delay (1-7 cycles) from LFSR
        random_delay <= (lfsr[2:0] == 3'b0) ? 3'b1 : lfsr[2:0];
        delay_counter <= random_delay;
      end
    end
  end
  
  // Output assignments
  assign req_ready_o = pending_request && (delay_counter == 3'b0);
  assign req_rdata_o = mem[saved_addr];

endmodule
