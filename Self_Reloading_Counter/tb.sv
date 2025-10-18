`timescale 1ns / 1ps

module tb();
    logic         clk;
    logic         reset;
    logic         up_down;    // 1 for Up Count, 0 for Down Count
    logic         load_i;     // Load value is valid this cycle
    logic         load_val_i; // 4-bit load value
    logic         [3:0]count;    // Counter output);
    rtl UUT(.clk(clk),.reset(reset),.up_down(up_down),.load_i(load_i),.load_val_i(load_val_i),.count(count));

    always #5 clk = ~clk;

    initial 
        begin
            clk=0;
            load_i=0;
            load_val_i=4'b0000;
            count=0;
            reset=1; #30;
            reset=0;
            load_i=0;
            up_down=1;
            #100;
            up_down=0;
            #100;
            load_i=1;
            load_val_i=4'b0101;
            up_down=1;
            #100;
            load_val_i=4'b1011;
            up_down=0;
            #100;
            $finish;
        end

endmodule
