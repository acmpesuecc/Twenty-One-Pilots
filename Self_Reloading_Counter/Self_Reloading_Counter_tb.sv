`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2025 03:41:03
// Design Name: 
// Module Name: Self_Reloading_Counter_tb
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


module Self_Reloading_Counter_tb;
`timescale 1ns / 1ps
logic clk;
 logic reset;
 logic load_i;
 logic[3:0] load_val_i;
 wire [3:0] count_o;
  Self_Reloading_Counter dut(.clk(clk),.reset(reset),.load_i(load_i),.load_val_i(load_val_i),.count_o(count_o));
  localparam CLK_PERIOD = 20ns;
  initial
  begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk=~clk;
  end

  initial 
  begin
    reset = 1; load_i = 0; load_val_i = 4'h0;
    @(posedge clk);
    reset = 0;
    
    repeat (5) @(posedge clk);
    load_i = 1; load_val_i = 4'hA; 
    
    @(posedge clk); 
    load_i = 0;    
    if (count_o !== 4'hA) $error("test failed", count_o);
    repeat (5) @(posedge clk);  
    if (count_o !== 4'hF) $error("Test Failed", count_o);
    @(posedge clk);     
    if (count_o !== 4'hA) $error("Test fail", count_o);    
    load_i = 1; load_val_i = 4'h3;
    @(posedge clk);
    load_i = 0; 
    repeat (5) @(posedge clk);
    repeat (7) @(posedge clk);    
    @(posedge clk);
    if (count_o !== 4'h3) $error("Test Failed", count_o);
    $stop;
  end
endmodule
