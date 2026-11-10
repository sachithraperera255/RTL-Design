module data_sample
	(
		input wire			rx_in,
		input wire [5:0]	prescale,
		input wire [4:0]	edge_cnt,
		input wire			clk,
		input wire			rst,
		input wire			data_sample_en,

		output reg			sample_bit
	);

	wire [4:0]	mid_point;

	assign mid_point = prescale >> 1;

	reg sample_one;
	reg sample_two;

	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			sample_bit <= 1'b0;
			sample_one <= 1'b0;
			sample_two <= 1'b0;
		end
		else if(data_sample_en)
		begin

			if(prescale == 6'd4)
			begin
				if(edge_cnt == mid_point)
				begin
					sample_bit <= rx_in;
				end
			end
			else
			begin
				if(edge_cnt == mid_point - 5'd1)
				begin
					sample_one <= rx_in;
				end

				if(edge_cnt == mid_point)
				begin
					sample_two <= rx_in;
				end

				if(edge_cnt == mid_point + 5'd1)
				begin
					sample_bit <= (sample_one & sample_two) | (sample_one & rx_in) | (sample_two & rx_in);
				end

			end
		end
		else
		begin
			sample_one <= 1'b0;
			sample_two <= 1'b0;
		end
	end
endmodule