module FSM_Tx
	(
		input wire			data_valid,
		input wire			parity_en,
		input wire			serial_done,
		input wire			clk,
		input wire			rst,

		output reg			busy,
		output reg [1:0]	mux_sel,
		output reg		parity_calc_en,
		output reg		serial_en
	);

	
	localparam [2:0]	IDLE 	= 3'b000,
						START	= 3'b001,
						DATA	= 3'b010,
						PARITY	= 3'b011,
						STOP	= 3'b111;

	reg [2:0] next_state, current_state;
	reg parity_en_reg;


	always @(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			current_state <= IDLE;
		end
		else
		begin
			current_state <= next_state;
			
			if(current_state == IDLE && data_valid)
			begin
				parity_en_reg <= parity_en;
			end
		end
	end

	always @(*)
	begin
		busy 			= 1'b0;
		mux_sel 		= 2'b00;
		parity_calc_en	= 1'b0;
		serial_en		= 1'b0;

		case (current_state)
			IDLE:
			begin
				if(rst && data_valid)
				begin
					busy 			= 1'b0;
					serial_en 		= 1'b1;
					parity_calc_en 	= 1'b1;
					next_state 		= START;
				end
				else
				begin
					next_state = IDLE;
				end
			end
			START:
			begin
				busy 		= 1'b1;
				mux_sel		= 2'b01;
				next_state 	= DATA;
			end
			DATA:
			begin
				busy 		= 1'b1;
				mux_sel		= 2'b10;
				if(serial_done)
				begin
					if(parity_en_reg)
					begin
						next_state = PARITY;
					end
					else
					begin
						next_state = STOP;
					end
				end
				else
				begin
					next_state = DATA;
				end
			end
			PARITY:
			begin
				busy		= 1'b1;
				mux_sel		= 2'b11;
				next_state 	= STOP;
			end
			STOP:
			begin
				busy		= 1'b1;
				mux_sel	= 2'b00;
				next_state  = IDLE;
			end
		default:
		begin
			next_state = IDLE;
			busy 			= 1'b0;
			mux_sel 		= 2'b00;
			parity_calc_en	= 1'b0;
			serial_en		= 1'b0;
		end
		endcase
	end

endmodule