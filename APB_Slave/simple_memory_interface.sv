module Simple_Memory_Interface (
  input       wire        clk,
  input       wire        reset,

  input       wire        req_i,
  input       wire        req_rnw_i,    // 1 for read, 0 for write
  input       wire[3:0]   req_addr_i,
  input       wire[31:0]  req_wdata_i,
  output      reg         req_ready_o,
  output      wire[31:0]  req_rdata_o   // Changed to wire for combinational assignment
);

  // Memory array
  logic [15:0][31:0] mem;

  // Ready logic: Acknowledge the request on the next clock cycle
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      req_ready_o <= 1'b0;
    end else begin
      req_ready_o <= req_i;
    end
  end

  // Write logic: Perform the write when the request is acknowledged
  always @(posedge clk) begin
    if (req_i && req_ready_o && !req_rnw_i) begin // Write operation
      mem[req_addr_i] <= req_wdata_i;
    end
  end

  // Read logic: Combinational read
  assign req_rdata_o = mem[req_addr_i];

endmodule