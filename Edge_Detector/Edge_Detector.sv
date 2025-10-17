`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2025 03:14:22
// Design Name: 
// Module Name: Edge_Detector
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


module edge_detector (
    input  logic       clk,              
    input  logic       reset,            
    input  logic       a_i,              
    input  logic [1:0] edge_type_i,      
    output logic       rising_edge_o,    
    output logic       falling_edge_o    
);

logic a_prev;
always_ff@(posedge clk,negedge reset) begin
if (!reset) begin
a_prev<=1'b0;
rising_edge_o<=1'b0;
falling_edge_o <=1'b0;
end
else 
begin
a_prev<=a_i;
rising_edge_o  <= 1'b0;
falling_edge_o <= 1'b0;
case (edge_type_i)
2'b01: begin
if (!a_prev && a_i) begin
rising_edge_o <= 1'b1;
end
end
2'b10: begin 
if (a_prev && !a_i) begin
falling_edge_o <= 1'b1;
end
end
 2'b11: begin 
if (!a_prev && a_i) begin
rising_edge_o <= 1'b1;
end
if (a_prev && !a_i) begin
 falling_edge_o <= 1'b1;
end
end
default: begin 
end
endcase
end
end
endmodule
