module start_check
	(
		input wire		sample_bit,
		input wire		start_check_en,
		input wire		clk,
		input wire		rst,
		
		output reg		start_error
	);

	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			start_error <= 1'b0;
		end
		else if(start_check_en)
		begin
			start_error <= sample_bit;
			// correct start bit suppose to be LOW. 
		end
	end

endmodule
	
