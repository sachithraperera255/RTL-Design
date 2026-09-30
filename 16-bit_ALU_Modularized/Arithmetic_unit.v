//******************************************************
//************************Arithmetic Unit***************
//******************************************************


module ArithmeticUnit 

// Parameters
#(
	parameter INPUT_DATA_WIDTH = 16,
			  OUTPUT_DATA_WIDTH = 32
)

// Input and output declaration
(
	input wire signed [INPUT_DATA_WIDTH-1:0]		a,
	input wire signed [INPUT_DATA_WIDTH-1:0]		b,
	input wire 										clk,
	input wire										rst,
	input wire [1:0]								alu_fun,
	input wire 										arith_en,

	output reg signed [OUTPUT_DATA_WIDTH-1:0]		arith_out,
	output reg 										arith_flag
);
	

// Internal signals
	reg	signed	[OUTPUT_DATA_WIDTH-1:0] arith_out_next;
	reg									arith_flag_next;

// Asychrouns active low reset and reading next values
	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			arith_out <= 'b0;
			arith_flag <= 'b0;
		end
		else
		begin
			arith_out <= arith_out_next;
			arith_flag <= arith_flag_next;
		end
	end

// Combinational logic for ALU's arithmetic function
	always @(*)
	begin
		arith_out_next = 'b0;
		arith_flag_next = 1'b0;
		if(arith_en)
		begin
			case (alu_fun)
				2'b00:
				begin
					arith_out_next = a + b;
					arith_flag_next = 1'b1;
				end
				2'b01:
				begin
					arith_out_next = a - b;
					arith_flag_next = 1'b1;
				end
				2'b10:
				begin
					arith_out_next = a * b;
					arith_flag_next = 1'b1;
				end
				2'b11:
				begin
					arith_out_next = a / b;
					arith_flag_next = 1'b1;
				end

// In this case, following default block is not necessary since all the possible scenarios are implemented.
// The 'else' block has been removed due to the same reason mentioned above.
// The default block should be used when appropriate to the design architecture.
// Due to the simulation values like x, it is reasonable have it
				default
				begin
					arith_out_next = 'b0;
					arith_flag_next = 'b0;
				end

			endcase
		end
	end
endmodule
