
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module PFC_FB_ON_OFF_Tester(

	//////////// CLOCK //////////
	input 		          		ADC_CLK_10,
	input 		          		MAX10_CLK1_50,
	input 		          		MAX10_CLK2_50,

	//////////// SDRAM //////////
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		          		DRAM_LDQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_UDQM,
	output		          		DRAM_WE_N,

	//////////// SEG7 //////////
	output		     [7:0]		HEX0,
	output		     [7:0]		HEX1,
	output		     [7:0]		HEX2,
	output		     [7:0]		HEX3,
	output		     [7:0]		HEX4,
	output		     [7:0]		HEX5,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// VGA //////////
	output		     [3:0]		VGA_B,
	output		     [3:0]		VGA_G,
	output		          		VGA_HS,
	output		     [3:0]		VGA_R,
	output		          		VGA_VS,

	//////////// Accelerometer //////////
	output		          		GSENSOR_CS_N,
	input 		     [2:1]		GSENSOR_INT,
	output		          		GSENSOR_SCLK,
	inout 		          		GSENSOR_SDI,
	inout 		          		GSENSOR_SDO,

	//////////// Arduino //////////
	inout 		    [15:0]		ARDUINO_IO,
	inout 		          		ARDUINO_RESET_N,

	//////////// GPIO, GPIO connect to GPIO Default //////////
	inout 		    [35:0]		GPIO
);



//=======================================================
//  REG/WIRE declarations
//=======================================================
wire divided_clock;
parameter ON=30;
parameter OFF=32;
parameter WAIT=5;
reg [9:0] count;
reg drive,GPIO0;

reg [8:0] Total_ON_OFF;

parameter BitWidth = 17;   					// Defines the bitwidth of the binary number to be converted to BCD.
parameter BCDDigits = 6;						// Defines the number of BCD digits required for the BCD representation.
wire [BCDDigits*4-1:0] BCD_number;

//==================================================================================
//
// Initialization of modules used in this module. 
//
//==================================================================================		
		
		
		BinaryToBCDConverter #(BitWidth,BCDDigits) binary_to_BCD( 	.Clk(MAX10_CLK1_50),
																						.BinaryNumber({8'b00000000,Total_ON_OFF}),
																						.BCDNumber(BCD_number),
																						.reset(1'b0));

		SevenSegment SSdriver_ones(.Value(BCD_number[3:0]),
											.seven_segment(HEX0));
		
		SevenSegment SSdriver_tens(.Value(BCD_number[7:4]),
											.seven_segment(HEX1));
		
		SevenSegment SSdriver_hundreds(.Value(BCD_number[11:8]),
													.seven_segment(HEX2));
		
		SevenSegment SSdriver_thousands(.Value(BCD_number[15:12]),
													.seven_segment(HEX3));
		
		SevenSegment SSdriver_tenthousands(.Value(BCD_number[19:16]),
														.seven_segment(HEX4));
		
		SevenSegment SSdriver_hundredthousands(.Value(BCD_number[23:20]),
																.seven_segment(HEX5));
																						
//==================================================================================
// This state machine converts binary numbers 	Desired_Voltage, Current_Limit and 	Vout_ADC_Reading
//==================================================================================


//=======================================================
//  Structural coding
//=======================================================

ClockDivider #(50000000) clock_divider(	.Clock_in(MAX10_CLK1_50),
																.reset(1'b0),
																.Clock_out(divided_clock));
always @(posedge divided_clock)
begin
	GPIO0<=GPIO[0];
   if(count<=ON+OFF+WAIT-1)
	begin
		Total_ON_OFF<=Total_ON_OFF;
		if(count<=ON-1)
		begin
			drive<=1'b1;
			if(GPIO[0])
			begin
				count<=ON;
			end
			else
			begin
				count<=count+1;
			end
		end
		else
		begin
			if(count<=ON+WAIT-1)
			begin
				drive<=1'b1;
				if(GPIO[0])
				begin
					count<=ON+WAIT;
				end
				else
				begin
					count<=count;
				end
			end
			else
			begin
				drive<=1'b0;
				count<=count+1;
			end
		end
	end
	else
	begin
		count<=0;
		Total_ON_OFF<=Total_ON_OFF+1;
	end
end

assign LEDR[0]=divided_clock;
assign LEDR[1]=GPIO0;
assign LEDR[2]=count[0];																
																
assign LEDR[9:3]={7{drive}};
assign ARDUINO_IO={16{drive}};
assign GPIO[35:1]={35{drive}};


endmodule
