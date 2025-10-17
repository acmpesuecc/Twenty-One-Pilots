module Edge_Detector (
    input  wire    clk,            
    input  wire    reset,          
    input  wire    a_i,            
    output wire    rising_edge_o,  
    output wire    falling_edge_o 
);

    reg a_delayed;


    always @(posedge clk) begin
        if (reset) begin
            a_delayed <= 1'b0;
        end else begin
            a_delayed <= a_i;
        end
    end


    assign rising_edge_o  = a_i & ~a_delayed;  
    assign falling_edge_o = ~a_i & a_delayed;  

endmodule