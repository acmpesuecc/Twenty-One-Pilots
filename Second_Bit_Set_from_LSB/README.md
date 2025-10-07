# Second Bit Set from LSB
Design and verify a module which finds the second bit set from LSB for a N-bit vector.

## Interface Definition

- Output should be produced in a single cycle
- Output must be one-hot or zero

The module should have the following interface:

```
module Second_Bit_Set_from_LSB #(
  parameter WIDTH = 12
)(
    input  wire [WIDTH-1:0] vec_i,
    output wire [WIDTH-1:0] second_bit_o
);
```
## Working info

This module is designed to find the **first** and **second set bits** in a given vector `vec_i`. The first set bit is the lowest `1` bit encountered when moving from right to left. The second set bit is found after clearing the first set bit.

The module performs the following steps:
1. **Find the first set bit** in `vec_i`.
2. **Clear the first set bit** from `vec_i`.
3. **Find the second set bit** in the modified vector.

Example: `vec_i = 12'b001001000000`

Let’s walk through an example where `vec_i = 12'b001001000000` (in binary).

### Step 1: Finding the First Set Bit

```rust
first_bit_mask = 12'b001001000000 & 12'b110111000000
               = 12'b000001000000
```

### Step 2: Clearing the First Set Bit

``` rust
cleared_vec = 12'b001001000000 & 12'b111110111111
            = 12'b001000000000
```

### Step 3: Finding the Second Set Bit

```rust
second_bit_o = 12'b001000000000 & 12'b110111111111
             = 12'b000000100000
```

In this example:

- The first set bit is at position 4 (counting from 0).
- The second set bit is at position 7.

