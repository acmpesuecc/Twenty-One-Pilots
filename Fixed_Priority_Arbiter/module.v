module Fixed_Priority_Arbiter #(
  parameter NUM_PORTS = 4
)(
  input  wire [NUM_PORTS-1:0] req_i,
  output wire [NUM_PORTS-1:0] gnt_o  // One-hot grant signal
);

  // Priority encoding logic
  // Port 0 has highest priority, Port NUM_PORTS-1 has lowest priority
  logic [NUM_PORTS-1:0] grant;
  
  always_comb begin
    grant = '0;  // Default: no grants
    
    // Priority chain: check from highest to lowest priority
    for (int i = 0; i < NUM_PORTS; i++) begin
      if (req_i[i]) begin
        grant[i] = 1'b1;
        break;  // Grant to highest priority requester and exit
      end
    end
  end
  
  assign gnt_o = grant;

endmodule


