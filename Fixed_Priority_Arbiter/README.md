# Fixed Priority Arbiter

Design and verify a parameterized fixed priority arbiter

## Interface Definition
- Output should be produced in a single cycle
- Output must be one-hot

The module should have the following interface:
```SystemVerilog
module Fixed_Priority_Arbiter # (
  parameter NUM_PORTS = 4
)(
    input       wire[NUM_PORTS-1:0] req_i,
    output      wire[NUM_PORTS-1:0] gnt_o   // One-hot grant signal
);
```

## Functional description 

- Purpose: A priority arbiter is used to manage access to a shared resource (like a bus or memory) when multiple requests are made simultaneously. It decides which requester gets access based on a priority scheme.

- Behavior: It resolves contention among multiple requests by granting access to the one with the highest priority while potentially keeping others waiting.

- Example usage: In a system-on-chip (SoC), a priority arbiter decides which master (CPU, DMA controller, etc.) gets access to the memory bus.