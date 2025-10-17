# Odd Counter

Design and verify an 8-bit odd counter

## Interface Definition

> [!NOTE]
> - Counter should reset to a value of 8'h1
> - Counter should increment by 2 on every cycle

The module contains the following interface:

```SystemVerilog
module Odd_Counter
    input     wire        clk,
    input     wire        reset,

    output    logic[7:0]  cnt_o
```

Screenshot Of Wave:-

![Screnshoot](ss.png)