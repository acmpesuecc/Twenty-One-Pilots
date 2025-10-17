# Step 1: Compile
iverilog -o fifo_tb tb_Synchronous_FIFO.v Synchronous_FIFO.v

# Step 2: Run the simulation
vvp fifo_tb

# Step 3: View waveform in GTKWave (optional)
echo "Opening GTKWave..."
gtkwave fifo.vcd &