module start_check_tb();

	reg		start_check_en_tb;
	reg		sample_bit_tb;
	reg		clk_tb;
	reg		rst_tb;
	
	wire	start_error_tb;

	task initialize;
	begin
		start_check_en_tb	= 1'b0;
		sample_bit_tb		= 1'b0;
		clk_tb				= 1'b1;
		rst_tb				= 1'b1;
	end
	endtask

	task reset;
	begin
		@(negedge clk_tb);
		rst_tb	= 1'b0;  // reset is applied
		
		repeat(2) @(negedge clk_tb);
		rst_tb	= 1'b1; // reset release
	end
	endtask

	task bit_checker;
		input	sample_signal;
		input	enable_signal;
	begin
		
		@(negedge clk_tb);
		sample_bit_tb 		= sample_signal;
		start_check_en_tb	= enable_signal;
		

		$display("\nTESTING: sample_bit: %b, enable_signal: %b", sample_bit_tb, start_check_en_tb);
		@(posedge clk_tb);
		#1
		if(start_check_en_tb)
		begin
			if(start_error_tb === sample_bit_tb)
			begin
				$display("Test Passed");
			end
			else
			begin
				$display("Test Failed");
			end
		end
		else
		begin
			$display("START CHECK SIGNAL LOW");
		end
	end
	endtask

	initial
	begin
		
		$dumpfile("start_check.vcd");
		$dumpvars;

		initialize();

		reset();
	
		// sample_bit_tb = 0, start_check_en_tb = 1 --- correct start bit
		bit_checker(1'b0, 1'b1);
	
		// sample_bit_tb = 1, start_check_en_tb = 1 --- incorrect start bit
		bit_checker(1'b1, 1'b1);
	
		// sample_bit_tb = 1, start_check_en_tb = 0 --- enable bit is LOW
		bit_checker(1'b1, 1'b0);

		$finish;

	end

    always #2.5 clk_tb = ~clk_tb;


    start_check DUT
    (
        .sample_bit     (sample_bit_tb),
        .start_check_en (start_check_en_tb),
        .clk            (clk_tb),
        .rst            (rst_tb),
        .start_error    (start_error_tb)
    );


endmodule
