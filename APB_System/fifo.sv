// FIFO Module
// Parameterized FIFO for buffering read/write requests

module fifo #(
  parameter DEPTH = 16,
  parameter WIDTH = 2
) (
  input  wire              clk,
  input  wire              reset,
  input  wire              write_en,
  input  wire              read_en,
  input  wire [WIDTH-1:0]  write_data,
  output reg  [WIDTH-1:0]  read_data,
  output wire              full,
  output wire              empty
);

  // FIFO memory
  reg [WIDTH-1:0] fifo_mem [0:DEPTH-1];
  
  // Read and write pointers
  reg [$clog2(DEPTH):0] write_ptr;
  reg [$clog2(DEPTH):0] read_ptr;
  
  // Full and empty flags
  assign full = (write_ptr[$clog2(DEPTH)] != read_ptr[$clog2(DEPTH)]) && 
                (write_ptr[$clog2(DEPTH)-1:0] == read_ptr[$clog2(DEPTH)-1:0]);
  assign empty = (write_ptr == read_ptr);
  
  // Write operation
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      write_ptr <= 0;
    end else begin
      if (write_en && !full) begin
        fifo_mem[write_ptr[$clog2(DEPTH)-1:0]] <= write_data;
        write_ptr <= write_ptr + 1;
      end
    end
  end
  
  // Read operation
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      read_ptr <= 0;
      read_data <= 0;
    end else begin
      if (read_en && !empty) begin
        read_data <= fifo_mem[read_ptr[$clog2(DEPTH)-1:0]];
        read_ptr <= read_ptr + 1;
      end
    end
  end

endmodule
