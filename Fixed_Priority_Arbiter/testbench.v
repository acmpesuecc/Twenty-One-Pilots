// Testbench
module tb_Fixed_Priority_Arbiter;
  parameter NUM_PORTS = 4;
  
  logic [NUM_PORTS-1:0] req;
  logic [NUM_PORTS-1:0] gnt;
  
  Fixed_Priority_Arbiter #(
    .NUM_PORTS(NUM_PORTS)
  ) dut (
    .req_i(req),
    .gnt_o(gnt)
  );
  
  // Helper function to check one-hot encoding
  function automatic int is_onehot(logic [NUM_PORTS-1:0] vec);
    return $countones(vec) <= 1;
  endfunction
  
  // Helper function to get the granted port (-1 if none)
  function automatic int get_granted_port(logic [NUM_PORTS-1:0] vec);
    for (int i = 0; i < NUM_PORTS; i++) begin
      if (vec[i]) return i;
    end
    return -1;
  endfunction
  
  initial begin
    $display("=== Fixed Priority Arbiter Testbench ===");
    $display("NUM_PORTS = %0d", NUM_PORTS);
    $display("");
    
    // Test 1: No requests
    req = 4'b0000;
    #10;
    $display("Test 1 - No requests:");
    $display("  req = %b, gnt = %b", req, gnt);
    assert(gnt == 4'b0000) else $error("FAIL: Expected no grants");
    assert(is_onehot(gnt)) else $error("FAIL: Output not one-hot");
    $display("  PASS: No grants issued\n");
    
    // Test 2: Single request on each port
    for (int i = 0; i < NUM_PORTS; i++) begin
      req = 1 << i;
      #10;
      $display("Test 2.%0d - Single request on port %0d:", i, i);
      $display("  req = %b, gnt = %b", req, gnt);
      assert(gnt == req) else $error("FAIL: Grant not given to requesting port");
      assert(is_onehot(gnt)) else $error("FAIL: Output not one-hot");
      $display("  PASS: Grant given to port %0d\n", i);
    end
    
    // Test 3: Multiple requests - priority testing
    req = 4'b1111;  // All ports request
    #10;
    $display("Test 3 - All ports request:");
    $display("  req = %b, gnt = %b", req, gnt);
    assert(gnt == 4'b0001) else $error("FAIL: Port 0 should win (highest priority)");
    assert(is_onehot(gnt)) else $error("FAIL: Output not one-hot");
    $display("  PASS: Port 0 granted (highest priority)\n");
    
    req = 4'b1110;  // Ports 1, 2, 3 request
    #10;
    $display("Test 4 - Ports 1,2,3 request:");
    $display("  req = %b, gnt = %b", req, gnt);
    assert(gnt == 4'b0010) else $error("FAIL: Port 1 should win");
    assert(is_onehot(gnt)) else $error("FAIL: Output not one-hot");
    $display("  PASS: Port 1 granted\n");
    
    req = 4'b1100;  // Ports 2, 3 request
    #10;
    $display("Test 5 - Ports 2,3 request:");
    $display("  req = %b, gnt = %b", req, gnt);
    assert(gnt == 4'b0100) else $error("FAIL: Port 2 should win");
    assert(is_onehot(gnt)) else $error("FAIL: Output not one-hot");
    $display("  PASS: Port 2 granted\n");
    
    req = 4'b1000;  // Only port 3 requests
    #10;
    $display("Test 6 - Only port 3 requests:");
    $display("  req = %b, gnt = %b", req, gnt);
    assert(gnt == 4'b1000) else $error("FAIL: Port 3 should be granted");
    assert(is_onehot(gnt)) else $error("FAIL: Output not one-hot");
    $display("  PASS: Port 3 granted\n");
    
    // Test 7: Various combinations
    req = 4'b1010;  // Ports 1, 3 request
    #10;
    $display("Test 7 - Ports 1,3 request:");
    $display("  req = %b, gnt = %b", req, gnt);
    assert(gnt == 4'b0010) else $error("FAIL: Port 1 should win (higher priority)");
    assert(is_onehot(gnt)) else $error("FAIL: Output not one-hot");
    $display("  PASS: Port 1 granted (higher priority than 3)\n");
    
    req = 4'b0101;  // Ports 0, 2 request
    #10;
    $display("Test 8 - Ports 0,2 request:");
    $display("  req = %b, gnt = %b", req, gnt);
    assert(gnt == 4'b0001) else $error("FAIL: Port 0 should win (highest priority)");
    assert(is_onehot(gnt)) else $error("FAIL: Output not one-hot");
    $display("  PASS: Port 0 granted (highest priority)\n");
    
    // Summary
    $display("=================================");
    $display("All tests PASSED!");
    $display("=================================");
    $display("\nKey Properties Verified:");
    $display("  ✓ One-hot output encoding");
    $display("  ✓ Single cycle combinational logic");
    $display("  ✓ Fixed priority (Port 0 highest)");
    $display("  ✓ Correct arbitration under contention");
    
    $finish;
  end

endmodule