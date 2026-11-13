module deserializer
	(
		input wire			sample_bit,
		input wire			deserial_en,
		input wire			clk,
		input wire			rst,

		output reg [7:0]	rx_out
	);


	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			rx_out <= 8'd0;
		end
		else if(deserial_en)
		begin
			rx_out <= {sample_bit, rx_out[7:1]};
		end
	end

endmodule