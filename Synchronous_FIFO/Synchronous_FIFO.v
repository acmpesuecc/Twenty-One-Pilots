module Synchronous_FIFO #(
  parameter DEPTH   = 4,    // FIFO depth
  parameter DATA_W  = 8     // Data width
)(
  input  wire                 clk,
  input  wire                 reset,

  input  wire                 push_i,
  input  wire [DATA_W-1:0]    push_data_i,

  input  wire                 pop_i,
  output wire [DATA_W-1:0]    pop_data_o,

  output wire                 full_o,
  output wire                 empty_o
);

  // Internal memory
  reg [DATA_W-1:0] mem [0:DEPTH-1];

  // Pointers and counter
  reg [$clog2(DEPTH)-1:0] w_ptr;
  reg [$clog2(DEPTH)-1:0] r_ptr;
  reg [$clog2(DEPTH+1)-1:0] count;

  // Write logic
  always @(posedge clk or posedge reset) begin
    if (reset)
      w_ptr <= 0;
    else if (push_i && !full_o) begin
      mem[w_ptr] <= push_data_i;
      w_ptr <= w_ptr + 1'b1;
    end
  end

  // Read logic
  always @(posedge clk or posedge reset) begin
    if (reset)
      r_ptr <= 0;
    else if (pop_i && !empty_o)
      r_ptr <= r_ptr + 1'b1;
  end

  // Count update logic
  always @(posedge clk or posedge reset) begin
    if (reset)
      count <= 0;
    else begin
      case ({push_i && !full_o, pop_i && !empty_o})
        2'b10: count <= count + 1'b1; // Push only
        2'b01: count <= count - 1'b1; // Pop only
        default: count <= count;      // No change or both active
      endcase
    end
  end

  // Outputs
  assign pop_data_o = mem[r_ptr];
  assign full_o     = (count == DEPTH);
  assign empty_o    = (count == 0);

endmodule