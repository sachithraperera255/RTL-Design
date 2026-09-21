// This lab design a digital lock, which has 3 buttons,
//		- Reset 		--> Reset the sequence
//		- button_one	--> Enter 1
//		- button_zero 	--> Enter 0
// The passward to unlock the lock is 01011.
// The user must enter the password in correct sequence from left to right,
// if any of the digit is entered incorrectly, the sequence will reset.


module LOCKER (
	input wire		button_one, button_zero,
	input wire		rst,
	input wire		clk,
	output reg		unlock
	);


	localparam		[2:0]	idle = 3'b000,
							s1	 = 3'b001,
							s2	 = 3'b011,
							s3	 = 3'b010,
							s4	 = 3'b110;

	reg [2:0]  current_state, next_state;
	
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

		next_state = idle;
		unlock = 1'b0;

		case(current_state)
			idle:
				if(button_zero)
				begin
					next_state = s1;
				end
				else
				begin
					next_state = idle;
				end
			s1:
				if(button_one)
				begin
					next_state = s2;
				end
				else if (button_zero)
				begin
					next_state = idle;
				end
				else
				begin
					next_state = s1;
				end
			s2:
				if(button_zero)
				begin
					next_state = s3;
				end
				else if(button_one)
				begin
					next_state = idle;
				end
				else
				begin
					next_state = s2;
				end
			s3:
				if(button_one)
				begin
					next_state = s4;
				end
				else if(button_zero)
				begin
					next_state = idle;
				end
				else
				begin
					next_state = s3;
				end
			s4:
				if(button_one)
				begin
					next_state = idle;
					unlock = 1'b1;
				end
				else if(button_zero)
				begin
					next_state = idle;
				end
				else
				begin
					next_state = s4;
				end
			default:
			begin
				next_state = idle;
				unlock = 1'b0;
			end
		endcase
	end

endmodule
