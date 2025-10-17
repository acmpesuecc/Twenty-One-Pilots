// 4-bit Linear Feedback Shift Register (LFSR)
// Feedback: bit0 = bit1 XOR bit3
module LFSR (
    input wire clk,
    input wire reset,
    output wire [3:0] lfsr_o
);

    // Internal register to hold LFSR state
    reg [3:0] lfsr_reg;
    
    // Feedback signal: XOR of bit1 and bit3
    wire feedback;
    assign feedback = lfsr_reg[1] ^ lfsr_reg[3];
    
    // Output assignment
    assign lfsr_o = lfsr_reg;
    
    // LFSR logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize with non-zero seed value
            lfsr_reg <= 4'b0001;
        end
        else begin
            // Shift operation with feedback
            lfsr_reg[0] <= feedback;      // bit0 gets feedback
            lfsr_reg[1] <= lfsr_reg[0];   // bit1 gets bit0
            lfsr_reg[2] <= lfsr_reg[1];   // bit2 gets bit1
            lfsr_reg[3] <= lfsr_reg[2];   // bit3 gets bit2
        end
    end

endmodule