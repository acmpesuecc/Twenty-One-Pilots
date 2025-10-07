
# Twenty-One-Pilots

Welcome to the **Twenty-One-Pilots** repository! This repo contains **21 SystemVerilog modules** for contributors to design, verify, and test as part of the Hacknight 7.0 challenge. Each module has its own folder with instructions and starter code.

> [!IMPORTANT]
> Add your `rtl.sv` and `tb.sv` into the module folder you want to design.
> ```
> 2to1_mux/
>├─ rtl.sv       <- Your module implementation
>├─ tb.sv        <- Testbench
>└─ waveform.png <- Screenshot showing module works
>```

## Submission Guidelines

1. **Mandatory**
    
    - RTL code (`rtl.sv`)
        
    - Testbench (`tb.sv`)
        
    - Waveform screenshot showing your module works correctly
        
2. **Optional / Extra Points**
    
    - Self-checking testbench
        
    - Layered testbench (more advanced verification)
        
3. **File & Naming Conventions**
    
    - Module name in `rtl.sv` must match the file name (e.g., `2to1_mux.sv` → `module 2to1_mux`).
        
    - Testbench should use `_tb` suffix (e.g., `2to1_mux_tb.sv`).
        
4. **Workflow**
    
    - Fork the repo
        
    - Complete your assigned module
        
    - Submit a Pull Request (PR) with your changes
        
    - PRs will be **manually reviewed** by the maintainer
        
    - If submission is incomplete or incorrect, PR may be closed
        

## Evaluation

- **Correct RTL + Basic TB** → Manual review for correctness
    
- **Self-checking TB** → Bonus points
    
- **Layered TB** → Highest bonus points
    

## Tools / Recommendations

- Recommended simulators: **Vivado, Quartus Lite, Verilator** (for Linux)
    
- For Windows users, Vivado / Quartus Lite are preferred for simulation
    
- Screenshots of waveforms are mandatory to show your module works
    

## Rules

- Only one PR per module will be accepted.
    
- Submit within your allocated timeframe.
    
- Follow naming conventions strictly.
    
- Be creative, but the mandatory interface and signal names **must not change**.