//******************************************************
//************************CMP Unit***********************
//******************************************************



module CmpUnit 
// Parameters
#(
	parameter DATA_WIDTH = 16
)

// Input and output declaration
(
	input wire [DATA_WIDTH-1:0]		a,
	input wire [DATA_WIDTH-1:0]		b,
	input wire 						clk,
	input wire						rst,
	input wire [1:0]				alu_fun,
	input wire 						cmp_en,

	output reg [DATA_WIDTH-1:0]		cmp_out,
	output reg 						cmp_flag
);

	// Internal signals
	reg	[DATA_WIDTH-1:0] cmp_out_next;
	reg							cmp_flag_next;
	// Asychrouns active low reset and reading next values
	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			cmp_out <= 'b0;
			cmp_flag <= 1'b0;
		end
		else
		begin
			cmp_out <= cmp_out_next;
			cmp_flag <= cmp_flag_next;
		end
	end


	always@(*)
	begin

		cmp_out_next = 'b0;
		cmp_flag_next = 1'b0;
		if (cmp_en)
		begin
			case (alu_fun)
				2'b00:
				begin
					cmp_out_next = 'b0;
					cmp_flag_next = 1'b1;
				end
				2'b01:
				begin
					cmp_out_next = (a == b)? 2'b01 : 'b00;
					cmp_flag_next = 1'b1;
				end
				2'b10:
				begin
					cmp_out_next = (a > b)? 2'b10 : 'b00;
					cmp_flag_next = 1'b1;
				end
				2'b11:
				begin
					cmp_out_next = (a < b)? 2'b11 :  'b00;
					cmp_flag_next = 1'b1;
				end
				default
				begin
					cmp_out_next = 'b00;
					cmp_flag_next = 1'b0;
				end
			endcase
		end
	end
endmodule