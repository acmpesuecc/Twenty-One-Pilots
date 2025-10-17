module Shift_Register(
    input wire clk,
    input wire reset,
    input wire x_i,
    output reg [3:0] sr_o
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        sr_o <= 4'b0000;
    end else begin
        sr_o <= {sr_o[2:0], x_i};  // Shift left, insert x_i at LSB
    end
end

endmodule