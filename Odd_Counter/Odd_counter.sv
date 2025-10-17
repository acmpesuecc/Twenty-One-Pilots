`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2025 01:08:24
// Design Name: 
// Module Name: Odd_counter
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


module Odd_counter(clk,reset,cnt_o);
input logic clk;
input logic reset;
output logic[7:0]  cnt_o;
always_ff @(posedge clk)
begin
if(reset)
cnt_o<=8'b0;
else
cnt_o<= 2*cnt_o+1;
end
endmodule
