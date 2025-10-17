module tb;

  parameter VEC_W = 4;
  reg  [VEC_W-1:0] bin_i;
  wire [VEC_W-1:0] gray_o;

  // Instantiate the DUT
  Binary_to_Gray #(.VEC_W(VEC_W)) dut (
    .bin_i(bin_i),
    .gray_o(gray_o)
  );

  // Waveform dump for GTKWave
  initial begin
    $dumpfile("waveform.vcd");   // Save waveform to file
    $dumpvars(0, tb);            // Dump all signals in testbench
  end

  // Stimulus block
  initial begin
    $display("bin_i gray_o");
    for (int i = 0; i < (1 << VEC_W); i++) begin
      bin_i = i;
      #1;
      $display("%b %b", bin_i, gray_o);
    end
    $finish;
  end

endmodule
