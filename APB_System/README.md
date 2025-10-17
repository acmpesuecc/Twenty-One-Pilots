# APB System

Design and verify a read/write system described below:

- Writes should have higher priority than reads
- Sytem should be able to buffer 16 read or write requests to avoid any loss
- System must use APB master/slave protocol to communicate to memory interface

```
                                   rd_valid_o
                                       ^
                                       |
|-----|    |------|    |------|     |------|
| ARB | -> | FIFO | -> | APBM | <-> | APBS | => rd_data_o
|-----|    |------|    |------|     |------|

```
> [!IMPORTANT]
> The idea behind this problem is to exercise how a complex system can be created by connecting various small blocks together
> Kindly solve Issues #2 and #3 before you take up this module.

## Interface Definition

The module should have the following interface:

```SystemVerilog
module APB_System (
  input       wire        clk,
  input       wire        reset,

  input       wire        read_i,       - Sends a read request when asserted
  input       wire        write_i,      - Sends a write request when asserted

  output      wire        rd_valid_o,   - Should be asserted whenever read data is valid
  output      wire[31:0]  rd_data_o     - Read data
);

module arbiter (
    input  wire clk,
    input  wire reset,
    input  wire read_i,
    input  wire write_i,
    input  wire fifo_full,
    output reg  arb_write_en,
    output reg  arb_read_en
);

module fifo #(parameter DEPTH = 16, WIDTH = 32) (
    input  wire              clk,
    input  wire              reset,
    input  wire              write_en,
    input  wire              read_en,
    input  wire [WIDTH-1:0]  write_data,
    output reg  [WIDTH-1:0]  read_data,
    output wire              full
);
```

