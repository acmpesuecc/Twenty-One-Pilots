`timescale 1ns/1ps

module Parallel_to_Serial_tb;
    // Test signals
    logic       clk;
    logic       reset;
    logic [3:0] parallel_i;
    logic       empty_o;
    logic       serial_o;
    logic       valid_o;
    
    // Test storage
    logic [3:0] expected_data;
    integer     bit_count;
    
    // Instantiate DUT
    Parallel_to_Serial dut (
        .clk(clk),
        .reset(reset),
        .parallel_i(parallel_i),
        .empty_o(empty_o),
        .serial_o(serial_o),
        .valid_o(valid_o)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Dump generation
    initial begin
        $dumpfile("parallel_to_serial.vcd");
        $dumpvars(0, Parallel_to_Serial_tb);
    end
    
    // Test stimulus
    initial begin
        // Initialize
        reset = 1;
        parallel_i = 4'h0;
        #20;
        
        // Test 1: Reset verification
        reset = 0;
        @(posedge clk);
        if (!empty_o || valid_o)
            $error("Reset state incorrect");
            
        // Test 2: Basic operation
        parallel_i = 4'b1010;
        expected_data = 4'b1010;
        @(posedge clk);
        for(bit_count = 0; bit_count < 4; bit_count++) begin
            if (serial_o !== expected_data[0])
                $error("Bit %0d incorrect, got %b, expected %b", 
                       bit_count, serial_o, expected_data[0]);
            expected_data = expected_data >> 1;
            @(posedge clk);
        end
        
        // Test 3: Continuous operation
        parallel_i = 4'b1111;
        expected_data = 4'b1111;
        for(bit_count = 0; bit_count < 4; bit_count++) begin
            if (serial_o !== expected_data[0])
                $error("Continuous bit %0d incorrect", bit_count);
            expected_data = expected_data >> 1;
            @(posedge clk);
        end
        
        // Test 4: Random data
        repeat(5) begin
            parallel_i = $random;
            expected_data = parallel_i;
            @(posedge clk);
            for(bit_count = 0; bit_count < 4; bit_count++) begin
                if (serial_o !== expected_data[0])
                    $error("Random test failed");
                expected_data = expected_data >> 1;
                @(posedge clk);
            end
        end
        
        // End simulation
        #100;
        $display("Test completed");
        $finish;
    end
    
    // Continuous monitoring
    always @(posedge clk) begin
        $display("Time=%0t reset=%b parallel=%b serial=%b valid=%b empty=%b", 
                 $time, reset, parallel_i, serial_o, valid_o, empty_o);
    end
    
    // Protocol assertions
    property valid_empty_exclusive;
        @(posedge clk) !(valid_o && empty_o);
    endproperty
    assert property(valid_empty_exclusive);
    
endmodule