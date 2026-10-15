module Serializer
	(
		input wire [7:0]		data,
		input wire				clk,
		input wire 				rst,
		input wire				serial_en,
		output reg				serial_done,
		output reg				serial_data
	);
	
	// register to store input data
	reg [7:0] input_data;

	// 3 bit registe counter
	reg [2:0] counter;

	// Internal signal
	reg activate;

	// Asynchronous active low reset
	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			serial_done <= 1'b0;
			serial_data <= 1'b0;
			input_data <= 8'd0;
			activate <= 1'b0;
			counter <= 3'd0;
		end
		else if(serial_en && !activate)
		begin
			input_data <= data;
			counter <= 3'd0;
			serial_done <= 1'b0;
			activate <= 1'b1;
		end
		else if(activate)
		begin
			serial_data <= input_data[0];
			input_data <= input_data >> 1;
			
			if(counter == 3'd7)
			begin
				serial_done <= 1'b1;
				activate <= 1'b0;
				counter <= 3'd0;
			end
			else
			begin
				serial_done <= 1'b0;
				counter <= counter + 1'b1;
			end

		end
		else
		begin
			serial_done <= 1'b0;
			serial_data <= 1'b0;		
		end

	end
endmodule

