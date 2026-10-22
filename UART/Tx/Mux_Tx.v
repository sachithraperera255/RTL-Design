module Mux
	(
		input wire [1:0]	mux_sel,
		input wire			serialized_data,
		input wire			parity_bit,
		
		output	reg			tx_out
	);

	
	always @(*)
	begin
		case(mux_sel)
			2'b00:
			begin
				tx_out = 1'b1; // STOP
				/*
					Why does the tx_out set to high in STOP state?
					- at stop state output is set to high becuase in UART protocol the trasmission line stays high after
					 the data transmission ends
				*/
			end
			2'b01:
			begin
				tx_out	= 1'b0;
				/*
					Why does the tx_out is set to low in START state?
					- the tx_out is set to low in START  because when the transmission is ready send data UART protocol set the 
					 start bit to low for a period of clock cycle, then receiver detect the transmission line goes from high to low
					 indicating the begining of the data transmission
				*/
			end
			2'b10:
			begin
				tx_out	= serialized_data;
			end
			2'b11:
			begin
				tx_out	= parity_bit;
			end
		default:
			tx_out	= 1'b0;
		endcase
	end
endmodule