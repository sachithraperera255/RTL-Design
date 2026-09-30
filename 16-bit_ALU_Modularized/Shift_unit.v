//******************************************************
//************************Shift Unit********************
//******************************************************

module ShiftUnit

#(
	parameter DATA_WIDTH = 16
)

(
	input wire [DATA_WIDTH-1:0]		a,
	input wire [DATA_WIDTH-1:0]		b,
	input wire [1:0]				alu_fun,
	input wire 						shift_en,
	input wire						clk,
	input wire						rst,
	
	output reg	[DATA_WIDTH-1:0]	shift_out,
	output reg 						shift_flag
);


	reg [DATA_WIDTH-1:0]			shift_out_next;
	reg 							shift_flag_next;
	
	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			shift_out <= 'b0;
			shift_flag <= 1'b0;
		end
		else
		begin
			shift_out <= shift_out_next;
			shift_flag <= shift_flag_next;
		end
	end


	always @(*)
	begin
		shift_out_next = 'b0;
		shift_flag_next = 1'b0;
		if (shift_en)		
		begin
			case (alu_fun)
				2'b00:
				begin
					shift_out_next = a >> 1;
					shift_flag_next = 1'b1;
				end
				2'b01:
				begin
					shift_out_next = a << 1;
					shift_flag_next = 1'b1;
				end
				2'b10:
				begin
					shift_out_next = b >> 1;
					shift_flag_next = 1'b1;
				end
				2'b11:
				begin
					shift_out_next = b << 1;
					shift_flag_next = 1'b1;
				end
				default
				begin
					shift_out_next = 'b0;
					shift_flag_next = 1'b0;
				end
			endcase
		end
	end
endmodule



