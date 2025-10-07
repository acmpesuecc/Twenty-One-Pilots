# Parallel to Serial

Design and verify a 4-bit parallel to serial converter with valid and empty indications

## Interface Definition
The module should have the following interface:

```SystemVerilog
module Parallel_to_Serial
    input     wire      clk,
    input     wire      reset,

    output    wire      empty_o,    // Should be asserted when all of the bits are given out serially
    input     wire[3:0] parallel_i, // Parallel input vector
    
    output    wire      serial_o,   // Serial bit output
    output    wire      valid_o     // Serial bit is valid
```

## Working description

- When the circuit is reset, the shift register, count and output registers are cleared, and the `empty_o_reg` is set to `1` indicating no data is being transmitted. 

- When `count` is 0, new parallel data is loaded and serial transmission begins. During this transmission, LSB of `shift_reg` is set to `serial_o`. Output is valid hence its set to `1`, shifting takes place and count is decremented. When transmission is completed, output is made empty. 
