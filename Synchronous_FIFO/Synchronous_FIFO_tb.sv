module Synchronous_FIFO_tb();
parameter DEPTH   = 4;
parameter DATA_W  = 1;

logic clk, reset, push_i, pop_i, full_o, empty_o;
logic [DATA_W-1:0] push_data_i, pop_data_o;

Synchronous_FIFO #(DEPTH, DATA_W) fifo(clk, reset, push_i, push_data_i, pop_i, pop_data_o, full_o, empty_o);

initial clk=0;
always #5 clk=~clk;

initial begin
    reset=1;
    push_i=0;
    push_data_i=0;
    pop_i=0;
    
    #10 reset=0;
    @(negedge clk); push_i=1; push_data_i=1;
    @(negedge clk); push_i=0;
    @(negedge clk); push_i=1; push_data_i=0;
    @(negedge clk); push_i=0;
    @(negedge clk); push_i=1; push_data_i=0;
    @(negedge clk); push_i=0;
    @(negedge clk); push_i=1; push_data_i=1;
    @(negedge clk); push_i=0;

    #20; 
    repeat (4) begin
      @(negedge clk);
      pop_i=1;
      @(negedge clk);
      pop_i=0;
    end

    #20 $finish;   
end
endmodule