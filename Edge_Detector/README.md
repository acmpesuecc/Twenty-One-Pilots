# Edge Detector

Design and verify a rising and falling edge detector

## Interface Definition

The module should have the following interface:
```SystemVerilog
module Edge_Detector
    input     wire    clk,
    input     wire    reset,

    input     wire    a_i,            -> Serial input to the module

    output    wire    rising_edge_o,  -> Rising edge output
    output    wire    falling_edge_o  -> Falling edge output
```

## Functional Description 

The Edge Detector module monitors a serial input signal (a_i) and detects transitions based on the edge type (rising, falling, or both). It stores the previous state of the signal at each rising clock edge and compares it to the current value. The module generates a high pulse on the output (rising_edge_o or falling_edge_o) for one clock cycle when the configured edge condition is met.

The rising edge output (rising_edge_o) goes high when the signal transitions from low to high (0 → 1). Similarly, the falling edge output (falling_edge_o) goes high when the signal transitions from high to low (1 → 0).

The outputs ensure that the pulse duration is equal to one clock cycle and is aligned with the clock. The module operates synchronously with a reset signal to initialize its internal state.