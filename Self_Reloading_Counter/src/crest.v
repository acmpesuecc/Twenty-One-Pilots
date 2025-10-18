module Self_Reloading_Counter (
    input  wire        clk,
    input  wire        reset,
    input  wire        load_i,      // Load enable
    input  wire [3:0]  load_val_i,  // 4-bit load value
    output reg  [3:0]  count_o      // 4-bit counter output
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count_o <= 4'b0000; // Reset counter to 0
        end
        else if (load_i) begin
            count_o <= load_val_i; // Load external value
        end
        else begin
            count_o <= count_o + 1; // Increment counter
        end
    end

endmodule