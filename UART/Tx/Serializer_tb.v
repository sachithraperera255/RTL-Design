`timescale 1ns/1ps

module serializer_tb();
	reg	[7:0]	data_tb;
	reg 		clk_tb;
	reg			rst_tb;
	reg			serial_en_tb;
	wire		serial_done_tb;
	wire		serial_data_tb;

	task initialize;
	begin
		data_tb			= 8'd0;
		serial_en_tb	= 1'b0;
		clk_tb			= 1'b1;
		rst_tb			= 1'b1;
	end
	endtask
	
	task reset;
	begin
		#5
		rst_tb	= 1'b0; // reset is activate
		#5
		rst_tb	= 1'b1; // release the reset
	end
	endtask
	
	integer i;
	integer test_count = 0;
	integer fail_count = 0;

	task serialize_data;
		
		input [7:0] data_in; // Receives 8-bit data
		input 		enable_signal; // Receives the activate signal
		
	begin
		
		data_tb = data_in;
		serial_en_tb = enable_signal;
		
		if (serial_en_tb)
		begin
			@(posedge clk_tb)
			#1

			test_count = test_count + 1;
			// check if data load correctly
			if(DUT.input_data === data_tb && DUT.counter === 3'd0 && DUT.serial_done === 1'b0 && DUT.activate === 1'b1)
			begin
				$display("Test Passed!!!");
			end
			else
			begin
				fail_count = fail_count + 1;
				$display("Test Failed!!!");
			end
		
			@(negedge clk_tb)
			serial_en_tb	= 1'b0; // Make this signal low since its suppose to be a pulse signal
		
			for(i = 0; i < 8; i = i + 1)
			begin
			
				@(posedge clk_tb)
				#1

				test_count = test_count + 1;
				// check if data is getting serialized bit by bit starting from least significat bit
				if(serial_data_tb === data_tb[i])
				begin
					$display("Bit %d match", i);
				end
				else
				begin
					fail_count = fail_count + 1;
					$display("Mismatch, %d", i);
				end
			
				if(i == 7)
				begin

					test_count = test_count + 1;
					// check if the serial_done is setting to high after transmitting the last bit
					if(serial_done_tb === 1'b1)
					begin
						$display("serial_done passed!!!");
					end
					else
					begin
						fail_count = fail_count + 1;
						$display("serial_done failed!!!");
					end
				end
			end
		
		end
		else
		begin
			$display("Serial enable signal secevied LOW!!!");
		end
	end	
	endtask
	


	
	initial
	begin
		$dumpfile("Serializer.vcd");
		$dumpvars;
		
		initialize();

		reset();

		@(negedge clk_tb)
		serialize_data(8'd10, 1'b1);
		
		@(negedge clk_tb)
		serialize_data(8'h7D, 1'b1);

		@(negedge clk_tb)
		serialize_data(8'hFF, 1'b1);

		@(negedge clk_tb)
		serialize_data(8'hE2, 1'b1);

		#20
        // Final test summary
        $display("\n----------------------------");
        $display("Total checks : %0d", test_count);
        $display("Passed       : %0d", test_count - fail_count);
        $display("Failed       : %0d", fail_count);
        $display("----------------------------");

        if(fail_count > 0)
        begin
            $fatal(1, "SERIALIZER TESTBENCH FAILED");
        end
        else
        begin
            $display("ALL SERIALIZER TESTS PASSED");
            $stop;
        end
	end
	

	
	always #2.5 clk_tb = ~clk_tb;

	Serializer DUT 
	(
        .data        (data_tb),
        .clk         (clk_tb),
        .rst         (rst_tb),
        .serial_en   (serial_en_tb),
        .serial_done (serial_done_tb),
        .serial_data (serial_data_tb)
    );

endmodule


