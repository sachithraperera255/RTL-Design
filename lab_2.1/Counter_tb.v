//time_unit = 1ns and time precision = 1ps
`timescale 1ns/1ps

// testbench has no inputs or outputs
module Counter_tb();

	// declare testbench signals
	reg			clk_tb;
	reg	[3:0]	in_tb;
	reg			latch_tb;
	reg			dec_tb;
	wire		zero_tb;
	wire[3:0]	counter_tb;

	initial
	begin
		$dumpfile ("Counter.vcd"); // waveform files save in this file
		$dumpvars; // save all waveforms during the simulation
		clk_tb = 1'b0;
		latch_tb = 1'b0;
		dec_tb = 1'b0;
		in_tb = 4'b1010;
		


		$display ("TEST CASE 1"); // test latch function
		#10
		latch_tb = 1'b1;
		#10
		if(counter_tb == 4'b1010)
			$display ("TEST CASE 1 passed with counter value = %0h at sumulation time", counter_tb, $time);
		else
			$display ("TEST CASE 1 failed with counter value = %0h at simulation time", counter_tb, $time);
		

		$display("TEST CASE 2"); // test latch priority
		latch_tb = 1'b1;
		dec_tb = 1'b1;
		#10
		if(counter_tb == 4'b1010)
			$display ("TEST CASE 2 passed with counter value = %0h at sumulation time", counter_tb, $time);
		else
			$display ("TEST CASE 2 failed with counter value = %0h at simulation time", counter_tb, $time);

		
		$display("TEST CASE 3"); // test dec function
		latch_tb = 1'b0;
		#30
		if(counter_tb == 4'b1111)
			$display ("TEST CASE 3 passed with counter value = %0h at sumulation time", counter_tb, $time);
		else
			$display ("TEST CASE 3 failed with counter value = %0h at simulation time", counter_tb, $time);

		

		$display("TEST CASE 4"); // test dec function
		latch_tb = 1'b0;
		#80
		if(counter_tb == 4'b0 && zero_tb == 1'b1)
			$display ("TEST CASE 4 passed with counter value = %0h at sumulation time", counter_tb, $time);
		else
			$display ("TEST CASE 4 failed with counter value = %0h at simulation time", counter_tb, $time);
			#100
			$stop; // Finished with simulation

	end

		
		// Clock generator
		always #5 clk_tb = ~clk_tb;

		// Design instantiation
		Counter DUT (
			.clk(clk_tb),
			.in(in_tb),
			.latch(latch_tb),
			.dec(dec_tb),
			.zero(zero_tb),
			.counter(counter_tb)
		);

endmodule
