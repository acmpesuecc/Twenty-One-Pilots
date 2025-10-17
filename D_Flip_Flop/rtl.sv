// D Flip-Flop Module with Three Variants
// - Non-resettable D flip-flop
// - Synchronous reset D flip-flop
// - Asynchronous reset D flip-flop

module D_Flip_Flop (
    input  logic clk,
    input  logic reset,
    input  logic d_i,          // D input to the flop
    output logic q_norst_o,    // Q output from non-resettable flop
    output logic q_syncrst_o,  // Q output from flop using synchronous reset
    output logic q_asyncrst_o  // Q output from flop using asynchronous reset
);

    // Non-resettable D Flip-Flop
    // Captures d_i on every rising edge of clock
    always_ff @(posedge clk) begin
        q_norst_o <= d_i;
    end

    // Synchronous Reset D Flip-Flop
    // Reset is checked at clock edge (synchronous with clock)
    // When reset is asserted, output goes to 0 on next clock edge
    always_ff @(posedge clk) begin
        if (reset) begin
            q_syncrst_o <= 1'b0;
        end else begin
            q_syncrst_o <= d_i;
        end
    end

    // Asynchronous Reset D Flip-Flop
    // Reset takes effect immediately (asynchronous, independent of clock)
    // When reset is asserted, output goes to 0 immediately
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            q_asyncrst_o <= 1'b0;
        end else begin
            q_asyncrst_o <= d_i;
        end
    end

endmodule