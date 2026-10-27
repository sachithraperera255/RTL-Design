`timescale 1ns/1ps

module ParityCalc_tb();

	reg	[7:0]	data_tb;
	reg			parity_calc_en_tb;
	reg			parity_type_tb;
	reg			clk_tb;
	reg			rst_tb;

	wire		parity_bit_tb;


	task initialize;
	begin
		data_tb 			= 8'd0;
		parity_calc_en_tb 	= 1'b0;
		parity_type_tb		= 1'b0;
		clk_tb				= 1'b1;
		rst_tb				= 1'b1;
	end
	endtask

	task reset;
	begin
		#5
		rst_tb	= 1'b0; // reset is active
		#5
		rst_tb	= 1'b1; // reset is released
	end
	endtask

	initial
	begin
		$dumpfile("ParitiCalc.vcd");
		$dumpvars;

		initialize();

		reset();

		@(negedge clk_tb)
		data_tb				= 8'b01100100;
		parity_calc_en_tb 	= 1'b1;
		parity_type_tb		= 1'b1;

		$display("Test 01: Odd count and odd parity: 1 ^ 1");
		@(posedge clk_tb)
		#1
		if (parity_bit_tb == 0)
		begin
			$display("Test 01 passed: %b", parity_bit_tb);
		end
		else
		begin
			$display("Test 01 failed: %b", parity_bit_tb);
		end


		@(negedge clk_tb)
		data_tb				= 8'b01100100; //in decimal = 100
		parity_calc_en_tb 	= 1'b1;
		parity_type_tb		= 1'b0;

		$display("Test 02: Odd count and even parity: 1 ^ 0");
		@(posedge clk_tb)
		#1
		if (parity_bit_tb == 1)
		begin
			$display("Test 02 passed: %b", parity_bit_tb);
		end
		else
		begin
			$display("Test 02 failed: %b", parity_bit_tb);
		end


		@(negedge clk_tb)
		data_tb				= 8'b01100101; //in decimal = 101
		parity_calc_en_tb 	= 1'b1;
		parity_type_tb		= 1'b1;

		$display("Test 03: Even count and odd parity: 0 ^ 1");
		@(posedge clk_tb)
		#1
		if (parity_bit_tb == 1)
		begin
			$display("Test 03 passed: %b", parity_bit_tb);
		end
		else
		begin
			$display("Test 03 failed: %b", parity_bit_tb);
		end


		@(negedge clk_tb)
		data_tb				= 8'b01100101; //in decimal = 101
		parity_calc_en_tb 	= 1'b1;
		parity_type_tb		= 1'b0;

		$display("Test 04: Even count and even parity: 0 ^ 0");
		@(posedge clk_tb)
		#1
		if (parity_bit_tb == 0)
		begin
			$display("Test 04 passed: %b", parity_bit_tb);
		end
		else
		begin
			$display("Test 04 failed: %b", parity_bit_tb);
		end
		
		@(negedge clk_tb)
		data_tb				= 8'b00000000; //in decimal = 0
		parity_calc_en_tb 	= 1'b0;
		parity_type_tb		= 1'b1;

		$display("Test 05: Test the hold behavior when the parity_calc_en_tb signal is LOW");
		@(posedge clk_tb)
		#1
		if (parity_bit_tb == 0)
		begin
			$display("Test 05 passed: The circuit hold the previos value %b", parity_bit_tb);
		end
		else
		begin
			$display("Test 05   failed: The circuit did not hold the previous value %b", parity_bit_tb);
		end
		
		
		#10
		$stop;
	end


	always #2.5 clk_tb = ~clk_tb;


	ParityCalc	DUT
	(
		.data(data_tb),
		.parity_calc_en(parity_calc_en_tb),
		.clk(clk_tb),
		.rst(rst_tb),
		.parity_type(parity_type_tb),
		.parity_bit(parity_bit_tb)
	);


endmodule