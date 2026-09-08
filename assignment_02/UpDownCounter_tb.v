`timescale 1ns/1ps

module UpDownCounter ();
	
	// Declare testnech signals
	reg [4:0]	in_tb;
	reg			load_tb;
	reg			up_tb;
	reg			down_tb;
	reg			clk_tb;
	
	wire		high_tb;
	wire		low_tb;
	wire [4:0]	counter_tb;

	
	initial
	begin
		$dumpfile("UpDownCount.vcd");	// waveform file
		$dumpvars;	// save all waveforms during the simulation
		
		// Initial signal values
		in_tb 		= 5'b00000;
		load_tb 	= 1'b0;
		up_tb 		= 1'b0;
		down_tb 	= 1'b0;
		clk_tb 		= 1'b0;



		#10
		$display ("TEST CASE 1: LOAD FUNCTION TEST");
		
		// load values
		in_tb 		= 5'b01010;
		load_tb 	= 1'b1;
		up_tb		= 1'b0;
		down_tb		= 1'b0;
		#10

		if(counter_tb == 5'b01010)
			$display("TEST 1: Load function test pass");
		else
			$display("TEST 1: Load function test failed");

		

		#10
		$display ("TEST CASE 2: LOAD PRIORITY TEST");
		
		// load values
		in_tb 		= 5'b01010;
		load_tb 	= 1'b1;
		up_tb		= 1'b1;
		down_tb		= 1'b1;
		#10

		if(counter_tb == 5'b01010)
			$display("TEST 2: Load priority test pass");
		else
			$display("TEST 1: Load priority test failed");



		#10
		$display ("TEST CASE 3: INCREMENT FUNCTION TEST");
		
		// load values
		in_tb 		= 5'b01010;
		load_tb 	= 1'b1;
		up_tb		= 1'b0;
		down_tb		= 1'b0;

		// increment constraint
		#10
		load_tb 	= 1'b0;
		up_tb		= 1'b1;
		down_tb		= 1'b0;
		
		#10
		if(counter_tb == 5'b01011)
			$display("TEST 3: Increment function test pass");
		else
			$display("TEST 3: Increment function test failed");



		#10
		$display ("TEST CASE 4: DECREMENT FUNCTION TEST");
		
		// load values
		in_tb 		= 5'b01010;
		load_tb 	= 1'b1;
		up_tb		= 1'b0;
		down_tb		= 1'b0;

		// decrement constraint
		#10
		load_tb 	= 1'b0;
		up_tb		= 1'b0;
		down_tb		= 1'b1;
		
		#10
		if(counter_tb == 5'b01001)
			$display("TEST 4: Decrement function test pass");
		else
			$display("TEST 4: Decrement function test failed");




		#10
		$display ("TEST CASE 5: DECREMENT PRIORITY TEST");
		
		// load values
		in_tb 		= 5'b01010;
		load_tb 	= 1'b1;
		up_tb		= 1'b0;
		down_tb		= 1'b0;

		// decrement constraint
		#10
		load_tb 	= 1'b0;
		up_tb		= 1'b1;
		down_tb		= 1'b1;
		
		#10
		if(counter_tb == 5'b01001)
			$display("TEST 4: Decrement priority test pass");
		else
			$display("TEST 4: Decrement priority test failed");


		
		#10
		$display("TEST CASE 6: UPPER LIMIT");

		// load values
		in_tb		= 5'b11111;
		load_tb		= 1'b1;
		up_tb		= 1'b0;
		down_tb		= 1'b0;

		// try to add above the upper limit
		#10
		load_tb		= 1'b0;
		up_tb		= 1'b1;
		down_tb		= 1'b0;

		#10
		if(counter_tb == 5'b11111)
			$display("TEST 6: Upper limit test pass");
		else
			$display("TEST 6: Upper limit test failed");



		#10
		$display("TEST CASE 7: LOWER LIMIT");

		// load values
		in_tb		= 5'b00000;
		load_tb		= 1'b1;
		up_tb		= 1'b0;
		down_tb		= 1'b0;

		// try to add above the upper limit
		#10
		load_tb		= 1'b0;
		up_tb		= 1'b0;
		down_tb		= 1'b1;

		#10
		if(counter_tb == 5'b00000)
			$display("TEST 7: Lower limit test pass");
		else
			$display("TEST 7: Lower limit test failed");

	end
	

	// clock generator
	always #5 clk_tb = ~clk_tb;
	
	// design instantiation
	UpDownCounter DUT (
		.in_tb(in),
		.load_tb(load),
		.up_tb(up),
		.down_tb(down),
		.clk_tb(clk),
		.high_tb(high),
		.low_tb(low),
		.counter_tb(counter)
	);
	
endmodule



		
		