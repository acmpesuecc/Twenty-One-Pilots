`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2025 03:32:28
// Design Name: 
// Module Name: Self_Reloading_Counter
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


module Self_Reloading_Counter(
    input wire clk,
    input wire reset,
    input wire load_i,
    input wire[3:0]load_val_i,
    output wire[3:0] count_o );
    logic [3:0] count_reg;
    logic [3:0] reload_val_reg; 
    localparam MAX_COUNT = 4'b1111;

  always_ff @(posedge clk) begin
    if (reset) 
    begin
      reload_val_reg <= 4'h0;
    end 
    else if (load_i) 
    begin
      reload_val_reg <= load_val_i;
    end
  end
  always_ff @(posedge clk) 
  begin
    if (reset) 
    begin
      count_reg <= 4'h0;
    end 
    else if (load_i) 
    begin
      count_reg <= load_val_i;
    end 
    else if (count_reg == MAX_COUNT) 
    begin
      count_reg <= reload_val_reg;
    end 
    else 
    begin
      count_reg <= count_reg + 1;
    end
end
assign count_o = count_reg;
endmodule
