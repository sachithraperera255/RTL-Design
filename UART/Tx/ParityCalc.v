
module ParityCalc
	(
		input wire [7:0]				data,
		input wire					parity_calc_en,
		input wire					parity_type,
		input wire					clk,
		input wire					rst,
		output reg					parity_bit
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
			// The else block is not added here to assign default values because we want to retian the previous value.
			// It is important not to set the parity_bit to zero here, because it is only take one cycle of clock (one rising edge)
			// to calculate the parity values, but it takes 8 clock period to serialize data (transmit received 8-bit data one by one)
			// in the serializer. Therefore if the parity_bit is set to 0 before the serialzer finish its job, we loose our calculated 
			// parity bits 
	end

endmodule
