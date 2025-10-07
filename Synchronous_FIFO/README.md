# Synchronous FIFO

Design and verify a parameterized synchronous fifo. Both the depth and data width should be parameterized

## Interface Definition
The module should have the following interface:

```
module Synchronous_FIFO #(
  parameter DEPTH   = 4,
  parameter DATA_W  = 1
)(
  input         wire              clk,
  input         wire              reset,

  input         wire              push_i,
  input         wire[DATA_W-1:0]  push_data_i,

  input         wire              pop_i,
  output        wire[DATA_W-1:0]  pop_data_o,

  output        wire              full_o,
  output        wire              empty_o
);
```

## Additional info

- A FIFO (First-In, First-Out) is a type of queue where the first data written is the first data read. It's commonly used in data buffering applications.

- In the code, a FIFO is implemented using a memory array (mem) and two pointers (w_ptr and r_ptr) to manage write and read operations. It uses a counter (count) to track the number of elements in the FIFO, ensuring it doesn’t overflow or underflow by controlling push_i and pop_i signals. The module also provides full_o and empty_o flags to indicate the FIFO's state.