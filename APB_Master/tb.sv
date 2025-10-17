`timescale 1ns/1ps

module tb_APB_Master;

    // Clock and reset
    logic clk;
    logic reset;

    // Command input
    logic [1:0] cmd_i;

    // APB signals
    logic psel_o;
    logic penable_o;
    logic [31:0] paddr_o;
    logic pwrite_o;
    logic [31:0] pwdata_o;
    logic pready_i;
    logic [31:0] prdata_i;

    // Instantiate DUT
    APB_Master dut (
        .clk(clk),
        .reset(reset),
        .cmd_i(cmd_i),
        .psel_o(psel_o),
        .penable_o(penable_o),
        .paddr_o(paddr_o),
        .pwrite_o(pwrite_o),
        .pwdata_o(pwdata_o),
        .pready_i(pready_i),
        .prdata_i(prdata_i)
    );

    // Clock generation (100MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // Simple APB slave behavior for testing
    always_ff @(posedge clk) begin
        if (psel_o && penable_o) begin
            pready_i <= 1;
            if (!pwrite_o)
                prdata_i <= 32'h1234_5678; // Dummy read data
            else
                prdata_i <= 32'b0; // Write doesn't affect read
        end else begin
            pready_i <= 0;
        end
    end

    // Test sequence
    initial begin
        reset = 1;
        cmd_i = 2'b00;
        #20 reset = 0;

        // Test read
        cmd_i = 2'b01;
        #10;
        wait (psel_o && penable_o && pready_i);
        #10;
        cmd_i = 2'b00; // Back to NOP
        #20;

        // Test write (increment)
        cmd_i = 2'b10;
        #10;
        wait (psel_o && penable_o && pready_i);
        #10;
        cmd_i = 2'b00; // Back to NOP
        #20;

        // Test invalid command
        cmd_i = 2'b11;
        #50;

        $display("Testbench finished");
        $finish;
    end

    // Waveform dump
    initial begin
        $dumpfile("apb_master_tb.vcd");
        $dumpvars(0, tb_APB_Master);
    end

endmodule
