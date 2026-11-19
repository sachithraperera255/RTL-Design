module parity_check_tb();

	reg	[7:0]	rx_out_tb;
	reg			parity_type_tb;
	reg			parity_check_en_tb;
	reg			sample_bit_tb;
	reg			clk_tb;
	reg			rst_tb;
	
	wire		parity_error_tb;

	task initialize;
	begin
		rx_out_tb			= 8'd0;
		parity_type_tb		= 1'b0;
		parity_check_en_tb	= 1'b0;
		sample_bit_tb		= 1'b0;
		clk_tb				= 1'b1;
		rst_tb				= 1'b1;
	end
	endtask

	task reset;
	begin
		@(negedge clk_tb);
		rst_tb	= 1'b0; // reset is applied

		repeat(2) @(negedge clk_tb);
		rst_tb = 1'b1; // reset is released
	end
	endtask

	task bit_checker;
	begin
	end
	endtask
	
	initial
	begin
		
		$dumpfile("parity_check.vcd");
		$dumpvars;

		initialize();

		reset();

		//bit_checker();

		
	end

	always #2.5 clk_tb = ~clk_tb;

	parity_check DUT
		(
			.party_type(parity_type_tb),
			.parity_check_en(parity_check_en_tb),
			.sample_bit(sample_bit_tb),
			.rx_out(rx_out_tb),
			.clk(clk_tb),
			.rst(rst_tb),
			.parity_error(parity_error_tb)
		);

endmodule




















