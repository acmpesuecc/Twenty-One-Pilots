// APB_Slave_tb.sv
// Testbench for APB_Slave module.

`timescale 1ns / 1ps
`include "Simple_Memory_Interface.sv"
`include "APB_Slave.sv"

module APB_Slave_tb;

    // --- Parameters ---
    localparam ADDR_WIDTH = 10;
    localparam DATA_WIDTH = 32;
    localparam CLK_PERIOD = 10; // 10ns = 100MHz

    // --- Testbench Signals ---
    logic                 clk;
    logic                 reset;

    // APB Master Outputs
    logic                 psel_i;
    logic                 penable_i;
    logic [ADDR_WIDTH-1:0] paddr_i;
    logic                 pwrite_i;
    logic [DATA_WIDTH-1:0] pwdata_i;

    // APB Slave Outputs/Inputs
    wire  [DATA_WIDTH-1:0] prdata_o;
    wire                  pready_o;

    // Memory Interface Signals (Connecting APB_Slave to Simple_Memory_Interface)
    wire                  mem_wr_en;
    wire                  mem_rd_en;
    wire  [ADDR_WIDTH-1:0] mem_addr;
    wire  [DATA_WIDTH-1:0] mem_wdata;
    wire  [DATA_WIDTH-1:0] mem_rdata;


    // --- Clock Generation ---
    initial begin
        clk = 1'b0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // --- Instance the DUT and Memory ---
    // 1. Memory Interface
    Simple_Memory_Interface #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH))
    u_mem (
        .clk        (clk),
        .reset      (reset),
        .wr_en_i    (mem_wr_en),
        .rd_en_i    (mem_rd_en),
        .addr_i     (mem_addr),
        .wdata_i    (mem_wdata),
        .rdata_o    (mem_rdata) // Memory output is slave input
    );

    // 2. APB Slave (DUT)
    APB_Slave #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH))
    u_slave (
        // APB Interface
        .clk        (clk),
        .reset      (reset),
        .psel_i     (psel_i),
        .penable_i  (penable_i),
        .paddr_i    (paddr_i),
        .pwrite_i   (pwrite_i),
        .pwdata_i   (pwdata_i),
        .prdata_o   (prdata_o),
        .pready_o   (pready_o),

        // Memory Interface
        .mem_wr_en_o(mem_wr_en),
        .mem_rd_en_o(mem_rd_en),
        .mem_addr_o (mem_addr),
        .mem_wdata_o(mem_wdata),
        .mem_rdata_i(mem_rdata) // Memory input is slave output
    );


    // --- APB Master Tasks ---

    // Initializes APB signals to IDLE state
    task apb_init;
        psel_i    = 1'b0;
        penable_i = 1'b0;
        paddr_i   = '0;
        pwrite_i  = 1'b0;
        pwdata_i  = '0;
    endtask

    // Performs a complete APB Write transaction (3 cycles: SETUP, ACCESS_WAIT, ACCESS_DONE)
    task apb_write_transfer(input [ADDR_WIDTH-1:0] addr, input [DATA_WIDTH-1:0] wdata);
        $display("-------------------------------------------");
        $display("@%0t: Master initiating WRITE to Addr=0x%0h, Data=0x%0h", $time, addr, wdata);

        // T1: SETUP Phase (PSEL=1, PENABLE=0)
        @(posedge clk);
        psel_i    = 1'b1;
        pwrite_i  = 1'b1; // Write
        paddr_i   = addr;
        pwdata_i  = wdata;
        penable_i = 1'b0; // Setup phase

        // T2: ACCESS_WAIT Phase (PSEL=1, PENABLE=1, PREADY=0)
        @(posedge clk);
        penable_i = 1'b1; // Access phase begins
        
        // Wait for PREADY high
        @(posedge clk);
        if (pready_o == 1'b1) begin
            $display("@%0t: Slave confirmed WRITE completion (READY=1).", $time);
        end else begin
            $fatal(1, "WRITE: Slave did not assert PREADY high in time.");
        end

        // T3: Transfer Complete (PSEL=0, PENABLE=0) - Return to IDLE
        @(posedge clk);
        apb_init(); // Deassert PSEL and PENABLE
    endtask

    // Performs a complete APB Read transaction (3 cycles: SETUP, ACCESS_WAIT, ACCESS_DONE)
    task apb_read_transfer(input [ADDR_WIDTH-1:0] addr, output [DATA_WIDTH-1:0] rdata);
        $display("-------------------------------------------");
        $display("@%0t: Master initiating READ from Addr=0x%0h", $time, addr);

        // T1: SETUP Phase (PSEL=1, PENABLE=0)
        @(posedge clk);
        psel_i    = 1'b1;
        pwrite_i  = 1'b0; // Read
        paddr_i   = addr;
        pwdata_i  = '0;
        penable_i = 1'b0; // Setup phase

        // T2: ACCESS_WAIT Phase (PSEL=1, PENABLE=1, PREADY=0)
        @(posedge clk);
        penable_i = 1'b1; // Access phase begins
        
        // Wait for PREADY high
        @(posedge clk);
        if (pready_o == 1'b1) begin
            rdata = prdata_o;
            $display("@%0t: Slave confirmed READ completion (READY=1), PRDATA=0x%0h.", $time, rdata);
        end else begin
            $fatal(1, "READ: Slave did not assert PREADY high in time.");
        end

        // T3: Transfer Complete (PSEL=0, PENABLE=0) - Return to IDLE
        @(posedge clk);
        apb_init(); // Deassert PSEL and PENABLE
    endtask


    // --- Test Scenario ---
    initial begin
        // 1. Initialization and Reset
        reset = 1'b1;
        apb_init();
        $display("@%0t: Starting simulation...", $time);

        repeat (5) @(posedge clk);
        reset = 1'b0;
        $display("@%0t: Reset released.", $time);

        // 2. Perform WRITE Transaction
        apb_write_transfer('h10, 'hDEADBEEF);
        
        // 3. Perform READ Transaction
        apb_read_transfer('h10, read_data);
        if (read_data == 'hDEADBEEF) begin
            $display("SUCCESS: Read data (0x%0h) matches written data.", read_data);
        end else begin
            $error("FAILURE: Read data (0x%0h) does not match expected data (0x%0h).", read_data, 'hDEADBEEF);
        end
        
        // 4. Perform a second WRITE/READ to a different address
        apb_write_transfer('h20, 'hF00DF00D);
        apb_read_transfer('h20, read_data);
        if (read_data == 'hF00DF00D) begin
            $display("SUCCESS: Second Read data (0x%0h) matches written data.", read_data);
        end else begin
            $error("FAILURE: Second Read data (0x%0h) does not match expected data (0x%0h).", read_data, 'hF00DF00D);
        end

        // 5. Simulation End
        repeat (5) @(posedge clk);
        $display("@%0t: Simulation finished.", $time);
        $finish;
    end

    // For collecting read data
    logic [DATA_WIDTH-1:0] read_data;
    
    // Optional: Monitor APB state changes
    always @(posedge clk) begin
        if (u_slave.current_state != u_slave.next_state) begin
            $display("@%0t: State transition: %s -> %s", $time, u_slave.current_state.name(), u_slave.next_state.name());
        end
    end

endmodule
