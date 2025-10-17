`timescale 1ns/1ps

module tb_APB_Master;

    reg clk;
    reg reset;
    reg [1:0] cmd_i;

    wire psel_o;
    wire penable_o;
    wire [31:0] paddr_o;
    wire pwrite_o;
    wire [31:0] pwdata_o;
    reg pready_i;
    reg [31:0] prdata_i;

    // Instantiate DUT
    APB_Master dut(
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

    // Clock
    initial clk = 0;
    always #5 clk = ~clk;

    // Dummy APB slave
    initial begin
        pready_i = 0;
        prdata_i = 0;
    end

    always @(posedge clk) begin
        if (psel_o && penable_o) begin
            pready_i <= 1;
            if (!pwrite_o)
                prdata_i <= 32'hDEAD_BEEF;
            else
                prdata_i <= 0;
        end else begin
            pready_i <= 0;
        end
    end

    // Test sequence
    initial begin
        reset = 1;
        cmd_i = 2'b00;
        #20 reset = 0;

        // Read
        cmd_i = 2'b01;
        #20;
        cmd_i = 2'b00;

        // Write
        #20;
        cmd_i = 2'b10;
        #20;
        cmd_i = 2'b00;

        // Invalid
        #20;
        cmd_i = 2'b11;
        #40;

        $display("Testbench finished.");
        $finish;
    end

    // Waveform
    initial begin
        $dumpfile("apb_master_tb.vcd");
        $dumpvars(0, tb_APB_Master);
    end

endmodule
