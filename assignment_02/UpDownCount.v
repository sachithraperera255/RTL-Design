module UpDownCount(
		input [4:0]		in,
		input			load,
		input			up,
		input			down,
		input 			clk,
		
		output			high,
		output			low,
		output reg [4:0]	counter			
	);
	
	always @(posedge clk)
	begin
		if (load)
		begin
			counter <= in;
		end
		else if (down && counter != 5'b00000)
		begin
			counter <= counter - 5'b00001;
		end
		else if (up && counter != 5'b11111)
		begin
			counter <= counter + 5'b00001;
		end
	end
	
	assign low = (counter == 5'b00000);
	assign high = (counter == 5'b11111);

endmodule
