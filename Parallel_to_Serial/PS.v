// 4-bit Parallel to Serial Converter
module parallel_to_serial (
    input wire clk,           // Clock signal
    input wire rst,           // Active high reset
    input wire load,          // Load parallel data
    input wire [3:0] p_data,  // 4-bit parallel input data
    output reg s_data,        // Serial output data
    output reg valid,         // Valid signal (data is being transmitted)
    output reg empty          // Empty signal (no data to transmit)
);

    reg [3:0] shift_reg;      // Shift register to hold data
    reg [2:0] bit_count;      // Counter for bits transmitted (0-3)

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 4'b0000;
            s_data <= 1'b0;
            valid <= 1'b0;
            empty <= 1'b1;
            bit_count <= 3'd0;
        end
        else if (load) begin
            // Load parallel data into shift register
            shift_reg <= p_data;
            s_data <= p_data[0];  // Output LSB first
            valid <= 1'b1;
            empty <= 1'b0;
            bit_count <= 3'd0;
        end
        else if (!empty) begin
            // Shift and output next bit
            bit_count <= bit_count + 1;
            if (bit_count < 3'd3) begin
                shift_reg <= shift_reg >> 1;  // Shift right
                s_data <= shift_reg[1];       // Output next bit
                valid <= 1'b1;
            end
            else begin
                // All bits transmitted
                valid <= 1'b0;
                empty <= 1'b1;
                s_data <= 1'b0;
            end
        end
        else begin
            valid <= 1'b0;
            empty <= 1'b1;
        end
    end

endmodule