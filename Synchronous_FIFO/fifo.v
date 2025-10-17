// Synchronous FIFO - 8-bit wide, 16 entries deep
module sync_fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = 4  // log2(DEPTH)
)(
    input wire clk,                          // Clock
    input wire rst,                          // Active high reset
    input wire wr_en,                        // Write enable
    input wire rd_en,                        // Read enable
    input wire [DATA_WIDTH-1:0] wr_data,     // Write data
    output reg [DATA_WIDTH-1:0] rd_data,     // Read data
    output wire full,                        // FIFO full flag
    output wire empty,                       // FIFO empty flag
    output wire [ADDR_WIDTH:0] data_count    // Number of items in FIFO
);

    // Internal memory array
    reg [DATA_WIDTH-1:0] fifo_mem [0:DEPTH-1];
    
    // Read and write pointers
    reg [ADDR_WIDTH-1:0] wr_ptr;
    reg [ADDR_WIDTH-1:0] rd_ptr;
    
    // Internal counter for number of elements
    reg [ADDR_WIDTH:0] count;
    
    // Flag assignments
    assign full = (count == DEPTH);
    assign empty = (count == 0);
    assign data_count = count;  // Wire assignment from internal counter
    
    // Write operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
        end
        else if (wr_en && !full) begin
            fifo_mem[wr_ptr] <= wr_data;
            wr_ptr <= wr_ptr + 1;
        end
    end
    
    // Read operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_ptr <= 0;
            rd_data <= 0;
        end
        else if (rd_en && !empty) begin
            rd_data <= fifo_mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end
    
    // Counter logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
        end
        else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b10: count <= count + 1;  // Write only
                2'b01: count <= count - 1;  // Read only
                2'b11: count <= count;      // Simultaneous read/write
                default: count <= count;    // No operation
            endcase
        end
    end

endmodule