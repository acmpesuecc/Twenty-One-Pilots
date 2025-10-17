module Odd_Counter(
    input     wire        clk,
    input     wire        reset,
    output    logic[7:0]  cnt_o
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            cnt_o <= 8'h1;  // Reset to 1
        end else begin
            cnt_o <= cnt_o + 2;  // Increment by 2
        end
    end

endmodule