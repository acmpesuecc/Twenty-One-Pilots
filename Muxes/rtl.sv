`timescale 1ns / 1ps

module hn7_1(
    input     wire[3:0] a_i,
    input     wire[3:0] sel_1,
    input     wire[3:0] sel_2,
    input     wire[3:0] sel_3,
    input     wire[3:0] sel_4,
    input     wire[3:0] sel_5,

    output    logic     y_ter_o, // Output using ternary operator
    output    logic     y_case_o,    // Output using case
    output    logic     y_if_else_o,    // Output using if-else
    output    logic     y_loop_o,    // Output using for loop
    output    logic     y_aor_o    // Output using and-or tree
);

    always_comb
    
    //Ternary
    assign y_ter_o = sel_1[3]?(a_i[3]):(sel_2[2]?(a_i[2]):(sel_3[1]?(a_i[1]):(a_i[0])));
    
    //Case Statement
            begin
                case(sel_2)
                    begin
                    4'b0001:
                        assign y_case_o=a_i[0];
                    4'b0010:
                        assign y_case_o=a_i[1];
                    4'b0100:
                        assign y_case_o=a_i[2];
                    4'b1000:
                        assign y_case_o=a_i[3];
                    default:
                        assign y_case_o=a_i[0];
                    end
            end
    
    //If-Else Statements
            begin
                if (sel_3==4'b0001)
                begin
                    assign y_if_else_o=a_i[0];
                end
                else if (sel_3==4'b0010)
                begin
                        assign y_if_else_o=a_i[1];
                end
                else if (sel_3==4'b0100;
                begin
                        assign y_if_else_o=a_i[2];
                end
                else
                        assign y_if_else_o=a_i[3];
            end
    
    //For loop
            begin
                integer i;
                for(i=0;i<4;i++)
                begin
                        if(sel_4[i])
                        begin
                            assign y_loop_o=a_i[i];
                        end
                end
            end
    
    
    //And-Or Tree with And/Or Gates
            begin
                logic and_select_one, and_select_two, and_select_three, and_select_four;
    
                and a1(and_select_one, sel_5[0], a_i[0]);
                and a2(and_select_two, sel_5[1], a_i[1]);
                and a3(and_select_three, sel_5[2], a_i[2]);
                and a4(and_select_four, sel_5[3], a_i[3]);
    
                or(y_aor_o,and_select_one, and_select_two, and_select_three, and_select_four);
            end

endmodule

            
