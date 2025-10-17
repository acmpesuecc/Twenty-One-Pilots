// rtl.sv
// Sequence_Detector: detects serial bit sequence 1110_1101_1011 (12 bits)
// Overlapping sequences are detected. Synchronous, shift-register based Mealy-style (1-cycle pulse).

module Sequence_Detector (
    input  wire clk,
    input  wire reset,
    input  wire x_i,
    output wire det_o
);

    // 12-bit pattern: 1110_1101_1011
    localparam [11:0] PATTERN = 12'b1110_1101_1011;

    reg [11:0] shift_reg;

    // Shift register: shift in new bit x_i on every rising edge
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 12'b0;
        end else begin
            shift_reg <= {shift_reg[10:0], x_i};
        end
    end

    // Detection logic: assert for one clock when shift_reg matches the pattern
    assign det_o = (shift_reg == PATTERN);

endmodule