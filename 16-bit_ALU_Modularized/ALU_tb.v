`timescale 1us/1us

module TOP_ALU_tb ();
	// Input and output data width
	parameter INPUT_WIDTH				= 	16,
			  ARITH_OUT_WIDTH			= 	32;
	
	// Required frequency is 100 kHz, therefore period of the clock = 10 us.
	// clock parameters
	parameter CLOCK			= 10,
			  CLOCK_HIGH	= CLOCK * 0.6,
			  CLOCK_LOW		= CLOCK * 0.4;

	// Top_ALU input signals
	reg	signed 	[INPUT_WIDTH-1:0]			A_tb;
	reg signed 	[INPUT_WIDTH-1:0]			B_tb;
	reg		  	[3:0]						ALU_FUN_tb;
	reg										CLK_tb;
	reg										RST_tb;
	//Arithmetic_unit signals
	wire signed [ARITH_OUT_WIDTH-1:0]		ARITH_OUT_tb;
	wire 									ARITH_FLAG_tb;
	//Logic_unit signals
	wire		[INPUT_WIDTH-1:0]			LOGIC_OUT_tb;
	wire									LOGIC_FLAG_tb;
	//CMP_unit signals
	wire		[INPUT_WIDTH-1:0]			CMP_OUT_tb;
	wire									CMP_FLAG_tb;
	//Shift_unit signals
	wire		[INPUT_WIDTH-1:0]			SHIFT_OUT_tb;
	wire									SHIFT_FLAG_tb;

	
	initial
	begin
		
		$dumpfile("ALU.vcd"); // Save waveform data here
		$dumpvars; // save waveform data during the simulation
		
		// Initial values
		A_tb 		= 'b0;
		B_tb 		= 'b0;
		ALU_FUN_tb 	= 4'b0000;
		CLK_tb		= 1'b0;
		RST_tb		= 1'b0;	// Reset is active
		
		// this delay of 10 us hold the reset before it releases
		#CLOCK	
		RST_tb		= 1'b1;	// Reset is deactivated
		
		$display ("TEST 01 --- Addition: (+) + (+) ---");
		
		A_tb			= 16'sd10;
		B_tb			= 16'sd20;
		ALU_FUN_tb		= 4'b0000;
		
		@(posedge CLK_tb);
		#1
		
		if(ARITH_OUT_tb == 32'sd30 && ARITH_FLAG_tb == 1'b1)
			$display ("TEST PASSED: %0d + %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);
		else
			$display ("TEST FAILED: %0d + %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);



		$display ("TEST 02 --- Addition: (+) + (-) ---");
		
		A_tb			= 16'sd10;
		B_tb			= -16'sd4;
		ALU_FUN_tb		= 4'b0000;
		
		@(posedge CLK_tb);
		#1
		
		if(ARITH_OUT_tb == 32'sd6 && ARITH_FLAG_tb == 1'b1)
			$display ("TEST PASSED: %0d + %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);
		else
			$display ("TEST FAILED: %0d + %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);



		$display ("TEST 03 --- Addition: (-) + (+) ---");
		
		A_tb			= -16'sd20;
		B_tb			= 16'sd10;
		ALU_FUN_tb		= 4'b0000;
		
		@(posedge CLK_tb);
		#1
		
		if(ARITH_OUT_tb == -32'sd10 && ARITH_FLAG_tb == 1'b1)
			$display ("TEST PASSED: %0d + %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);
		else
			$display ("TEST FAILED: %0d + %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);



		$display ("TEST 04 --- Addition: (-) + (-) ---");
		
		A_tb			= -16'sd10;
		B_tb			= -16'sd10;
		ALU_FUN_tb		= 4'b0000;
		
		@(posedge CLK_tb);
		#1
		
		if(ARITH_OUT_tb == -32'sd20 && ARITH_FLAG_tb == 1'b1)
			$display ("TEST PASSED: %0d + %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);
		else
			$display ("TEST FAILED: %0d + %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);



		$display ("TEST 05 --- Subtraction: (+) - (+) ---");
		
		A_tb			= 16'sd10;
		B_tb			= 16'sd4;
		ALU_FUN_tb		= 4'b0001;
		
		@(posedge CLK_tb);
		#1
		
		if(ARITH_OUT_tb == 32'sd6 && ARITH_FLAG_tb == 1'b1)
			$display ("TEST PASSED: %0d - %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);
		else
			$display ("TEST FAILED: %0d - %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);



		$display ("TEST 06 --- Subtraction: (+) - (-) ---");
		
		A_tb			= 16'sd10;
		B_tb			= -16'sd4;
		ALU_FUN_tb		= 4'b0001;
		
		@(posedge CLK_tb);
		#1
		
		if(ARITH_OUT_tb == 32'sd14 && ARITH_FLAG_tb == 1'b1)
			$display ("TEST PASSED: %0d - %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);
		else
			$display ("TEST FAILED: %0d - %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);


		$display ("TEST 07 --- Subtraction: (-) - (+) ---");
		
		A_tb			= -16'sd10;
		B_tb			= 16'sd10;
		ALU_FUN_tb		= 4'b0001;
		
		@(posedge CLK_tb);
		#1
		
		if(ARITH_OUT_tb == -32'sd20 && ARITH_FLAG_tb == 1'b1)
			$display ("TEST PASSED: %0d - %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);
		else
			$display ("TEST FAILED: %0d - %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);


		$display ("TEST 08 --- Subtraction: (-) - (-) ---");
		
		A_tb			= -16'sd10;
		B_tb			= -16'sd5;
		ALU_FUN_tb		= 4'b0001;
		
		@(posedge CLK_tb);
		#1
		
		if(ARITH_OUT_tb == -32'sd5 && ARITH_FLAG_tb == 1'b1)
			$display ("TEST PASSED: %0d - %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);
		else
			$display ("TEST FAILED: %0d - %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);


		$display ("TEST 09 --- Multiplication: (+) * (+) ---");
		
		A_tb			= 16'sd2;
		B_tb			= 16'sd2;
		ALU_FUN_tb		= 4'b0010;
		
		@(posedge CLK_tb);
		#1
		
		if(ARITH_OUT_tb == 32'sd4 && ARITH_FLAG_tb == 1'b1)
			$display ("TEST PASSED: %0d * %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);
		else
			$display ("TEST FAILED: %0d * %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);


		$display ("TEST 10 --- Multiplication: (+) * (-) ---");
		
		A_tb			= 16'sd5;
		B_tb			= -16'sd2;
		ALU_FUN_tb		= 4'b0010;
		
		@(posedge CLK_tb);
		#1
		
		if(ARITH_OUT_tb == -32'sd10 && ARITH_FLAG_tb == 1'b1)
			$display ("TEST PASSED: %0d * %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);
		else
			$display ("TEST FAILED: %0d * %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);


		$display ("TEST 11 --- Multiplication: (-) * (+) ---");
		
		A_tb			= -16'sd2;
		B_tb			= 16'sd3;
		ALU_FUN_tb		= 4'b0010;
		
		@(posedge CLK_tb);
		#1
		
		if(ARITH_OUT_tb == -32'sd6 && ARITH_FLAG_tb == 1'b1)
			$display ("TEST PASSED: %0d * %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);
		else
			$display ("TEST FAILED: %0d * %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);


		$display ("TEST 12 --- Multiplication: (-) * (-) ---");
		
		A_tb			= -16'sd5;
		B_tb			= -16'sd5;
		ALU_FUN_tb		= 4'b0010;
		
		@(posedge CLK_tb);
		#1
		
		if(ARITH_OUT_tb == 32'sd25 && ARITH_FLAG_tb == 1'b1)
			$display ("TEST PASSED: %0d * %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);
		else
			$display ("TEST FAILED: %0d * %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);


		$display ("TEST 13 --- Division: (+) / (+) ---");
		
		A_tb			= 16'sd8;
		B_tb			= 16'sd2;
		ALU_FUN_tb		= 4'b0011;
		
		@(posedge CLK_tb);
		#1
		
		if(ARITH_OUT_tb == 32'sd4 && ARITH_FLAG_tb == 1'b1)
			$display ("TEST PASSED: %0d / %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);
		else
			$display ("TEST FAILED: %0d / %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);


		$display ("TEST 14 --- Division: (+) / (-) ---");
		
		A_tb			= 16'sd10;
		B_tb			= -16'sd2;
		ALU_FUN_tb		= 4'b0011;
		
		@(posedge CLK_tb);
		#1
		
		if(ARITH_OUT_tb == -32'sd5 && ARITH_FLAG_tb == 1'b1)
			$display ("TEST PASSED: %0d / %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);
		else
			$display ("TEST FAILED: %0d / %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);


		$display ("TEST 15 --- Division: (-) / (+) ---");
		
		A_tb			= -16'sd20;
		B_tb			= 16'sd10;
		ALU_FUN_tb		= 4'b0011;
		
		@(posedge CLK_tb);
		#1
		
		if(ARITH_OUT_tb == -32'sd2 && ARITH_FLAG_tb == 1'b1)
			$display ("TEST PASSED: %0d / %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);
		else
			$display ("TEST FAILED: %0d / %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);


		$display ("TEST 16 --- Division: (-) / (-) ---");
		
		A_tb			= -16'sd4;
		B_tb			= -16'sd2;
		ALU_FUN_tb		= 4'b0011;
		
		@(posedge CLK_tb);
		#1
		
		if(ARITH_OUT_tb == 32'sd2 && ARITH_FLAG_tb == 1'b1)
			$display ("TEST PASSED: %0d / %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);
		else
			$display ("TEST FAILED: %0d / %0d = %0d\n", A_tb, B_tb, ARITH_OUT_tb);


		$display ("TEST 17 --- A AND B ---");
		
		A_tb			= 16'h00F3;
		B_tb			= 16'h0F0F;
		ALU_FUN_tb		= 4'b0100;
		
		@(posedge CLK_tb);
		#1
		
		if(LOGIC_OUT_tb == 16'h0003 && LOGIC_FLAG_tb == 1'b1)
			$display ("TEST PASSED: %0h AND %0h = %0h\n", A_tb, B_tb, LOGIC_OUT_tb);
		else
			$display ("TEST FAILED: %0h AND %0h = %0h\n", A_tb, B_tb, LOGIC_OUT_tb);


		$display ("TEST 18 --- A OR B ---");
		
		A_tb			= 16'h00F3;
		B_tb			= 16'h0F0F;
		ALU_FUN_tb		= 4'b0101;
		
		@(posedge CLK_tb);
		#1
		
		if(LOGIC_OUT_tb == 16'h0FFF && LOGIC_FLAG_tb == 1'b1)
			$display ("TEST PASSED: %0h OR %0h = %0h\n", A_tb, B_tb, LOGIC_OUT_tb);
		else
			$display ("TEST FAILED: %0h OR %0h = %0h\n", A_tb, B_tb, LOGIC_OUT_tb);


		$display ("TEST 19 --- A NAND B ---");
		
		A_tb			= 16'h00F3;
		B_tb			= 16'h0F0F;
		ALU_FUN_tb		= 4'b0110;
		
		@(posedge CLK_tb);
		#1
		
		if(LOGIC_OUT_tb == 16'hFFFC && LOGIC_FLAG_tb == 1'b1)
			$display ("TEST PASSED: %0h NAND %0h = %0h\n", A_tb, B_tb, LOGIC_OUT_tb);
		else
			$display ("TEST FAILED: %0h NAND %0h = %0h\n", A_tb, B_tb, LOGIC_OUT_tb);


		$display ("TEST 20 --- A NOR B ---");
		
		A_tb			= 16'h00F3;
		B_tb			= 16'h0F0F;
		ALU_FUN_tb		= 4'b0111;
		
		@(posedge CLK_tb);
		#1
		
		if(LOGIC_OUT_tb == 16'hF000 && LOGIC_FLAG_tb == 1'b1)
			$display ("TEST PASSED: %0h NOR %0h = %0h\n", A_tb, B_tb, LOGIC_OUT_tb);
		else
			$display ("TEST FAILED: %0h NOR %0h = %0h\n", A_tb, B_tb, LOGIC_OUT_tb);


		$display ("TEST 21 --- NOP ---");
		
		//A_tb			= 16'h00F3;
		//B_tb			= 16'h0F0F;
		ALU_FUN_tb		= 4'b1000;
		
		@(posedge CLK_tb);
		#1
		
		if(CMP_OUT_tb == 16'd0 && CMP_FLAG_tb == 1'b1)
			$display ("TEST PASSED: NOP\n");
		else
			$display ("TEST FAILED: NOP\n");


		$display ("TEST 22 --- Equal ---");
		
		A_tb			= 16'd10;
		B_tb			= 16'd10;
		ALU_FUN_tb		= 4'b1001;
		
		@(posedge CLK_tb);
		#1
		
		if(CMP_OUT_tb == 16'd1 && CMP_FLAG_tb == 1'b1)
			$display ("TEST PASSED: A = %0d Equal B = %0d: %0b\n", A_tb, B_tb, CMP_OUT_tb);
		else
			$display ("TEST FAILED: A = %0d  B = %0d: %0b\n", A_tb, B_tb, CMP_OUT_tb);


		$display ("TEST 23 --- Greater than ---");
		
		A_tb			= 16'd10;
		B_tb			= 16'd8;
		ALU_FUN_tb		= 4'b1010;
		
		@(posedge CLK_tb);
		#1
		
		if(CMP_OUT_tb == 16'd2 && CMP_FLAG_tb == 1'b1)
			$display ("TEST PASSED: A = %0d Greater than B = %0d: %0b\n", A_tb, B_tb, CMP_OUT_tb);
		else
			$display ("TEST FAILED: A = %0d  B = %0d: %0b\n", A_tb, B_tb, CMP_OUT_tb);


		$display ("TEST 24 --- Less than ---");
		
		A_tb			= 16'd5;
		B_tb			= 16'd10;
		ALU_FUN_tb		= 4'b1011;
		
		@(posedge CLK_tb);
		#1
		
		if(CMP_OUT_tb == 16'd3 && CMP_FLAG_tb == 1'b1)
			$display ("TEST PASSED: A = %0d Less than B = %0d: %0b\n", A_tb, B_tb, CMP_OUT_tb);
		else
			$display ("TEST FAILED: A = %0d  B = %0d: %0b\n", A_tb, B_tb, CMP_OUT_tb);


		$display ("TEST 25 --- Input A Right Shift by 1 ---");
		
		A_tb			= 16'b0110;
		ALU_FUN_tb		= 4'b1100;
		
		@(posedge CLK_tb);
		#1
		
		if(SHIFT_OUT_tb == 16'b0011 && SHIFT_FLAG_tb == 1'b1)
			$display ("TEST PASSED: A = %0d right shifted by 1 %0b\n", A_tb, SHIFT_OUT_tb);
		else
			$display ("TEST FAILED: A = %0d right shifted by 1 %0b\n", A_tb, SHIFT_OUT_tb);


		$display ("TEST 26 --- Input A Left Shift by 1 ---");
		
		A_tb			= 16'b0011;
		ALU_FUN_tb		= 4'b1101;
		
		@(posedge CLK_tb);
		#1
		
		if(SHIFT_OUT_tb == 16'b0110 && SHIFT_FLAG_tb == 1'b1)
			$display ("TEST PASSED: A = %0d left shifted by 1 %0b\n", A_tb, SHIFT_OUT_tb);
		else
			$display ("TEST FAILED: A = %0d left shifted by 1 %0b\n", A_tb, SHIFT_OUT_tb);


		$display ("TEST 27 --- Input b Right Shift by 1 ---");
		
		B_tb			= 16'b1100;
		ALU_FUN_tb		= 4'b1110;
		
		@(posedge CLK_tb);
		#1
		
		if(SHIFT_OUT_tb == 16'b0110 && SHIFT_FLAG_tb == 1'b1)
			$display ("TEST PASSED: B = %0d right shifted by 1 %0b\n", B_tb, SHIFT_OUT_tb);
		else
			$display ("TEST FAILED: B = %0d right shifted by 1 %0b\n", B_tb, SHIFT_OUT_tb);
		

		
		$display ("TEST 28 --- Input B Left Shift by 1 ---");
		
		B_tb			= 16'b0011;
		ALU_FUN_tb		= 4'b1111;
		
		@(posedge CLK_tb);
		#1
		
		if(SHIFT_OUT_tb == 16'b0110 && SHIFT_FLAG_tb == 1'b1)
			$display ("TEST PASSED: B = %0d left shifted by 1 %0b\n", B_tb, SHIFT_OUT_tb);
		else
			$display ("TEST FAILED: B = %0d left shifted by 1 %0b\n", B_tb, SHIFT_OUT_tb);


		//Finish the simulation
		#CLOCK
		$stop;
	end
		always
		begin
			#CLOCK_LOW 	CLK_tb = ~CLK_tb;
			#CLOCK_HIGH CLK_tb = ~CLK_tb;
		end

		TopMod DUT(
			.A(A_tb),
			.B(B_tb),
			.ALU_FUN(ALU_FUN_tb),
			.CLK(CLK_tb),
			.RST(RST_tb),
			.ARITH_OUT(ARITH_OUT_tb),
			.ARITH_FLAG(ARITH_FLAG_tb),
			.LOGIC_OUT(LOGIC_OUT_tb),
			.LOGIC_FLAG(LOGIC_FLAG_tb),
			.CMP_OUT(CMP_OUT_tb),
			.CMP_FLAG(CMP_FLAG_tb),
			.SHIFT_OUT(SHIFT_OUT_tb),
			.SHIFT_FLAG(SHIFT_FLAG_tb)
		);
			

endmodule
