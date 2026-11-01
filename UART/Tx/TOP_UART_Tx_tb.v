`timescale 	1ns/1ps

module TOP_TX_TB();
	
	reg [7:0]	DATA_TB;
	reg			PARITY_ENABLE_TB;
	reg			DATA_VALID_TB;
	reg			PARITY_TYPE_TB;
	reg			CLK_TB;
	reg			RST_TB;

	wire		BUSY_TB;
	wire		TX_OUT_TB;
	
	integer test_count = 0;
	integer fail_count = 0;
	integer i;	


	task initialize;
	begin
		DATA_TB 			=	8'd0;
		PARITY_ENABLE_TB 	= 	1'b0;
		DATA_VALID_TB		=	1'b0;
		PARITY_TYPE_TB		=	1'b0;
		CLK_TB				=	1'b1;
		RST_TB				=	1'b1;
	end
	endtask


	task reset;
	begin
		#5
		RST_TB	= 1'b0;	// reset is active
	
		repeat(2) @(negedge CLK_TB)
		#0.1
		RST_TB	= 1'b1; // reset is release
	end
	endtask

	
	task test_config;
		input [7:0]	DATA_TB_LOOP;
		input		PARITY_ENABLE_TB_LOOP;
		input		DATA_VALID_TB_LOOP;
		input		PARITY_TYPE_TB_LOOP;

		reg	expected_parity;

	begin
		@(negedge CLK_TB)
		DATA_TB 			= DATA_TB_LOOP;
		PARITY_ENABLE_TB	= PARITY_ENABLE_TB_LOOP;
		DATA_VALID_TB		= DATA_VALID_TB_LOOP;
		PARITY_TYPE_TB		= PARITY_TYPE_TB_LOOP;
		

		if(DATA_VALID_TB)
		begin

			$display("Testing START STATE");
			@(posedge CLK_TB)
			#1
			
			test_count	= test_count + 1;
			if(TX_OUT_TB === 1'b0 && BUSY_TB === 1'b1)// TX_OUT set the bit low for a pulse to indicate the START bit
			begin
				$display("TEST PASSED");
			end
			else
			begin
				fail_count = fail_count + 1;
				$display("TEST FAILED");
			end

			// DATA_VALID is a one-cycle request pulse
			@(negedge CLK_TB);
			DATA_VALID_TB = 1'b0;

			$display("Testing DATA STATE - transmission of data bit by bit");
			for(i = 0; i < 8; i = i + 1)
			begin

				@(posedge CLK_TB)
				#1

				test_count	= test_count + 1;
				if(TX_OUT_TB === DATA_TB[i] && BUSY_TB === 1'b1)
				begin
					$display("TEST PASSED: bit matched %d ", i);
				end
				else
				begin
					fail_count = fail_count + 1;
					$display("TEST FAILED: bit mismatched %d ", i);
				end
			end

			if(PARITY_ENABLE_TB)
			begin
				expected_parity = (^DATA_TB) ^ PARITY_TYPE_TB;

				$display("Testing parity STATE");
				@(posedge CLK_TB)
				#1

				test_count	= test_count + 1;
				if(TX_OUT_TB === expected_parity && BUSY_TB === 1'b1)
				begin
					$display("TEST PASSED: bit matched %d ", expected_parity);
				end
				else
				begin
					fail_count = fail_count + 1;
					$display("TEST FAILED: bit mismatched %d ", expected_parity);
				end

			end
			
			$display("Testing STOP STATE");
			@(posedge CLK_TB)
			#1

			test_count	= test_count + 1;
			if(TX_OUT_TB === 1'b1 && BUSY_TB === 1'b1)
			begin
				$display("TEST PAASED");
			end
			else
			begin
				fail_count = fail_count + 1;
				$display("TEST FAILED");
			end
			

			$display("Testing IDLE STATE - must return to the IDLE STATE");
			@(posedge CLK_TB)
			#1

			test_count	= test_count + 1;
			if(TX_OUT_TB === 1'b1 && BUSY_TB === 1'b0)
			begin
				$display("TEST PAASED");
			end
			else
			begin
				fail_count = fail_count + 1;
				$display("TEST FAILED");
			end

			

		end
		else
		begin
			
			$display("Testing IDLE STATE - before assert DATA_VALID high ");
			@(posedge CLK_TB)
			#1

			test_count	= test_count + 1;
			if(TX_OUT_TB === 1'b1 && BUSY_TB === 1'b0)
			begin
				$display("TEST PASSED");
			end
			else
			begin
				fail_count = fail_count + 1;
				$display("TEST FAILED");
			end

		end
	
	end
	endtask

	initial
	begin
		
		$dumpfile("TOP_Tx.vcd");
		$dumpvars;
		
		initialize();

		reset();

		//test_config(DATA_TB, PARITY_ENABLE_TB, DATA_VALID_TB, PARITY_TYPE_TB);
		@(negedge CLK_TB)
		test_config(8'hC8, 1'b0, 1'b1, 1'b0);
		
		@(negedge CLK_TB)
		test_config(8'h96, 1'b1, 1'b1, 1'b1);

		@(negedge CLK_TB)
		test_config(8'h82, 1'b1, 1'b1, 1'b0);

		@(negedge CLK_TB)
		test_config(8'h8C, 1'b0, 1'b0, 1'b0);



		#20
        // Final test summary
        $display("\n----------------------------");
        $display("Total checks : %0d", test_count);
        $display("Passed       : %0d", test_count - fail_count);
        $display("Failed       : %0d", fail_count);
        $display("----------------------------");

        if(fail_count > 0)
        begin
            $fatal(1, "TX_TOP TESTBENCH FAILED");
        end
        else
        begin
            $display("ALL TX_TOP TESTS PASSED");
            $finish;
        end
	end

	always #2.5 CLK_TB = ~CLK_TB;

	TOP_Tx DUT
	(
		.INPUT_DATA(DATA_TB),
		.PARITY_ENABLE(PARITY_ENABLE_TB),
		.DATA_VALID(DATA_VALID_TB),
		.PARITY_TYPE(PARITY_TYPE_TB),
		.CLK(CLK_TB),
		.RST(RST_TB),
		.BUSY(BUSY_TB),
		.TX_OUT(TX_OUT_TB)
	);

endmodule


















	