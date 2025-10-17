module edge_detector_tb;
    reg clk;
    reg reset;
    reg a_i;
    reg [1:0] edge_type_i;
    wire rising_edge_o;
    wire falling_edge_o;
    
    edge_detector dut (
        .clk(clk),
        .reset(reset),
        .a_i(a_i),
        .edge_type_i(edge_type_i),
        .rising_edge_o(rising_edge_o),
        .falling_edge_o(falling_edge_o)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        reset = 0;
        a_i = 0;
        edge_type_i = 2'b11;
        
        #20 reset = 1;
        
        #10 a_i = 1;
        #10 a_i = 0;
        #10 a_i = 1;
        #10 a_i = 1;
        #10 a_i = 0;
        
        #50 $finish;
    end
endmodule