`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ETH Zurich
// Engineer: Frank K. Gurkaynak
// 
// Create Date:    18:20:55 03/21/2011 
// Design Name: 
// Module Name:    MIPS 
// Project Name:   Lab 8
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
module MIPS(
             input CLK,                   // Clock signal
				 input RESET,                 // Reset Active low will set back the Program counter
				 output [31:0] IOWriteData,   // IO Data to be written to the interface
				 output  [3:0] IOAddr,        // IO Address we use 4 bits, could also be more
				 output        IOWriteEn,     // 1: There is a valid IO Write
				 input  [31:0] IOReadData     // 32bit input from the I/O interface        
    );

   // The MIPS processor
	// (Mostly) based on the descriptions on the textbook 
	// Digital Design and Computer Architecture
	// Chapter 7, Section 7.3, pages 368-381

//////////////////////////////////////////////////////////////////////////////////
   // Signal Declarations
	// Refer to Figure 7.14 page 379 for names 

   // Instruction Decoding
	wire [31:0] Instr;     // The output of the Instruction memory
   wire [31:0] SignImm;   // 32-bit extended Immediate value
   wire  [4:0] WriteReg;  // Address of the register for write back

	// Address controls 
	reg  [31:0] PC;        // The Program counter (registered)
	wire [31:0] PCbar;     // Next state value of the Program counter, PC' in the diagram
   wire [31:0] PCCalc;    // Calculated value for the (next) PC
   wire [31:0] PCJump;    // Value for immediate jump
	wire [31:0] PCBranch;  // Value calculated for the branch instructions
	wire [31:0] PCPlus4;   // The current value of PC + 4, default next memory address

   // ALU related
   wire [31:0] SrcA;      // One input of the ALU
   wire [31:0] SrcB;      // Other input of the ALU
	wire [31:0] ALUResult; // The output of the ALU
	wire        Zero;      // The Zero flag, 1: if ALUResult == 0 
	
	// Data Memory
	wire [31:0] WriteData; // The output of Register File port 2,
	wire [31:0] ReadData;  // Output of the Data Memory
	wire [31:0] Result;    // End result that will be written back to register file
	wire        MemWrite;  // Write Enable for the Memory
	
	// Control Signals
	wire        Jump;      // A direct jump instruction has been issued
	wire        MemtoReg;  // 1: Copy data from Data Memory to Register File
	wire        Branch;    // 1: We have a branch instruction
	wire        PCSrc;     // We have a Branch AND ALUResult is zero, we will branch
	wire  [5:0] ALUControl;// Control signals for the ALU
	wire        ALUSrc;    // 0: Register file, 1: Immediate value
	wire        RegDst;    // Destination Register 1: Instr[15:11] 0: Instr[20:15]
	wire        RegWrite;  // 1: We will write back to the RegisterFile

   // Memory Mapped I/O Signals
   wire        IsIO;      // 1: if Address is in I/O range 0x00007ff0 to 0x0007fff
	wire        IsMemWrite;// 1: if MemWrite and not IsIO, tells us that we write to memory
	                       //    and not to the IO
	wire [31:0] ReadMemIO;  // Read from either Memory or I/O
	
//////////////////////////////////////////////////////////////////////////////////
// The Main Part of the MIPS processor 

   ////////////////////////////////////
	// The Program Counter
	always @ ( posedge CLK, posedge RESET ) 
	  if    (RESET	  == 1'b1) PC <= 32'h00002FFC; // default program counter 
	  else                    PC <= PCbar;        // Copy next value to present
	
	// Calculation of the next PC value
   assign PCPlus4  = PC + 4;                             // By default the PC increments by 4
   assign PCBranch = PCPlus4 + {SignImm[29:0],2'b00};    // The branch address see Page 373, Fig 7.10
	assign PCCalc = PCSrc ? PCBranch : PCPlus4;           // Multiplexer selects Branch or only +4
   assign PCJump = {PCPlus4[31:28], Instr[25:0], 2'b00}; // The Jump value
	assign PCbar  = Jump  ? PCJump   : PCCalc;            // Multiplexer selects Jump or Normal

   /////////////////////////////////////
   // Instantiate the Instruction Memory
	  InstructionMemory i_imem (
                              .A(PC[5:0]),
                              .RD(Instr)  // TODO Part 1
                              );
										
   // Sign extension, replicate the MSB of the Immediate value 
	assign SignImm = {{16{Instr[15]}},Instr[15:0]};

   // Determine the Write Back address for the Register File
	assign WriteReg = RegDst ? Instr[15:11] : Instr[20:16];
	
   ////////////////////////////////////
   // Instantiate the Register File
     RegisterFile i_regf (
                          .A1(Instr[25:21]),   // Address for First Register
                          .A2(Instr[20:16]),   // Address for Second Register
                          .A3(WriteReg),       // Address for Write Back
                          .RD1(SrcA),          // First output directly connected to ALU
                          .RD2(WriteData),     // Second output
                          .WD3(Result),        // Output of ALU or Data Memory
                          .WE3(RegWrite),      // From the control unit
                          .CLK(CLK)            // System Clock (10 MHz)
                         );


   ////////////////////////////////////
   // ALU: first determine the inputs, and then instantiate the ALU
	assign SrcB = ALUSrc ? SignImm : WriteData ; // ALU input is either immediate or from register

     ALU i_alu (
                .a(SrcA),
                .b(SrcB),// TODO Part 1
                .aluop(ALUControl[3:0]),
                .result(ALUReslt),
                .zero(Zero)
                );	
					 
   // Generate the PCSrc signal that tells to take the branch
	assign PCSrc = Branch & Zero;                // simple AND
   
   ////////////////////////////////////
	// Instantiate the Data Memory
	  DataMemory i_dmem (
                        .CLK(CLK),
                        .A(ALUResult[7:2]),
                        .WE(IsMemWrite),
                        .WD(WriteData),
                        .RD(Result)
                        // TODO Part 1
                        );

   // Memory Mapped I/O
   assign IsIO = (ALUResult[31:4] == 28'h00007ff) ? 1 : 0; // 1: when datamemory address
	                                                  // falls into I/O  address range
   // TODO Part 1
   assign IsMemWrite  = MemWrite & (~ IsIO);               // Is 1 when there is a SW instruction on DataMem address
   assign IOWriteData = WriteData;               // This line is connected directly to WriteData
   assign IOAddr      = ALUResult[3:0];               // The LSB 4 bits of the Address is assigned to IOAddr
   assign IOWriteEn   = MemWrite & IsIO;               // Is 1 when there is a SW instruction on IO address 
   

   assign ReadMemIO   = IsIO ? IOReadData : ReadData;   // Mux selects memory or I/O	
   // Select either the Data Memory (or IO) output or the ALU Result	
   assign Result = MemtoReg ? ReadMemIO : ALUResult;    // Slightly modified to include above

   ////////////////////////////////////
   // The Control Unit
   ControlUnit i_cont (
                        .Op(Instr[31:26]),
                        .Funct(Instr[5:0]),
                        .Jump(Jump),
                        .MemtoReg(MemtoReg),
                        .MemWrite(MemWrite),
                        .Branch(Branch),
                        .ALUControl(ALUControl),
                        .ALUSrc(ALUSrc),
                        .RegDst(RegDst),
                        .RegWrite(RegWrite)//TODO Part 1
                       );


endmodule
