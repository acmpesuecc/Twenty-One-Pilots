`timescale 1ns / 1ps

module Muxes_tb();
    logic[3:0] a_i,
    logic[3:0] sel_i,
    logic y_ter_o, // Output using ternary operator
    logic y_case_o,    // Output using case
    logic y_if_else_o,    // Output using if-else
    logic y_loop_o,    // Output using for loop
    logic y_aor_o    // Output using and-or tree
    Muxes UUT(.a_i(a_i),.sel_i(sel_i),.y_ter_o(y_ter_o),y_case_o(y_case_o),.y_if_else_o(y_if_else_o),.y_loop_o(y_loop_o),.y_aor_o(y_aor_o));

    initial
        begin
            a_i=4'b0101;
            #10;
            sel_i=4'b0001;
            #10;
            sel_i=4'b0010;
            #10;
            sel_i=4'b0100;
            #10;
            sel_i=4'b1000;
            #10;
            $finish;
        end
        
endmodule
