
`timescale 1ns/1ps

module Register_tb ();

	reg		[15:0]	WriteData_tb;
	reg		[2:0]	addr_tb;
	reg				WriteEn_tb;
	reg				clk_tb;
	reg				rst_tb;
	reg				ReadEn_tb;

	wire	[15:0]	ReadData_tb;

	integer errors;
	integer i;

	initial
	begin
		$dumpfile("Register.vcd");
		$dumpvars;

		WriteData_tb	= 16'd0;
		addr_tb			= 3'd0;
		WriteEn_tb		= 1'b0;
		clk_tb			= 1'b0;
		rst_tb			= 1'b1;
		ReadEn_tb		= 1'b0;
		errors			= 0;

		#2
		rst_tb = 1'b0;
		#10
		rst_tb = 1'b1;

		$display("TEST 01: Reset clears all register locations");
		for(i = 0; i < 8; i = i + 1)
		begin
			read_and_check(i[2:0], 16'h0000);
		end

		$display("TEST 02: Write and read one register location");
		write_register(3'd3, 16'hA5A5);
		read_and_check(3'd3, 16'hA5A5);

		$display("TEST 03: Write and read another register location");
		write_register(3'd6, 16'h1234);
		read_and_check(3'd6, 16'h1234);
		read_and_check(3'd3, 16'hA5A5);

		$display("TEST 04: Write is disabled while ReadEn is active");
		addr_tb			= 3'd3;
		WriteData_tb	= 16'hFFFF;
		WriteEn_tb		= 1'b1;
		ReadEn_tb		= 1'b1;
		@(posedge clk_tb);
		#1
		WriteEn_tb		= 1'b0;
		ReadEn_tb		= 1'b0;
		read_and_check(3'd3, 16'hA5A5);

		if(errors == 0)
			$display("ALL REGISTER TESTS PASSED");
		else
			$display("REGISTER TESTS FAILED: %0d error(s)", errors);

		#20
		$finish;
	end

	task write_register;
		input [2:0]		test_addr;
		input [15:0]	test_data;
		begin
			addr_tb			= test_addr;
			WriteData_tb	= test_data;
			WriteEn_tb		= 1'b1;
			ReadEn_tb		= 1'b0;
			@(posedge clk_tb);
			#1
			WriteEn_tb		= 1'b0;
		end
	endtask

	task read_and_check;
		input [2:0]		test_addr;
		input [15:0]	expected_data;
		begin
			addr_tb		= test_addr;
			WriteEn_tb	= 1'b0;
			ReadEn_tb	= 1'b1;
			@(posedge clk_tb);
			#1
			if(ReadData_tb == expected_data)
				$display("PASS: addr %0d = 0x%0h", test_addr, ReadData_tb);
			else
			begin
				$display("FAIL: addr %0d expected 0x%0h, got 0x%0h",
					test_addr, expected_data, ReadData_tb);
				errors = errors + 1;
			end
			ReadEn_tb = 1'b0;
		end
	endtask

	always #5 clk_tb = ~clk_tb;

	Register DUT (
		.WriteData(WriteData_tb),
		.addr(addr_tb),
		.WriteEn(WriteEn_tb),
		.clk(clk_tb),
		.rst(rst_tb),
		.ReadEn(ReadEn_tb),
		.ReadData(ReadData_tb)
	);

endmodule
