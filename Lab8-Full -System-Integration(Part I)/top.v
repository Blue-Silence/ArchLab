`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:23:20 05/18/2011 
// Design Name: 
// Module Name:    top 
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
module top(
        input             FPGACLK,
        // TODO PART II for Lab 8
        // add input port to read the switch value for speed control of the snake
		  input             RESET,
		  output     [6:0]  LED,
	     output reg [3:0]  AN
    );

// Define internal signals
  wire CLK;                 // The output of the clock divider 10 MHz Clock

// MIPS interface
  wire [31:0] IOWriteData;
  wire  [3:0] IOAddr;
  wire        IOWriteEn;
  wire [31:0] IOReadData;
// Signals for driving the LED, note all are 'reg'
  reg   [27:0] DispReg;        // Register that holds the number
  reg   [6:0]  DispDigit;      // Present 4bit value to drive the 
  reg   [15:0]  DispCount;     // Simple counter to go through all options
                               // The counter is large to allow enough time
                               // for each LED to fully light up. 
                               // we could probably increase it a bit further

// Signals for composing the input
  wire  [1:0]  IOin;           // output of the multiplexer


// Instantiate an internal clock divider that will 
// take the 50 MHz FPGA clock and divide it by 5 so that
// We will have a simple 10 MHz clock internally
clockdiv ClockDiv (
    .clk(FPGACLK), 
    .rst(RESET), 
    .clk_en(CLK)
    );

// Counter for the display refresh
  always @ (posedge CLK, posedge RESET)
     if (RESET) DispCount = 0;
	  else       DispCount = DispCount + 1;

// Simple Way to determine the outputs, use a combinational process
// Use the MSB of the Disp count so that each digit lights up for
// 1.6ms  == 65536/4 * 100ns
   always @ ( * )  // combinational process
	   begin
		   case (DispCount[15:14])
			  2'b00:   begin AN = 4'b1110; DispDigit = DispReg[6:0];  end   // LSB
			  2'b01:   begin AN = 4'b1101; DispDigit = DispReg[13:7];  end   // 2nd digit
			  2'b10:   begin AN = 4'b1011; DispDigit = DispReg[20:14]; end   // 3rd digit
			  2'b11:   begin AN = 4'b0111; DispDigit = DispReg[27:21];end   // MSB, default
			endcase  
		end
		
// Instantiate the 7segment Display Driver
// led_driver sevendriver ( .S(DispDigit), .D(LED) );  // Instantiate the driver
   assign LED = ~DispDigit;
	

   // TODO for Part II of Lab 8
   // The speed of the snake must be read as input and sent to the MIPS processor.
   // Create the 32 bit IOReadData based on IOAddr value. Remember IOAddr is a 4-bit
   // value.
    
   // assign IOReadData = ;


// Register to save the 28-bit Value
  always @ (posedge CLK, posedge RESET)
    if      (RESET)     DispReg = 28'h0;          // Funny default value 
	 else if (IOWriteEn)                              // Only when IOWrite 
	           DispReg = IOWriteData[27:0];           // only the lower half
	 

// Instantiate the processor
MIPS processor (
    .CLK(CLK), 
    .RESET(RESET), 
    .IOWriteData(IOWriteData), 
    .IOAddr(IOAddr), 
    .IOWriteEn(IOWriteEn), 
    .IOReadData(IOReadData)
    );



endmodule
