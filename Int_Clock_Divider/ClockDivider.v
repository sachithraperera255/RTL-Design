module Divider
	(
		input wire 			clk, // reference clock
		input wire			rst, // active low asynchornous reset
		input wire			clk_en, // enable clock divider for the sequential block
		input wire [7:0]	div_ratio, // clock dividing ratio

		output reg			div_clk // output clock
	);


	reg [7:0]	count;

	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			div_clk <= 1'b0;
			count <= 8'd0;
		end
		else if (clk_en && div_ratio != 8'd0 && div_ratio != 8'd1)
		begin
			if(count < div_ratio - 8'd1)
			begin
				count <= count + 8'd1;
			end
			else
			begin
				count <= 8'd0;
			end

			if(count < (div_ratio >> 1))
			begin
				div_clk <= 1'b1;
			end
			else
			begin
				div_clk <= 1'b0;
			end
		end
		else
		begin
			div_clk <= 1'b0;
			count <= 8'd0;
		end
	end
endmodule