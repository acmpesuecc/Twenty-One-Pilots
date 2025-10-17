`timescale 1ns/1ps

module Edge_Detector_tb;

    reg         clk;
    reg         reset;
    reg         a_i;
    wire        rising_edge_o;
    wire        falling_edge_o;
    
    integer     rising_edge_count;
    integer     falling_edge_count;
    
    integer     error_count;
    
    Edge_Detector #(
        .ACTIVE_HIGH_RST(1)
    ) DUT (
        .clk            (clk),
        .reset         (reset),
        .a_i           (a_i),
        .rising_edge_o (rising_edge_o),
        .falling_edge_o(falling_edge_o)
    );
    
    localparam CLK_PERIOD = 10;
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    initial begin
        initialize();
        
        $display("\nTest Case 1: Reset Check");
        test_reset();
        
        $display("\nTest Case 2: Single Rising Edge");
        test_single_rising_edge();
        
        $display("\nTest Case 3: Single Falling Edge");
        test_single_falling_edge();
        
        $display("\nTest Case 4: Multiple Transitions");
        test_multiple_transitions();
        
        $display("\nTest Case 5: Glitch Rejection");
        test_glitch_rejection();
        
        // Report results
        report_results();
        
        // End simulation
        #100 $finish;
    end
    
    task initialize;
        begin
            reset = 1'b1;
            a_i = 1'b0;
            rising_edge_count = 0;
            falling_edge_count = 0;
            error_count = 0;
            #(CLK_PERIOD*2);
            reset = 1'b0;
            #(CLK_PERIOD*2);
        end
    endtask
    
    task test_reset;
        begin
            reset = 1'b1;
            a_i = 1'b1;
            #(CLK_PERIOD*2);
            
            if (rising_edge_o !== 1'b0 || falling_edge_o !== 1'b0) begin
                $display("Error: Outputs not zero during reset!");
                error_count++;
            end
            
            reset = 1'b0;
            #(CLK_PERIOD*2);
        end
    endtask
    
    task test_single_rising_edge;
        begin
            a_i = 1'b0;
            #(CLK_PERIOD*2);
            a_i = 1'b1;
            
            @(posedge clk);
            if (rising_edge_o !== 1'b1) begin
                $display("Error: Rising edge not detected!");
                error_count++;
            end
            
            @(posedge clk);       // Next clock
            if (rising_edge_o !== 1'b0) begin
                $display("Error: Rising edge pulse too long!");
                error_count++;
            end
        end
    endtask
    
    task test_single_falling_edge;
        begin
            a_i = 1'b1;
            #(CLK_PERIOD*2);
            a_i = 1'b0;
            
            @(posedge clk);
            if (falling_edge_o !== 1'b1) begin
                $display("Error: Falling edge not detected!");
                error_count++;
            end
            
            @(posedge clk);       // Next clock
            if (falling_edge_o !== 1'b0) begin
                $display("Error: Falling edge pulse too long!");
                error_count++;
            end
        end
    endtask
    
    task test_multiple_transitions;
        begin
            repeat (5) begin
                a_i = 1'b1;
                #(CLK_PERIOD*2);
                a_i = 1'b0;
                #(CLK_PERIOD*2);
            end
        end
    endtask
    
    task test_glitch_rejection;
        begin
            a_i = 1'b0;
            #(CLK_PERIOD/4);
            a_i = 1'b1;
            #(CLK_PERIOD/4);
            a_i = 1'b0;
        end
    endtask
    
    task report_results;
        begin
            $display("\n----------------------------------------");
            $display("Test Complete!");
            $display("Total Errors: %0d", error_count);
            $display("----------------------------------------\n");
        end
    endtask
    
    always @(posedge clk) begin
        if (rising_edge_o)  rising_edge_count++;
        if (falling_edge_o) falling_edge_count++;
    end
    
    initial begin
        $dumpfile("edge_detector_tb.vcd");
        $dumpvars(0, Edge_Detector_tb);
    end

endmodule