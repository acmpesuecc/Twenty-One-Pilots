module Muxes_tb();
logic [3:0] sel_i, a_i;
logic y_ter_o, y_case_o, y_ifelse_o, y_loop_o, y_aor_o;
Muxes dut(a_i, sel_i, y_ter_o, y_case_o, y_ifelse_o, y_loop_o, y_aor_o);

initial begin
    a_i=4'b1011;
    sel_i=4'b1000;
    #5 sel_i=4'b0100;
    #5 sel_i=4'b0010;
    #5 sel_i=4'b1001;
    #5 sel_i=4'b1100;
    #5 $finish;
end
endmodule