module APB_Slave (
  input         wire        clk,
  input         wire        reset,
  input         wire        psel_i,
  input         wire        penable_i,
  input         wire[9:0]   paddr_i,
  input         wire        pwrite_i,
  input         wire[31:0]  pwdata_i,
  output        wire[31:0]  prdata_o,
  output        wire        pready_o
);

  wire          mem_req;
  wire          mem_req_rnw;
  wire [3:0]    mem_req_addr;
  wire [31:0]   mem_req_wdata;
  wire          mem_req_ready;
  wire [31:0]   mem_req_rdata;

  typedef enum logic [1:0] {
    IDLE    = 2'b00,
    SETUP   = 2'b01,
    ACCESS  = 2'b10
  } apb_state_t;

  apb_state_t  curr_state;
  apb_state_t  next_state;

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      curr_state <= IDLE;
    end else begin
      curr_state <= next_state;
    end
  end

  always_comb begin
    next_state = curr_state;
    
    case (curr_state)
      IDLE: begin
        if (psel_i && !penable_i)
          next_state = SETUP;
      end
      
      SETUP: begin
        if (psel_i && penable_i)
          next_state = ACCESS;
      end
      
      ACCESS: begin
        if (mem_req_ready)
          next_state = IDLE;
      end
      
      default: next_state = IDLE;
    endcase
  end


  assign mem_req = (curr_state == ACCESS);
  assign mem_req_rnw = !pwrite_i;
  assign mem_req_addr = paddr_i[3:0];  // Use lower 4 bits for memory addressing
  assign mem_req_wdata = pwdata_i;


  assign pready_o = (curr_state == ACCESS) && mem_req_ready;
  assign prdata_o = mem_req_rdata;


  Simple_Memory_Interface u_memory (
    .clk          (clk),
    .reset        (reset),
    .req_i        (mem_req),
    .req_rnw_i    (mem_req_rnw),
    .req_addr_i   (mem_req_addr),
    .req_wdata_i  (mem_req_wdata),
    .req_ready_o  (mem_req_ready),
    .req_rdata_o  (mem_req_rdata)
  );

endmodule