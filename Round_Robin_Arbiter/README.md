# Round Robin Arbiter

Design and verify a 4-bit round robin arbiter.

## Interface Definition
- Output should be produced in a single cycle
- Output must be one-hot

The module should have the following interface:

```SystemVerilog
module Round_Robin_Arbiter (
  input     wire        clk,
  input     wire        reset,

  input     wire[3:0]   req_i,
  output    logic[3:0]  gnt_o
);
```

## Additional Challenge

Design a parameterized round-robin arbiter.

