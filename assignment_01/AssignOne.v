module AssignOne 
	(
		input in1,
		input in2,
		input in3,
		input in4,
		input in5,
		input clk,

		output reg out1,
		output reg out2,
		output reg out3
	);

	reg d1, d2, d3;
	
	always @(posedge clk)
	begin
		out1 <= d1;
		out2 <= d2;
		out3 <= d3;
	end
	
	wire inner1, inner2;

	always @(*)
	begin
		d1 = ~((~(in1 | in2)) & in3);
		d2 = ~(in2 & in3);
		d3 = ((in3 | ~in4) | in5);
	end

endmodule
	

