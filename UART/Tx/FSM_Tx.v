module FSM_Tx
	(
		input wire			data_valid,
		input wire			parity_en,
		input wire			serial_done,
		input wire			clk,
		input wire			rst,

		output reg			busy,
		output reg [1:0]	mux_sel,
		/*
			Following outputs are wires instead of registers because they are pulse signls
			we don't need to hold signal until serializer and ParityCalc finishes they respective funtions
		*/
		output wire		parity_calc_en,
		output wire		serial_en
	);

	
	localparam		IDLE 	= 3'b000,
					START	= 3'b001,
					DATA	= 3'b010,
					PARITY	= 3'b011,
					STOP	= 3'b111;

	reg [2:0] next_state, current_state;

	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			busy 			<= 1'b0;
			mux_sel 		<= 3'b000;
			parity_calc_en 	<= 1'b0;
			serial_en		<= 1'b0;
		end
		else
		begin
			current_state <= next_state
		end
	end

	always @(*)
	begin
		case (current_state)
			IDLE:
				if(data_valid)
				begin
					next_state 		= START;
					serial_en 		= 1'b1;
					parity_calc_en 	= 1'b1;
					busy			= 1'b0;
				end
				else
				begin
					next_state = IDLE;
				end
			START:
				if(serial_done)
				begin
					if(parity_type)
					begin
						next_state = PARITY;
						busy	   = 1'b1;
					end
					else
					begin
						next_state = STOP;
						busy	   = 1'b1;
					end
				end
				else
				begin
					next_state = START;
					busy	   = 1'b1;
				end
		endcase
	end