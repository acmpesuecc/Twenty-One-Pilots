`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2025 02:21:58
// Design Name: 
// Module Name: mux2to1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux2to1(a_i,b_i,sel_i,y_o);
    input logic [7:0] a_i;
    input logic  [7:0]  b_i;
    input logic  sel_i;
    output logic [7:0] y_o;
    assign y_o= sel_i?b_i:a_i;
endmodule
