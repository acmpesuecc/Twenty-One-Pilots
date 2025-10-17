module Parallel_to_Serial (
    input  wire       clk,
    input  wire       reset,
    input  wire [3:0] parallel_i,
    output wire       empty_o,   // asserted when there is no data to transmit
    output wire       serial_o,  // serial output (LSB first)
    output wire       valid_o    // asserted when serial_o is valid
);

    logic [3:0] shift_reg;
    logic [2:0] count; // counts bits remaining (0..4)

    // Sequential logic: load when count==0, otherwise shift and decrement.
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 4'b0;
            count     <= 3'd0;
        end else begin
            if (count == 3'd0) begin
                // load new parallel data and start transmission
                shift_reg <= parallel_i;
                count     <= 3'd4;
            end else begin
                // output current LSB this cycle, then shift so next LSB is ready next cycle
                shift_reg <= (shift_reg >> 1); // logical right shift
                count     <= count - 3'd1;
            end
        end
    end

    // Outputs: serial is LSB of shift_reg; valid when count != 0; empty when count == 0
    assign serial_o = shift_reg[0];
    assign valid_o  = (count != 3'd0);
    assign empty_o  = (count == 3'd0);

endmodule