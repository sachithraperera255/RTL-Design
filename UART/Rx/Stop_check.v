module stop_bit
	(
		input wire		sample_bit,
		input wire 		stop_check_en,
		input wire		clk,
		input wire		rst,
		
		output reg		stop_error
	);

	
	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			stop_error <= 1'b0;
		end
		else if(stop_check_en)
		begin
			stop_error <= ~sample_bit;
			// if the sample_bit is HIGH, the above line will invert it, this module will output LOW
			// indicating the detection of correct STOP bit. If the sample_bit is LOW, stop_error will
			// output HIGH indicating the detection of incorrect STOP bit.
		end
	end

endmodule
