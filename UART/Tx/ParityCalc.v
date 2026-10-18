
module ParityCalc
	(
		input wire [7:0]	data,
		input wire			parity_calc_en,
		input wire			parity_type,
		input wire			clk,
		input wire			rst,
		output reg			parity_bit
	);
	

	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			parity_bit <= 1'b0;
		end
		else if(parity_calc_en)
		begin
				parity_bit <= (^data) ^ parity_type;
		end
			// The else block is not added here to assign default values because we want to retian the previous value
	end

endmodule