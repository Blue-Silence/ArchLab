`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2023/01/12 18:06:52



module adder(input r1, input r2, input cin, output s, output cout);
    assign s = r1 ^ r2 ^ cin;
    assign cout = (r1 & r2) | (r1 & cin) | (r2 & cin);
endmodule


module adder_4(input [3:0] r1, input [3:0] r2, output [3:0] s);
   wire c01, c12, c23, c3;
   adder a0 (r1[0], r2[0], 1'b0, s[0], c01);
   adder a1 (r1[1], r2[1], c01, s[1], c12);
   adder a2 (r1[2], r2[2], c12, s[2], c23);
   adder a3 (r1[3], r2[3], c23, s[3], c3);
endmodule
