//******************************************************
//************************Logic Unit********************
//******************************************************

module LogicUnit 
#(
	parameter DATA_WIDTH = 16
)


(
	input wire [DATA_WIDTH-1:0]		a,
	input wire [DATA_WIDTH-1:0]		b,
	input wire [1:0]				alu_fun,
	input wire						clk,
	input wire						logic_en,
	input wire						rst,

	output reg [DATA_WIDTH-1:0]		logic_out,
	output reg						logic_flag
);
	
	reg [DATA_WIDTH-1:0]			logic_out_next;
	reg 							logic_flag_next;

	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			logic_out 	<= 'b0;
			logic_flag  <= 1'b0;
		end
		else
		begin
			logic_out 	<= logic_out_next;
			logic_flag  <= logic_flag_next;
		end
	end

	always @(*)
	begin
			logic_out_next = 'b0;
			logic_flag_next = 1'b0;

		if (logic_en)
		begin
			case (alu_fun)
				2'b00:
				begin
					logic_out_next = a & b;
					logic_flag_next = 1'b1;
				end
				2'b01:
				begin
					logic_out_next = a | b;
					logic_flag_next = 1'b1;
				end
				2'b10:
				begin
					logic_out_next = ~(a & b);
					logic_flag_next = 1'b1;
				end
				2'b11:
				begin
					logic_out_next = ~(a | b);
					logic_flag_next = 1'b1;
				end
				default
				begin
					// These two lines are added to handle simulation values like 2'bx1
					// This block is redundant but reasonable
					logic_out_next = 'b0; 
					logic_flag_next = 1'b0;
				end
			endcase
		end
	end
endmodule



