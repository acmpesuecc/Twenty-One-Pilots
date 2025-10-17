# APB System Implementation Guide

This directory contains a complete implementation of an APB (Advanced Peripheral Bus) System that integrates multiple components to create a functional read/write system with prioritized request handling and buffering.

## Overview

The APB System is a comprehensive design that demonstrates how complex systems can be built by connecting smaller modular blocks together. It implements:

- **Write Priority**: Write requests are processed before read requests
- **Buffering**: Can buffer up to 16 read or write requests to avoid data loss
- **APB Protocol**: Uses the APB Master/Slave protocol for memory communication
- **Memory Interface**: Includes a 16x32-bit memory with valid/ready protocol

## Architecture

```
                                   rd_valid_o
                                       ^
                                       |
|-----|    |------|    |------|     |------|     |--------|
| ARB | -> | FIFO | -> | APBM | <-> | APBS | <-> | Memory |
|-----|    |------|    |------|     |------|     |--------|
```

### Component Description

1. **Arbiter (arbiter.sv)**: Prioritizes write requests over read requests
2. **FIFO (fifo.sv)**: 16-deep buffer for storing pending requests
3. **APB Master (apb_master.sv)**: Generates APB transactions based on commands
4. **APB Slave (apb_slave.sv)**: Responds to APB transactions and interfaces with memory
5. **Memory Interface (simple_memory_interface.sv)**: 16x32-bit memory with valid/ready protocol

## Files Included

- `apb_system.sv` - Top-level system integration module
- `arbiter.sv` - Request arbiter with write priority
- `fifo.sv` - Parameterized FIFO buffer
- `../APB_Master/apb_master.sv` - APB Master implementation
- `../APB_Slave/apb_slave.sv` - APB Slave implementation
- `../Simple_Memory_Interface/simple_memory_interface.sv` - Memory interface
- `tb_apb_system.sv` - Comprehensive testbench

## Module Interfaces

### APB_System (Top Level)

```systemverilog
module APB_System (
  input       wire        clk,
  input       wire        reset,
  input       wire        read_i,       // Sends a read request when asserted
  input       wire        write_i,      // Sends a write request when asserted
  output      wire        rd_valid_o,   // Asserted when read data is valid
  output      wire[31:0]  rd_data_o     // Read data
);
```

### Arbiter

```systemverilog
module arbiter (
  input  wire clk,
  input  wire reset,
  input  wire read_i,
  input  wire write_i,
  input  wire fifo_full,
  output reg  arb_write_en,
  output reg  arb_read_en,
  output reg  [1:0] arb_data
);
```

### FIFO

```systemverilog
module fifo #(
  parameter DEPTH = 16,
  parameter WIDTH = 2
) (
  input  wire              clk,
  input  wire              reset,
  input  wire              write_en,
  input  wire              read_en,
  input  wire [WIDTH-1:0]  write_data,
  output reg  [WIDTH-1:0]  read_data,
  output wire              full,
  output wire              empty
);
```

## How to Compile and Run

### Using Icarus Verilog (iverilog)

1. **Compile the design:**
```bash
cd APB_System
iverilog -g2012 -o apb_system_sim \
  ../Simple_Memory_Interface/simple_memory_interface.sv \
  ../APB_Slave/apb_slave.sv \
  ../APB_Master/apb_master.sv \
  fifo.sv \
  arbiter.sv \
  apb_system.sv \
  tb_apb_system.sv
```

2. **Run the simulation:**
```bash
vvp apb_system_sim
```

3. **View waveforms (optional):**
```bash
gtkwave apb_system.vcd
```

### Using Other Simulators

**ModelSim/QuestaSim:**
```bash
vlog -sv *.sv ../*/*.sv
vsim -c tb_apb_system -do "run -all; quit"
```

**VCS:**
```bash
vcs -sverilog -full64 *.sv ../*/*.sv
./simv
```

## Test Results

The testbench (`tb_apb_system.sv`) includes 9 comprehensive tests:

1. **Test 1**: Single Write Request - Verifies basic write functionality
2. **Test 2**: Single Read Request - Verifies basic read functionality
3. **Test 3**: Multiple Write Requests - Tests FIFO buffering
4. **Test 4**: Multiple Read Requests - Verifies multiple read operations
5. **Test 5**: Write Priority Test - Confirms writes are prioritized over reads
6. **Test 6**: Read-Write-Read Sequence - Tests data increment functionality
7. **Test 7**: FIFO Full Test - Verifies 16-deep FIFO buffer handling
8. **Test 8**: Alternating Read/Write - Tests mixed operation scenarios
9. **Test 9**: Stress Test - Rapid random requests

### Sample Output

```
===============================================
APB System Testbench Started
===============================================

Test 1: Single Write Request
Test 1 completed

Test 2: Single Read Request
Read data received: 0x00000001
Test 2 completed

...

===============================================
APB System Testbench Completed
Total Tests: 9
===============================================
```

## Key Features Verified

✅ Write operations have higher priority than reads
✅ System can buffer 16 requests without loss
✅ APB protocol properly implemented
✅ Data increment functionality works correctly
✅ FIFO overflow protection
✅ Valid/ready protocol honored
✅ Random delay memory access handled correctly

## Design Decisions

1. **Command Encoding**:
   - `2'b00`: No operation
   - `2'b01`: Read operation
   - `2'b10`: Write operation (increment previous read data)

2. **FIFO Implementation**:
   - Circular buffer with wrap-around pointers
   - Full/empty detection using MSB comparison
   - 16-deep to meet specification

3. **Arbiter Logic**:
   - Simple combinational priority logic
   - Write requests immediately override read requests
   - FIFO full signal prevents overflow

4. **State Machines**:
   - APB Master: 4-state FSM (IDLE, SETUP, ACCESS, WAIT)
   - APB Slave: 3-state FSM (IDLE, SETUP, ACCESS)
   - System Controller: Manages FIFO read and command generation

## Future Enhancements

- Add support for burst transfers
- Implement error handling and reporting
- Add configurable address ranges
- Support for multiple memory regions
- Performance counters and statistics

## Dependencies

This module requires:
- SystemVerilog-compatible simulator (iverilog with -g2012 flag, ModelSim, VCS, etc.)
- Proper APB Master module (Issue #2)
- Proper APB Slave module (Issue #3)
- Simple Memory Interface module (Issue #20)

## Contributing

When contributing to this module:
1. Maintain the existing interface definitions
2. Add appropriate assertions for verification
3. Update testbench to cover new features
4. Document design decisions in comments
5. Ensure all tests pass before submitting

## License

This implementation is part of the Twenty-One-Pilots project.
See the main repository LICENSE file for details.
