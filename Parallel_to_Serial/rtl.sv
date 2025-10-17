`timescale 1ns/1ps

// ============================================================
// 4-Bit Parallel-to-Serial Converter with Empty and Valid Flags
// ============================================================
module Parallel_to_Serial (
    input  logic        clk,
    input  logic        reset,
    input  logic [3:0]  parallel_i,
    output logic        serial_o,
    output logic        valid_o,
    output logic        empty_o
);

    logic [3:0] shift_reg;
    logic [2:0] count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 4'b0000;
            count     <= 3'd0;
            serial_o  <= 1'b0;
            valid_o   <= 1'b0;
            empty_o   <= 1'b1; // No data transmitting
        end else begin
            if (count == 0) begin
                // Load new parallel data
                shift_reg <= parallel_i;
                count     <= 3'd4;     // 4 bits to transmit
                valid_o   <= 1'b0;
                empty_o   <= 1'b0;
            end else begin
                // Shift data serially, LSB first
                serial_o  <= shift_reg[0];
                valid_o   <= 1'b1;
                shift_reg <= shift_reg >> 1;
                count     <= count - 1;

                if (count == 1) begin
                    // Transmission done
                    empty_o <= 1'b1;
                    valid_o <= 1'b0;
                end
            end
        end
    end
endmodule
