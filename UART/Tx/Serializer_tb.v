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
	
	initial
	begin
		$dumpfile("Serializer.vcd");
		$dumpvars;
		
		initialize();

		reset();

		@(negedge clk_tb)
		data_tb			= 8'd10;
		serial_en_tb	= 1'b1;
		
		@(posedge clk_tb)
		#1
		if(DUT.input_data === 8'd10 && DUT.counter === 3'd0 && DUT.serial_done === 1'b0 && DUT.activate === 1'b1)
		begin
			$display("Test Passed!!!");
		end
		else
		begin
			$display("Test Failed!!!");
		end
		
		@(negedge clk_tb)
		serial_en_tb	= 1'b0; // Make this signal low since its suppose to be a pulse signal
		
		for(i = 0; i < 8; i = i + 1)
		begin
			
			@(posedge clk_tb)
			#1
			if(serial_data_tb === data_tb[i])
			begin
				$display("Bit %d match", i);
			end
			else
			begin
				$display("Mismatch, %d", i);
			end
			
			if(i == 7)
			begin
				if(serial_done_tb === 1'b1)
				begin
					$display("serial_done passed!!!");
				end
				else
				begin
					$display("serial_done failed!!!");
				end
			end
		end
		#20
		$stop;
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


