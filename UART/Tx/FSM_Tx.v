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

	
	localparam [2:0]	IDLE 	= 3'b000,
						START	= 3'b001,
						DATA	= 3'b010,
						PARITY	= 3'b011,
						STOP	= 3'b111;

	reg [2:0] next_state, current_state;



	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			current_state <= IDLE;
		end
		else
		begin
			current_state <= next_state;
		end
	end

	always @(*)
	begin
		case (current_state)
			IDLE:
			begin
				if(data_valid)
				begin
					next_state 	= START;
				end
				else
				begin
					next_state = IDLE;
				end
			end
			START:
			begin
				next_state = DATA;
			end
			DATA:
			begin
				if(parity_en && serial_done)
				begin
					next_state = PARITY;
				end
				else if(!parity_en && serial_done)
				begin
					next_state = STOP;
				end
				else
				begin
					next_state = DATA;
				end
			end
			PARITY:
			begin
				next_state = STOP;
			end
			STOP:
			begin
				next_state = IDLE;
			end
		default:
		begin
			next_state = IDLE;
		end
		endcase
	end