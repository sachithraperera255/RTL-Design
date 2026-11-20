module parity_check_tb();

	reg	[7:0]	rx_out_tb;
	reg			parity_type_tb;
	reg			parity_check_en_tb;
	reg			sample_bit_tb;
	reg			clk_tb;
	reg			rst_tb;

	wire		parity_error_tb;

	reg			expected_parity_err;


    integer   test_count;
    integer   fail_count;

	task initialize;
	begin
		rx_out_tb			= 8'd0;
		parity_type_tb		= 1'b0;
		parity_check_en_tb	= 1'b0;
		sample_bit_tb		= 1'b0;
		clk_tb				= 1'b1;
		rst_tb				= 1'b1;
		test_count			= 1'b0;
		fail_count			= 1'b0;
	end
	endtask

	task reset;
	begin
		@(negedge clk_tb);
		rst_tb	= 1'b0; // reset is applied

		expected_parity_err = 1'b0;

		repeat(2) @(negedge clk_tb);
		rst_tb = 1'b1; // reset is released
	end
	endtask

	task expected_bit_check;
	begin
		expected_parity_err = ((^rx_out_tb)^parity_type_tb)^sample_bit_tb;
	end
	endtask

	task bit_checker;
		input [7:0] input_byte;
		input		pari_type;
		input		pari_check_en;
		input		sample_bit;

	begin

		@(negedge clk_tb);
		rx_out_tb 			= input_byte;
		parity_type_tb 		= pari_type;
		parity_check_en_tb 	= pari_check_en;
		sample_bit_tb 		= sample_bit;

		if (parity_check_en_tb)
		begin
			expected_bit_check();
		end
		else
		begin
			$display("parity_check_en is LOW");
		end

		@(posedge clk_tb);
		#1

	    test_count = test_count + 1;
		if (parity_error_tb === expected_parity_err)
		begin
			$display("Test Passed");
		end
		else
		begin
			fail_count = fail_count + 1;
			$display("Test Failed");
		end


	end
	endtask

	initial
	begin

		$dumpfile("parity_check.vcd");
		$dumpvars;

		initialize();

		reset();

		//bit_checker(rx_out_tb, parity_type_tb, parity_check_en_tb, sample_bit_tb);

		// TEST 01: Even parity, invalid parity bit
        bit_checker(8'b10110000, 1'b0, 1'b1, 1'b0);

        // TEST 02: Hold previous error
        bit_checker(8'b10110000, 1'b0, 1'b0, 1'b1);

        // TEST 03: Even parity, valid parity bit
        bit_checker(8'b10110000, 1'b0, 1'b1, 1'b1);

        // TEST 04: Odd parity, valid parity bit
        bit_checker(8'b10110000, 1'b1, 1'b1, 1'b0);

        // TEST 05: Odd parity, invalid parity bit
        bit_checker(8'b10110000, 1'b1, 1'b1, 1'b1);

        // TEST 06: Reset after an error
        reset();

        // TEST 07: Four ones, even parity, valid
        bit_checker(8'b11001100, 1'b0, 1'b1, 1'b0);

        // TEST 08: Four ones, even parity, invalid
        bit_checker(8'b11001100, 1'b0, 1'b1, 1'b1);

        // TEST 09: All zeros, odd parity, valid
        bit_checker(8'b00000000, 1'b1, 1'b1, 1'b1);


        $display("\n==========================");
        $display("PARITY CHECK TEST RESULTS");
        $display("==========================");

        $display("Total Tests : %0d", test_count);
        $display("Passed Tests: %0d", test_count - fail_count);
        $display("Failed Tests: %0d", fail_count);

        if(fail_count == 0)
            $display("ALL TESTS PASSED");
        else
            $fatal(1, "Parity check tests failed");

        $finish;

	end

	always #2.5 clk_tb = ~clk_tb;

	parity_check DUT
		(
			.parity_type(parity_type_tb),
			.parity_check_en(parity_check_en_tb),
			.sample_bit(sample_bit_tb),
			.rx_out(rx_out_tb),
			.clk(clk_tb),
			.rst(rst_tb),
			.parity_error(parity_error_tb)
		);

endmodule
