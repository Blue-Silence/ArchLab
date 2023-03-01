`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ETH Zurich
// Engineer: Frank K. Gurkaynak
// 
// Create Date:    08:45:28 03/22/2011 
// Design Name: 
// Module Name:    ControlUnit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ControlUnit(
      input  [5:0] Op,
		input  [5:0] Funct,
		output       Jump,
		output       MemtoReg,
		output       MemWrite,
		output       Branch,
		output [5:0] ALUControl,
		output       ALUSrc,
		output       RegDst,
		output       RegWrite
    );
	 
//////////////////////////////////////////////////////////////////////////////////
// DEFINE SOME CONSTANTS to make life easier
localparam [5:0] OP_RTYPE = 6'b000000;  // There is an R-Type of Operation
localparam [5:0] OP_LW    = 6'b100011;  // The Load Word operation
localparam [5:0] OP_SW    = 6'b101011;  // The Store Word operation
localparam [5:0] OP_BEQ   = 6'b000100;  // The Branch on Equal operation
localparam [5:0] OP_ADDI  = 6'b001000;  // The ADDimmediate operation
localparam [5:0] OP_J     = 6'b000010;  // The Jump operation

//////////////////////////////////////////////////////////////////////////////////
// DEFINE THE MAIN CONTROL SIGNALS
// The control signals are mostly based on the table 7.5 on page 379
// Don't care statements have been mapped to '0' in most cases
//
// All signals are handled separately, see alternative for an example


// We will write to registers when OP is Rtype or LW or ADDI 
assign RegWrite = (Op == OP_RTYPE) | (Op == OP_LW) | ( Op == OP_ADDI) ; 	 
// Select the input of the ALU
assign ALUSrc   = (Op == OP_LW) | (Op == OP_SW) | (Op == OP_ADDI) ;

// Simple assignments
assign RegDst   = (Op == OP_RTYPE); // The destination is a register
assign Branch   = (Op == OP_BEQ);   // 1: if there is a branch instruction 
assign MemWrite = (Op == OP_SW);    // 1: for Store Word
assign MemtoReg = (Op == OP_LW);	   // 1: when Load Word
assign Jump     = (Op == OP_J);	   // 1: when Jump

//////////////////////////////////////////////////////////////////////////////////
// THE ALU Controls, these are bit more complex
// 
// The book uses a 2 bit ALU word (page 375) 
// The example here is slightly different

assign ALUControl = ALUSrc ? 6'b100000 :  // if LW, SW or ADDI, perform an ADD
                    Branch ? 6'b100010 :  // if BEQ, perform a SUB
					              Funct;       // per default assume an R-Type and do what Funct says
	 
//////////////////////////////////////////////////////////////////////////////////
// ALTERNATIVE APPROACH
//
// In the code above we chose to generate the signals separately
// For each signal we had a simple function that generated the 
// appropriate logic.

// It is also possible to generate a compound statement as shown 
// below.

// There is less to type, but individual signals are not clearly 
// defined. Which one is better really also depends on how complex
// the signals are 

//  reg [8:0] controls;
//
//  assign {RegWrite, RegDst, AluSrc,
//          Branch, Memwrite,
//          Memtoreg, Jump, aluop} = controls;
//
//  always @( * )
//    case(op)
//      6'b000000: controls <= 9'b110000010; //Rtype
//      6'b100011: controls <= 9'b101001000; //LW
//      6'b101011: controls <= 9'b001010000; //SW
//      6'b000100: controls <= 9'b000100001; //BEQ
//      6'b001000: controls <= 9'b101000000; //ADDI
//      6'b000010: controls <= 9'b000000100; //J
//      default:   controls <= 9'bxxxxxxxxx; //???
//    endcase


//////////////////////////////////////////////////////////////////////////////////
// DISCUSSION
// 
// Generally it is not a very good idea to separate the controller 
// from the datapath as it is done here. The control signals generated
// here are intimately connected with the datapath (usually switching
// multiplexers) and it is much easier to include them in the datapath.
// 
// For teaching purposes, separating the control in an instance makes 
// sense, as it is easier to explain how the signals are generated.
// It also allows for multiple signals generated in a compound way. The
// book uses this way, and we used it this way.
//
// If you need to for example add a new contrtol signal, you need to
// change this instance, modify the interface and then adapt the instantiation
// in the instance where the datapath is. It is simpler (and less error prone)
// if the control signals can be generated within the same instance as the
// datapath. Obviosuly there are exceptions where a separate control instance 
// is much simpler (i.e. very complex signals, multiple datapaths using
// the same controller etc)


endmodule
