module Synchronous_FIFO #(
  parameter DEPTH   = 4,
  parameter DATA_W  = 1
)(
  input         wire              clk,
  input         wire              reset,

  input         wire              push_i,
  input         wire[DATA_W-1:0]  push_data_i,

  input         wire              pop_i,
  output        wire[DATA_W-1:0]  pop_data_o,

  output        wire              full_o,
  output        wire              empty_o
);

logic [DATA_W-1:0] mem [0:DEPTH-1];
logic [$clog2(DEPTH)-1:0] w_ptr, r_ptr;
logic [$clog2(DEPTH+1)-1:0] count;

//write
always@(posedge clk or posedge reset) begin
    if(reset) begin
        w_ptr <= 0;
    end 
    else if(push_i && !full_o) begin
      mem[w_ptr] <= push_data_i;
      w_ptr <= w_ptr + 1;
    end
  end

//read
always@(posedge clk or posedge reset) begin
    if(reset) begin
        r_ptr <= 0;
    end 
    else if(pop_i && !empty_o) begin
        r_ptr <= r_ptr + 1;
    end
  end

  always@(posedge clk or posedge reset) begin
    if(reset) begin
      count <= 0;
    end 
    else begin
        if(push_i && !full_o && !(pop_i && !empty_o))
            count <= count + 1;
        else if(pop_i && !empty_o && !(push_i && !full_o))
            count <= count - 1;
    end
  end

assign pop_data_o = mem[r_ptr];  
assign full_o  = (count==DEPTH);
assign empty_o = (count==0);

endmodule