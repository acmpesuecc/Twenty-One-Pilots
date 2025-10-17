module TB;
reg [7:0] A, [7:0] B, S;
wire [7:0] X;
initial
begin
$dumpfile("MUX2_text.vcd");
$dumpvars(0, TB);
end

mux2 newMUX(.a_i(A), .b_i(B), .sel_i(S), .y_o(X));

initial
begin

S = 1'b0;
A = 8'b10101010;
B = 8'b01010101;

S = 1'b1;
A = 8'b00001111;
B = 8'b01010101;

S = 1'b0;
A = 8'b00001111;
B = 8'b11110000;

S = 1'b1;
A = 8'b10101010;
B = 8'b11110000;

end
endmodule
