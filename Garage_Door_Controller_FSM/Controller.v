module Controller
	(
		input wire		up_max,
		input wire		activate,
		input wire		dn_max,
		input wire		clk,
		input wire		rst,

		output reg		up_m,
		output reg		dn_m
	);


	localparam		idle 	= 2'b00,
					mv_up 	= 2'b01,
					mv_dn	= 2'b10;

	reg [1:0]	current_state, next_state;

	// Asynchronous reset
	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			current_state <= idle;
		end
		else
		begin
			current_state <= next_state;
		end
	end


	always @(*)
	begin
		up_m = 1'b0;
		dn_m = 1'b0;
		 case (current_state)
			idle:
			begin
				if(activate && up_max && !dn_max)
				begin
					next_state = mv_dn;
				end
				else if (activate && dn_max && !up_max)
				begin
					next_state = mv_up;
				end
				else
				begin
					next_state = idle;
				end
			end
			mv_up:
			begin
				if(up_max)
				begin
					next_state = idle;
				end
				else
				begin
					next_state = mv_up;
					up_m = 1'b1;
				end
			end
			mv_dn:
			begin
				if(dn_max)
				begin
					next_state = idle;
				end
				else
				begin
					next_state = mv_dn;
					dn_m = 1'b1;
				end
			end
			default:
			begin
				next_state = idle;
				up_m = 1'b0;
				dn_m = 1'b0;
			end
		endcase
	end
endmodule
