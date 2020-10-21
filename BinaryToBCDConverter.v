`timescale 1ns / 1ps
//==================================================================================
//
// Author : Buddika Sumanasena
// Company: US Medical Innovations
// Description: This Verilog module is used to convert binary numbers into Binary Coded Decimal . The Binary Coded Decimal number
// can then be displayed in a seven segment display.
// Dependencies: none 
//
//==================================================================================

module BinaryToBCDConverter(Clk,BinaryNumber,BCDNumber,reset);
    
		parameter BitWidth = 17;   					// Defines the bitwidth of the binary number to be converted to BCD.
		parameter BCDDigits = 6;						// Defines the number of BCD digits required for the BCD representation. 
	 
	 
		input Clk;  										// Main clock input of.
		input [BitWidth-1:0] BinaryNumber;  		// Binary number to be converted to BCD. 
		input reset;   									//	Active high reset. When the reset is high the module is idle.
	 
		 output reg [BCDDigits*4-1:0] BCDNumber;	// Binary Coded Decimal Output.  
		 
//==========================================================================
//  REG/WIRE declarations
//==========================================================================
		 
		 reg [BCDDigits*4-1:0] BCDNumber_buffer;
		 reg [BitWidth-1:0] BinaryNumber_buffer;
		 
		 parameter state_reg_width=logarithm(BitWidth);
		 integer j;
		 
		 reg [state_reg_width:0] state;

//==========================================================================
//  This function is used to compute the width of the state register 
//  given the number of bits in the binary number.
//==========================================================================		 
		 
		 function integer logarithm;
		 input integer input_value;       
			  integer i;
			  begin
					logarithm = 0;
					for(i = 0; 2**i < input_value; i = i + 1)
					begin
						 logarithm = i + 1;
					end
			  end     
		 endfunction
		
//==========================================================================
//  This state machine implements the Double-Dable algorithm.
//==========================================================================	
	 
		 always @(posedge Clk)
		 begin
				if(state==0)
				begin
					BCDNumber_buffer<=0;
					BinaryNumber_buffer<=BinaryNumber;
					state<=state+1;
				end
				else
				begin
					if(state<=BitWidth)
					begin
						BCDNumber_buffer={BCDNumber_buffer[BCDDigits*4-2:0],BinaryNumber_buffer[BitWidth-1]};
						BinaryNumber_buffer=BinaryNumber_buffer<<1;
						if(state<BitWidth) begin		
							for (j=1;j<=BCDDigits;j=j+1)
							begin
								if({BCDNumber_buffer[4*j-1],BCDNumber_buffer[4*j-2],BCDNumber_buffer[4*j-3],BCDNumber_buffer[4*j-4]}>4'd4)
								begin
									{BCDNumber_buffer[4*j-1],BCDNumber_buffer[4*j-2],BCDNumber_buffer[4*j-3],BCDNumber_buffer[4*j-4]}={BCDNumber_buffer[4*j-1],BCDNumber_buffer[4*j-2],BCDNumber_buffer[4*j-3],BCDNumber_buffer[4*j-4]}+3;
								end
							end 
							
						end 
						state<=state+1;
					end
					else
					begin
						state<=0;
						BCDNumber<=BCDNumber_buffer;
					end
				end
		 
		 end
endmodule