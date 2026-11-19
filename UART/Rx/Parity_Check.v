module parity_check
	(
		input wire			parity_type,
		input wire			parity_check_en,
		input wire			sample_bit,
		input wire [7:0]	rx_out,
		input wire			clk,
		input wire			rst,

		output reg			parity_error
	);


	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			parity_error <= 1'b0;
		end
		else if(parity_check_en)
		begin
			parity_error <= ((^rx_out)^parity_type)^sample_bit;
		end
	end

endmodule