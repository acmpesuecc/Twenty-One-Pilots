// Simple_Memory_Interface.sv
// This module implements a generic synchronous RAM with a 1-cycle read latency.
// It serves as the target for the APB_Slave.

module Simple_Memory_Interface #(
    parameter ADDR_WIDTH = 10,
    parameter DATA_WIDTH = 32
) (
    input  wire                 clk,
    input  wire                 reset,

    // Memory Interface Signals
    input  wire                 wr_en_i,
    input  wire                 rd_en_i,
    input  wire [ADDR_WIDTH-1:0] addr_i,
    input  wire [DATA_WIDTH-1:0] wdata_i,
    output wire [DATA_WIDTH-1:0] rdata_o
);

    // Memory array: 2^ADDR_WIDTH words, each DATA_WIDTH bits wide
    localparam MEM_DEPTH = 1 << ADDR_WIDTH;
    
    // Memory declaration: A 1024 x 32-bit array
    logic [DATA_WIDTH-1:0] mem [MEM_DEPTH];

    // Read Data Register: Used to implement the 1-cycle read latency
    // If rd_en_i is asserted in cycle T, the data from mem[addr_i] is
    // registered and outputted in cycle T+1.
    logic [DATA_WIDTH-1:0] rdata_reg;
    
    assign rdata_o = rdata_reg;

    // Synchronous Logic Block
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset state (Optional: clear memory if required, but usually just control logic)
            rdata_reg <= '0;
        end else begin
            // --- Write Operation ---
            if (wr_en_i) begin
                mem[addr_i] <= wdata_i;
                $display("  [MEM] WRITE: Addr=0x%0h, Data=0x%0h", addr_i, wdata_i);
            end

            // --- Read Operation ---
            // Read data is registered for 1-cycle latency
            if (rd_en_i) begin
                rdata_reg <= mem[addr_i];
                $display("  [MEM] READ: Addr=0x%0h, MemData=0x%0h", addr_i, mem[addr_i]);
            end else begin
                // Hold output stable or set to default (depends on specification)
                rdata_reg <= rdata_reg; 
            end
        end
    end
