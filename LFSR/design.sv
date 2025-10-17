module LFSR (
    input  wire       clk,
    input  wire       reset,
    output wire [3:0] lfsr_o
);

    reg [3:0] lfsr_reg;
    assign lfsr_o = lfsr_reg;

    wire feedback_bit = lfsr_reg[1] ^ lfsr_reg[3];

    always @(posedge clk or posedge reset) begin
        if (reset)
            lfsr_reg <= 4'b1001;
        else
            lfsr_reg <= {feedback_bit, lfsr_reg[3:1]};
    end
endmodule
