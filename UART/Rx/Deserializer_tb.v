`timescale 1ns/1ps

module deserializer_tb();

	reg			sample_bit_tb;
	reg			deserial_en_tb;
	reg			clk_tb;
	reg			rst_tb;

	wire [7:0]	rx_out_tb;

	integer		test_count;
	integer		fail_count;

	reg [7:0]	received_byte;
	reg [7:0]	expected_data;

	task reset;
	begin
		@(negedge clk_tb);
		rst_tb = 1'b0;

		expected_data = 8'd0;

		repeat(2) @(negedge clk_tb);
		rst_tb = 1'b1;
	end
	endtask

	
	task initialize;
	begin
		sample_bit_tb 	= 1'b0;
		deserial_en_tb	= 1'b0;
		clk_tb			= 1'b1;
		rst_tb			= 1'b1;
		expected_data 	= 8'd0;
		test_count		= 1'b0;
		fail_count		= 1'b0;
	end
	endtask

	task byte_test;
		input [7:0]	data_byte;
		integer 	i;
	begin

		received_byte = data_byte;

		$display("\nTesting byte: %b", received_byte);		

		for(i = 0; i < 8; i = i + 1)
		begin

			@(negedge clk_tb);

			sample_bit_tb  = received_byte[i];
			deserial_en_tb = 1'b1;

			expected_data = {sample_bit_tb,expected_data[7:1]};

			@(posedge clk_tb);
			#1
			test_count = test_count + 1;
			if(rx_out_tb === expected_data)
			begin
				$display("Test passed");
			end
			else
			begin
				fail_count = fail_count + 1;
				$display("Test failed");
			end
			
			
		end

		@(negedge clk_tb);
		deserial_en_tb = 1'b0;


		@(posedge clk_tb);
		#1
		test_count = test_count + 1;
		$display("\nTesting final byte: %b", received_byte);	
		if(rx_out_tb === expected_data)
		begin
			$display("Test Passed");
		end
		else
		begin
			fail_count = fail_count + 1;
			$display("Test failed");
		end

	end
	endtask

	initial
	begin

		$dumpfile("Deserializer.vcd");
		$dumpvars;

		initialize();
	
		reset();

		byte_test(8'b00111000);


		byte_test(8'b10100101);


		byte_test(8'b00000000);


		byte_test(8'b11111111);


		byte_test(8'b10000001);

		$display("\n==========================");
		$display("Test Results");
		$display("\n==========================");

		$display("Total Tests : %0d", test_count);
		$display("Passed Tests: %0d", test_count - fail_count);
		$display("Failed Tests: %0d", fail_count);

		if(fail_count == 0)
		begin
			$display("ALL TEST PASSED");
		end
		else
		begin
			$fatal(1,"Deserializer tests failed");
		end

		$finish;
	
	end

    always #2.5 clk_tb = ~clk_tb;

	deserializer DUT
		(
			.sample_bit(sample_bit_tb),
			.deserial_en(deserial_en_tb),
			.clk(clk_tb),
			.rst(rst_tb),
			.rx_out(rx_out_tb)
		);

endmodule
