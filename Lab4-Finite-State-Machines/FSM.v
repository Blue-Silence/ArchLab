`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2023/02/08 13:50:15
//////////////////////////////////////////////////////////////////////////////////


module FSM(input clk
           ,input reset
           ,input left
           ,input right
           ,output LA
           ,output LB
           ,output LC
           ,output RA
           ,output RB
           ,output RC
           );
           
    FSM_L lightL (clk, reset, left, {LC, LB, LA});
    FSM_L lightR (clk, reset, right, {RC, RB, RA});

endmodule

module FSM_L(input clk
           ,input reset
           ,input enable
           ,output reg [2:0] L
           );
               
    always @ (negedge reset)
        L<=0;
    
    always @ (posedge clk)
    begin
        if (L == 0 && enable)
            L <= 3'b1;
        else if (L == 3'b1)
            L <= 3'b11;
        else if (L == 3'b11)
            L<= 3'b111;
        else if (L == 3'b111)
            L <= 0;
    end

endmodule




