`timescale 1ns/1ps

module Divider_tb();
	reg			clk_tb;
	reg			rst_tb;
	reg			clk_en_tb;
	reg [7:0]	div_ratio_tb;
	
	wire		div_clk_tb;

	
	task initialize;
	begin
		clk_en_tb		= 1'b0;
		div_ratio_tb 	= 8'd0;
		clk_tb			= 1'b1;
		rst_tb			= 1'b1;
	end
	endtask


	task reset;
	begin
		#10
		rst_tb	= 1'b0; // reset activate
		#10
		rst_tb	= 1'b1; // release the reset
	end
	endtask

	initial
	begin
		
		$dumpfile("ClockDivider.vcd");
		$dumpvars;
		
		// Initialize the input signals
		initialize();

		// reset the circuit
		reset();
		
		@(negedge clk_tb) // This is used to prevent the simulation race, give 1/2 cycle advantage to be stable.
		clk_en_tb	 = 1'b1;
		div_ratio_tb = 8'd6;


		repeat(10)@(negedge clk_tb);
		$stop;

	end

	always #10 clk_tb = ~clk_tb;

	Divider DUT
	(
		.clk(clk_tb),
		.rst(rst_tb),
		.clk_en(clk_en_tb),
		.div_ratio(div_ratio_tb),
		.div_clk(div_clk_tb)
	);

endmodule


