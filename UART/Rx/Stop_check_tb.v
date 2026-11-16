`timescale 1ns/1ps

module stop_bit_tb();

	reg		sample_bit_tb;
	reg		stop_check_en_tb;
	reg		clk_tb;
	reg		rst_tb;

	wire	stop_error_tb;



	task reset;
	begin
		@(negedge clk_tb);
		rst_tb = 1'b0;

		repeat(2) @(negedge clk_tb);
		rst_tb = 1'b1;
	end
	endtask

	task initialize;
	begin

		sample_bit_tb 		= 1'b0;
		stop_check_en_tb 	= 1'b0;
		clk_tb				= 1'b1;
		rst_tb				= 1'b1;
	end
	endtask


	initial
	begin

		$dumpfile("Stop_check.vcd");
		$dumpvars;

		initialize();

		reset();

		$display("TEST 01: STOP bit is HIGH");
		@(negedge clk_tb);
		stop_check_en_tb 	= 1'b1;
		sample_bit_tb 		= 1'b1;

		@(posedge clk_tb);
		#1
		if(stop_error_tb === 1'b0)
		begin
			$display("Test passed");
		end
		else
		begin
			$display("Test failed");
		end

		stop_check_en_tb 	= 1'b0;

		$display("TEST 01: STOP bit is LOW");
		@(negedge clk_tb);
		stop_check_en_tb 	= 1'b1;
		sample_bit_tb 		= 1'b0;

		@(posedge clk_tb);
		#1
		if(stop_error_tb === 1'b1)
		begin
			$display("Test passed");
		end
		else
		begin
			$display("Test failed");
		end

		$finish;

	end

	always #2.5 clk_tb = ~clk_tb;

	stop_bit DUT
		(
			.sample_bit			(sample_bit_tb),
			.stop_check_en		(stop_check_en_tb),
			.clk				(clk_tb),
			.rst				(rst_tb),
			.stop_error			(stop_error_tb)
		);

endmodule






