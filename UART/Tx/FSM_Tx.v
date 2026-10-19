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

	
	localparam		IDLE 	= 2'b00,
					START	= 2'b01,
					DATA	= 2'b10,
					PARITY	= 2'b11;

	reg [1:0] next_state, current_state;

	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			busy 			<= 1'b0;
			mux_sel 		<= 2'b00;
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
					next_state = DATA;
				end
				else
				begin
					next_state = IDLE;
				end
			DATA:
				if(data_valid)
				begin
					next_state = DATA;
				end
				else
				begin
					next_state = IDLE;
				end
		endcase
	end