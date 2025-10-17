`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2025 01:13:33
// Design Name: 
// Module Name: tb
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


module tb;
reg clk;
reg reset;
wire [7:0]  cnt_o;
Odd_counter dut(clk,reset,cnt_o);
always
#5 clk = ~clk;
initial
begin
clk = 1'b0;
reset = 1'b0;
#10 reset = 1'b1;
end
endmodule
