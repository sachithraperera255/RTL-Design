module DigCt
	(
		input IN1,
		input IN2,
		input IN3,
		input IN4,
		input clk,
		
		output reg out1,
		output reg out2,
		output reg out3
	);

	reg d1,d2,d3;

	always @(posedge clk)
	begin
		out1 <= d1;
		out2 <= d2;
		out3 <= d3;
	end
	
	always @(*)
	begin
		d1 = ~(IN1 | IN2);
		d2 = ~(IN2 & IN3);
		d3 = IN3 | IN4;
	end

endmodule
