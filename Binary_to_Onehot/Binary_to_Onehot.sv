module Binary_to_Onehot #(parameter int BIN_W = 4,
                          parameter int ONE_HOT_W = 16)
                         (input   logic [BIN_W-1:0] bin_i,
                          output  logic [ONE_HOT_W-1:0] one_hot_o);
initial
begin
  if (ONE_HOT_W != (1 << BIN_W))
  begin
    $error("Parameter error: ONE_HOT_W (%0d) must equal 2^BIN_W (%0d)",
            ONE_HOT_W, (1 << BIN_W));
    $finish;
  end
end
assign one_hot_o = 1'b1 << bin_i;
endmodule