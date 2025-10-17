module APB_Slave (
  // APB Interface
  input         wire        clk,
  input         wire        reset,
  input         wire        psel_i,
  input         wire        penable_i,
  input         wire [9:0]  paddr_i,
  input         wire        pwrite_i,
  input         wire [31:0] pwdata_i,
  output        wire [31:0] prdata_o,
  output        wire        pready_o
);

  // Instantiate the Simple_Memory_Interface
  Simple_Memory_Interface mem_inst (
    .clk(clk),
    .reset(reset),
    .req_i(psel_i & penable_i),
    .req_rnw_i(~pwrite_i),
    .req_addr_i(paddr_i[3:0]),
    .req_wdata_i(pwdata_i),
    .req_ready_o(pready_o),
    .req_rdata_o(prdata_o)
  );

endmodule