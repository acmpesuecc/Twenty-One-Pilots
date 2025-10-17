`timescale 1ns / 1ps

module Binary_to_Onehot_tb;
localparam int BIN_W=4;
localparam int ONE_HOT_W=1<<BIN_W;
typedef logic [BIN_W-1:0] bin_t;
typedef logic [ONE_HOT_W-1:0] one_hot_t;
logic [BIN_W-1:0] bin_i_tb;
logic [ONE_HOT_W-1:0] one_hot_o_tb;
one_hot_t expected_one_hot;
int errors = 0;

Binary_to_Onehot # (.BIN_W(BIN_W),
                    .ONE_HOT_W(ONE_HOT_W)) 
dut (.*);

initial 
begin
  bin_i_tb = 0;
  #5ns;

  for (int i = 0; i < ONE_HOT_W; i++) begin 
      bin_i_tb = i;
      expected_one_hot = 1'b1 << i;
      #10ns; 
      
      if (one_hot_o_tb !== expected_one_hot) 
      begin
          $error("Test Failed (Mismatch): Input=%0d. Expected=0x%h, Got=0x%h", 
              i, expected_one_hot, one_hot_o_tb);
          errors++;
      end 
      
      if ($countones(one_hot_o_tb) !== 1) 
      begin
          $error("Test Failed (Hamming Weight): Input=%0d. Output 0x%h is not one-hot (countones=%0d)",
                  i, one_hot_o_tb, $countones(one_hot_o_tb));
          errors++;
      end
      
      if (one_hot_o_tb === expected_one_hot && $countones(one_hot_o_tb) === 1) 
      begin
          $info("Test Passed: Input=%0d -> Output=0x%h", i, one_hot_o_tb);
      end 
  end 
    
  if (errors == 0) 
  begin
      $display("\nSUCCESS: All %0d test cases passed!", ONE_HOT_W);
  end 
  else 
  begin
      $fatal("\nFAILURE: %0d test cases failed.", errors);
  end
    
  $finish;
end
endmodule