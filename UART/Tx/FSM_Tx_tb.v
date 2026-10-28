`timescale	1ns/1ps

module FSM_Tx_tb();

	reg			data_valid_tb;
	reg			parity_en_tb;
	reg			serial_done_tb;
	reg			clk_tb;
	reg			rst_tb;

	wire		busy_tb;
	wire [1:0]	mux_sel_tb;
	wire		parity_calc_en_tb;
	wire		serial_en_tb;

	integer test_count = 0;
	integer fail_count = 0;	


	task initialize;
	begin
		data_valid_tb	= 1'b0;
		parity_en_tb	= 1'b0;
		serial_done_tb	= 1'b0;
		clk_tb			= 1'b1;
		rst_tb			= 1'b1;
	end
	endtask

	task reset;
	begin
		#5
		rst_tb	= 1'b0; // reset is active

	repeat(2) @(negedge clk_tb);
		#0.1
		rst_tb	= 1'b1; // reset is released
	end
	endtask

	initial
	begin

		$dumpfile("FSM_Tx.vcd");
		$dumpvars;


		initialize();

		reset();

		@(negedge clk_tb)
		data_valid_tb	= 1'b1;
		parity_en_tb	= 1'b1;

		$display("TEST 01: Testing IDLE state");
		#0.1 //  why the waiting time is low, because combinational logic see the inputs the moment they get entered and update the system
			// it's only sequential logic circuits that wait untill the next rising edge.

		test_count = test_count + 1;

		if(busy_tb === 1'b0 && serial_en_tb === 1'b1 && parity_calc_en_tb === 1'b1)
		begin
			$display("Test passed");
		end
		else
		begin
			fail_count = fail_count + 1;
			$display("Test failed");
		end



		$display("TEST 02: Testing START state");
		@(posedge clk_tb)
		#1

		test_count = test_count + 1;

		if(busy_tb === 1'b1 && mux_sel_tb === 2'b01)
		begin
			$display("Test passed");
		end
		else
		begin
			fail_count = fail_count + 1;
			$display("Test failed");
		end

		// set data_valid_tb to LOW because it is a pulse signal
		data_valid_tb = 1'b0;


		$display("TEST 03: Testing DATA state");
		@(posedge clk_tb)
		#1

		test_count = test_count + 1;

		if(busy_tb === 1'b1 && mux_sel_tb === 2'b10)
		begin
			$display("Test passed");
		end
		else
		begin
			fail_count = fail_count + 1;
			$display("Test failed");
		end

		@(negedge clk_tb)
		serial_done_tb	= 1'b1;

		@(posedge clk_tb);
		$display("TEST 04: Testing PARITY state");
		#1

		test_count = test_count + 1;

		if(busy_tb === 1'b1 &&  mux_sel_tb === 2'b11)
		begin
			$display("Test passed");
		end
		else
		begin
			fail_count = fail_count + 1;
			$display("Test failed");
		end


		@(negedge clk_tb)
		serial_done_tb	= 1'b0;

		@(posedge clk_tb)
		$display("TEST 05: Testing STOP state");
		#1

		test_count = test_count + 1;

		if(busy_tb === 1'b1 &&  mux_sel_tb === 2'b00)
		begin
			$display("Test passed");
		end
		else
		begin
			fail_count = fail_count + 1;
			$display("Test failed");
		end


		// TEST 06: Return to IDLE
		@(posedge clk_tb)
		#1

		$display("TEST 06: Testing return to IDLE");

		test_count = test_count + 1;

		if (busy_tb === 1'b0 && mux_sel_tb === 2'b00)
		begin
			$display("Test 06 passed");
		end
		else
		begin
			fail_count = fail_count + 1;
			$display("Test 06 failed");
		end


		#20
        // Final test summary
        $display("\n----------------------------");
        $display("Total checks : %0d", test_count);
        $display("Passed       : %0d", test_count - fail_count);
        $display("Failed       : %0d", fail_count);
        $display("----------------------------");

        if(fail_count > 0)
        begin
            $fatal(1, "FSM_Tx TESTBENCH FAILED");
        end
        else
        begin
            $display("FSM_Tx TESTS PASSED");
            $finish;
        end

	end

	always #2.5 clk_tb = ~clk_tb;

	FSM_Tx DUT
	(
		.data_valid(data_valid_tb),
		.parity_en(parity_en_tb),
		.serial_done(serial_done_tb),
		.clk(clk_tb),
		.rst(rst_tb),
		.busy(busy_tb),
		.mux_sel(mux_sel_tb),
		.parity_calc_en(parity_calc_en_tb),
		.serial_en(serial_en_tb)
	);

endmodule
