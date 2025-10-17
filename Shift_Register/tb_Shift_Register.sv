module tb_Shift_Register;

    logic clk;
    logic reset;
    logic x_i;
    logic [3:0] sr_o;

    Shift_Register DUT (
        .clk(clk),
        .reset(reset),
        .x_i(x_i),
        .sr_o(sr_o)
    );

    parameter CLK_PERIOD = 10;
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    initial begin
        $dumpfile("shift_reg.vcd");
        $dumpvars(0, tb_Shift_Register);

        $display("--- Starting Shift Register Test ---");

        reset = 1; x_i = 0;
        repeat (2) @(posedge clk);

        reset = 0;
        @(posedge clk);
        $display("Reset complete. Starting shift sequence.");

        x_i = 1;
        @(posedge clk);
        $display("Time: %0t, Input: %b, Output: %b", $time, x_i, sr_o);

        x_i = 0;
        @(posedge clk);
        $display("Time: %0t, Input: %b, Output: %b", $time, x_i, sr_o);

        x_i = 1;
        @(posedge clk);
        $display("Time: %0t, Input: %b, Output: %b", $time, x_i, sr_o);

        x_i = 1;
        @(posedge clk);
        $display("Time: %0t, Input: %b, Output: %b", $time, x_i, sr_o);

        x_i = 0;
        repeat (2) @(posedge clk);

        $display("--- Test Finished at Time %0t ---", $time);
        $finish;
    end

endmodule