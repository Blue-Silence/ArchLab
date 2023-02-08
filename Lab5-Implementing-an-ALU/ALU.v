`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2023/02/08 15:06:35
//////////////////////////////////////////////////////////////////////////////////


module ALU( input [3:0] AluOp
            ,input [31:0] A
            ,input [31:0] B
            ,output [31:0] Result
            ,output Zero
          );

    wire [31:0] arithmeticO, logicO;
    
    aP a ({AluOp[3],AluOp[1]}, A, B, arithmeticO);
    lP l (AluOp[1:0], A, B, logicO);
    
    assign Result = (AluOp[2]) ? logicO : arithmeticO;
    assign Zero = (Result == 0) ? 1 : 0;
    
endmodule


module aP(  input [1:0] Op
            ,input [31:0] A
            ,input [31:0] B
            ,output [31:0] Result
          );
          
    wire [31:0] re2;
    wire [31:0] b2;
    
    assign b2 = (Op[0]) ? ((~B) +1) : B;
    assign re2 = A + b2;
    assign Result = (Op[1]) ? {31'b0,re2[31]} : re2;
    
endmodule

module lP(  input [1:0] Op
            ,input [31:0] A
            ,input [31:0] B
            ,output [31:0] Result
          );
          
    wire [31:0] rA, rO, rX, rN;
    assign rA = A & B;
    assign rO = A | B;
    assign rX = A ^ B;
    assign rN = ~rO;
    
    assign Result = (Op == 2'b00) ? rA :
                    (Op == 2'b01) ? rO :
                    (Op == 2'b10) ? rX :
                    (Op == 2'b11) ? rN :
                    32'bx;
endmodule