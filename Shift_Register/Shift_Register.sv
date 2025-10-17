module Shift_Register (
    input logic clk,
    input logic reset,
    input logic x_i,
    output logic [3:0] sr_o
);

    logic [3:0] shift_reg_q;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg_q <= 4'b0;
        end else begin
            shift_reg_q <= {x_i, shift_reg_q[3:1]};
        end
    end

    assign sr_o = shift_reg_q;

endmodule