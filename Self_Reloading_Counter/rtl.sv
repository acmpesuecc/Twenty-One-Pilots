`timescale 1ns / 1ps

module rtl(
    input     logic          clk,
    input     logic          reset,
    input     logic          up_down,    // 1 for Up Count, 0 for Down Count
    input     logic          load_i,     // Load value is valid this cycle
    input     logic[3:0]     load_val_i, // 4-bit load value

    output    logic[3:0]     count     // Counter output);
    );
                always_ff@(posedge clk)
                begin
                    if(reset==1)
                        begin
                            count<=0;
                        end
                    else
                        begin
                            if(load_i==1)
                                begin
                                    count<=load_val_i;
                                    if(up_down==1)
                                        begin
                                            count<=count+(1'b1);
                                        end
                                    else
                                        begin
                                            count<=count-(1'b1);
                                        end
                                end
                            else
                                begin
                                    if(up_down==1)
                                        begin
                                            count<=0;
                                            count<=count+(1'b1);
                                        end
                                    else
                                        begin
                                            count<=(4'b1111);
                                            count<=count-(1'b1);
                                        end
                                end
                        end
            end
    
endmodule
