`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2023/01/12 18:06:52


module FullAdder(input a, input b, input ci, output s, output co);
    assign s = a ^ b ^ ci;
    assign co = (a & b) | (a & ci) | (b & ci);
endmodule


module FourBitAdder(input [3:0] a, input [3:0] b, output [4:0] s);
   wire c01, c12, c23;
   adder a0 (a[0], b[0], 1'b0, s[0], c01);
   adder a1 (a[1], b[1], c01, s[1], c12);
   adder a2 (a[2], b[2], c12, s[2], c23);
   adder a3 (a[3], b[3], c23, s[3], s[4]);
endmodule
