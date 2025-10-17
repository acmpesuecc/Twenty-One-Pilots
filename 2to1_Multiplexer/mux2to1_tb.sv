`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2025 02:34:44
// Design Name: 
// Module Name: mux2to1_tb
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


module mux2to1_tb;
reg [7:0] a_i,b_i;
reg sel_i;
wire [7:0] y_o;
mux2to1  dut (a_i,b_i,sel_i,y_o);
initial
begin
sel_i=1'b0;a_i=8'b10101010;b_i=8'b11111111;
sel_i=1'b1;a_i=8'b10101010;b_i=8'b11111111;
end
endmodule
