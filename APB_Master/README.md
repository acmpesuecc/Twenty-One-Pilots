# APB Master
Design and verify an APB master interface which generates an APB transfer using a command input: 

| cmd_i  | Comment                                                   |
|--------|-----------------------------------------------------------|
| 2'b00  | No-operation                                              |
| 2'b01  | APB Read from address 0xDEAD_CAFE                         |
| 2'b10  | Increment the previously read data and write to 0xDEAD_CAFE|
| 2'b11  | Invalid/Not possible                                      |


## Interface Definition
- The cmd_i input remains stable until the APB transfer is complete
- The module should have the following interface:

```SystemVerilog
module APB_Master (
  input       wire        clk,
  input       wire        reset,

  input       wire[1:0]   cmd_i,

  output      wire        psel_o,
  output      wire        penable_o,
  output      wire[31:0]  paddr_o,
  output      wire        pwrite_o,
  output      wire[31:0]  pwdata_o,
  input       wire        pready_i,
  input       wire[31:0]  prdata_i
);
```

## Additional information

APB (Advanced Peripheral Bus) is a bus protocol used in microcontrollers and microprocessors that are built mainly using ARM designs. It is designed for low-bandwidth,
low-power peripheral devices, and is used to connect simple peripherals like GPIO to the CPU. 

### Features

- Simple Design: APB is less complex compared to other AMBA buses like AHB (Advanced High-performance Bus) and AXI (Advanced Extensible Interface).
- Low Power Consumption: It's optimized for low-power peripherals.
- Lower Throughput: APB is not designed for high-speed data transfer; instead, it focuses on peripherals that don’t require high bandwidth.
- Two Signals: APB uses a few control signals, including clock, reset, address, write/read signals, and data bus.