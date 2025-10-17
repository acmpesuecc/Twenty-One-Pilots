# APB Slave

Design and verify a APB slave interface which utilises the [memory interface module](../Simple_Memory_Interface/)

>[!IMPORTANT]
> Kindly solve Issue #20 before you take up this module.

## Interface Definition

The module should have the following interface:

```SystemVerilog
module APB_Slave (
  input         wire        clk,
  input         wire        reset,

  input         wire        psel_i,
  input         wire        penable_i,
  input         wire[9:0]   paddr_i,
  input         wire        pwrite_i,
  input         wire[31:0]  pwdata_i,
  output        wire[31:0]  prdata_o,
  output        wire        pready_o
);
```

## Additional info 

- APB Slave: An APB (Advanced Peripheral Bus) slave is a device that responds to read and write requests from an APB master. It typically represents a peripheral, such as a UART or GPIO, that performs a specific function.

- APB Master: An APB master is a controller that initiates transactions on the APB by sending control signals, addresses, and data to communicate with connected slaves.

### APB Master vs APB Slave

| **Feature**          | **APB Master**                          | **APB Slave**                           |
|-----------------------|-----------------------------------------|-----------------------------------------|
| **Role**             | Initiates read/write transactions.     | Responds to master’s requests.          |
| **Control**          | Generates control signals (`PSEL`, `PENABLE`). | Operates based on received control signals. |
| **Data Flow**        | Sends data to or reads data from slaves.| Sends data to or receives data from master. |
| **Examples**         | CPU, DMA controller.                   | UART, GPIO, Timer.                      |
