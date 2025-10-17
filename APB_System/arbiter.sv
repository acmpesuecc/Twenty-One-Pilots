// Arbiter Module
// Prioritizes write requests over read requests

module arbiter (
  input  wire clk,
  input  wire reset,
  input  wire read_i,
  input  wire write_i,
  input  wire fifo_full,
  output reg  arb_write_en,
  output reg  arb_read_en,
  output reg  [1:0] arb_data
);

  // Command encoding
  localparam CMD_NOP   = 2'b00;
  localparam CMD_READ  = 2'b01;
  localparam CMD_WRITE = 2'b10;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      arb_write_en <= 1'b0;
      arb_read_en <= 1'b0;
      arb_data <= CMD_NOP;
    end else begin
      // Default: no operation
      arb_write_en <= 1'b0;
      arb_read_en <= 1'b0;
      arb_data <= CMD_NOP;
      
      // Prioritize writes over reads
      if (!fifo_full) begin
        if (write_i) begin
          arb_write_en <= 1'b1;
          arb_read_en <= 1'b0;
          arb_data <= CMD_WRITE;
        end else if (read_i) begin
          arb_write_en <= 1'b1;
          arb_read_en <= 1'b0;
          arb_data <= CMD_READ;
        end
      end
    end
  end

endmodule
