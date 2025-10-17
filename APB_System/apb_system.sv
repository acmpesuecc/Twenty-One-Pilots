// APB System Top Module
// Integrates Arbiter, FIFO, APB Master, APB Slave, and Memory Interface

module APB_System (
  input       wire        clk,
  input       wire        reset,

  input       wire        read_i,       // Sends a read request when asserted
  input       wire        write_i,      // Sends a write request when asserted

  output      wire        rd_valid_o,   // Should be asserted whenever read data is valid
  output      wire[31:0]  rd_data_o     // Read data
);

  // Arbiter to FIFO signals
  wire        arb_write_en;
  wire [1:0]  arb_data;
  
  // FIFO signals
  wire        fifo_full;
  wire        fifo_empty;
  wire        fifo_read_en;
  wire [1:0]  fifo_read_data;
  
  // APB Master to APB Slave signals
  wire        psel;
  wire        penable;
  wire [31:0] paddr;
  wire        pwrite;
  wire [31:0] pwdata;
  wire        pready;
  wire [31:0] prdata;
  
  // APB Slave to Memory Interface signals
  wire        mem_req;
  wire        mem_req_rnw;
  wire [3:0]  mem_req_addr;
  wire [31:0] mem_req_wdata;
  wire        mem_req_ready;
  wire [31:0] mem_req_rdata;
  
  // Command to APB Master
  reg [1:0]  cmd_to_master;
  reg [1:0]  cmd_reg;
  
  // Master state tracking for FIFO read enable
  reg         master_busy;
  reg         fifo_read_done;
  
  // State machine for controlling FIFO reads and command generation
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      master_busy <= 1'b0;
      cmd_to_master <= 2'b00;
      cmd_reg <= 2'b00;
      fifo_read_done <= 1'b0;
    end else begin
      if (!master_busy && !fifo_empty) begin
        // Start new command from FIFO
        master_busy <= 1'b1;
        fifo_read_done <= 1'b0;
      end else if (master_busy && !fifo_read_done) begin
        // Latch command from FIFO
        cmd_reg <= fifo_read_data;
        cmd_to_master <= fifo_read_data;
        fifo_read_done <= 1'b1;
      end else if (master_busy && fifo_read_done) begin
        // Wait for transaction to complete
        if ((psel && penable && pready) || (cmd_to_master == 2'b00)) begin
          master_busy <= 1'b0;
          cmd_to_master <= 2'b00;
          fifo_read_done <= 1'b0;
        end else begin
          cmd_to_master <= cmd_reg;
        end
      end else begin
        cmd_to_master <= 2'b00;
      end
    end
  end
  
  // FIFO read enable: read when starting new transaction
  assign fifo_read_en = !master_busy && !fifo_empty;
  
  // Instantiate Arbiter
  arbiter arb_inst (
    .clk          (clk),
    .reset        (reset),
    .read_i       (read_i),
    .write_i      (write_i),
    .fifo_full    (fifo_full),
    .arb_write_en (arb_write_en),
    .arb_read_en  (),              // Not used in this design
    .arb_data     (arb_data)
  );
  
  // Instantiate FIFO
  fifo #(
    .DEPTH(16),
    .WIDTH(2)
  ) fifo_inst (
    .clk        (clk),
    .reset      (reset),
    .write_en   (arb_write_en),
    .read_en    (fifo_read_en),
    .write_data (arb_data),
    .read_data  (fifo_read_data),
    .full       (fifo_full),
    .empty      (fifo_empty)
  );
  
  // Instantiate APB Master
  APB_Master apb_master_inst (
    .clk        (clk),
    .reset      (reset),
    .cmd_i      (cmd_to_master),
    .psel_o     (psel),
    .penable_o  (penable),
    .paddr_o    (paddr),
    .pwrite_o   (pwrite),
    .pwdata_o   (pwdata),
    .pready_i   (pready),
    .prdata_i   (prdata),
    .rd_valid_o (rd_valid_o),
    .rd_data_o  (rd_data_o)
  );
  
  // Instantiate APB Slave
  APB_Slave apb_slave_inst (
    .clk            (clk),
    .reset          (reset),
    .psel_i         (psel),
    .penable_i      (penable),
    .paddr_i        (paddr[9:0]),
    .pwrite_i       (pwrite),
    .pwdata_i       (pwdata),
    .prdata_o       (prdata),
    .pready_o       (pready),
    .mem_req_o      (mem_req),
    .mem_req_rnw_o  (mem_req_rnw),
    .mem_req_addr_o (mem_req_addr),
    .mem_req_wdata_o(mem_req_wdata),
    .mem_req_ready_i(mem_req_ready),
    .mem_req_rdata_i(mem_req_rdata)
  );
  
  // Instantiate Simple Memory Interface
  Simple_Memory_Interface mem_inst (
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
