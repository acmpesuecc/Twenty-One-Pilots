module 2to1_Multiplexer
    input   wire [7:0]    a_i   // First leg of the mux
    input   wire [7:0]    b_i   // Second leg of the mux
    input   wire          sel_i // Mux select
    output  wire [7:0]    y_o   // Mux output

    assign y_o[0] = (sel_i==0)?a_i[0]:b_i[0]
    assign y_o[1] = (sel_i==0)?a_i[1]:b_i[1]
    assign y_o[2] = (sel_i==0)?a_i[2]:b_i[2]
    assign y_o[3] = (sel_i==0)?a_i[3]:b_i[3]
    assign y_o[4] = (sel_i==0)?a_i[4]:b_i[4]
    assign y_o[5] = (sel_i==0)?a_i[5]:b_i[5]
    assign y_o[6] = (sel_i==0)?a_i[6]:b_i[6]
    assign y_o[7] = (sel_i==0)?a_i[7]:b_i[7]
endmodule