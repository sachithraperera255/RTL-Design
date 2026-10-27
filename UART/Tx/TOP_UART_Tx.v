module	TOP_Tx
	(
		input wire [7:0]					INPUT_DATA,
		input wire							PARITY_ENABLE,
		input wire							DATA_VALID,
		input wire							PARITY_TYPE,
		input wire							CLK,
		input wire							RST,
		
		output	wire						BUSY,
		output	wire						TX_OUT
	);

	// internal signals
	wire		SERIAL_DONE, SERIAL_ENABLE, PARITY_CALC_ENABLE; 
	wire		PARITY_BIT, SERIAL_DATA;
	wire [1:0] 	MUX_SELECT;

	//Serializer instantiation
	Serializer Serializer_inst
	(
		.data(INPUT_DATA),
		.clk(CLK),
		.rst(RST),
		.serial_en(SERIAL_ENABLE),
		.serial_done(SERIAL_DONE),
		.serial_data(SERIAL_DATA)
	);


	//Parity calculator instantiation
	ParityCalc ParityCalc_inst
	(
		.data(INPUT_DATA),
		.parity_calc_en(PARITY_CALC_ENABLE),
		.parity_type(PARITY_TYPE),
		.clk(CLK),
		.rst(RST),
		.parity_bit(PARITY_BIT)
	);


	//FSM_Tx instantiation
	FSM_Tx FSM_Tx_inst
	(
		.data_valid(DATA_VALID),
		.parity_en(PARITY_ENABLE),
		.serial_done(SERIAL_DONE),
		.clk(CLK),
		.rst(RST),
		.busy(BUSY),
		.mux_sel(MUX_SELECT),
		.parity_calc_en(PARITY_CALC_ENABLE),
		.serial_en(SERIAL_ENABLE)
	);



	//MUX instantiation
	Mux MUX_inst
	(
		.mux_sel(MUX_SELECT),
		.serialized_data(SERIAL_DATA),
		.parity_bit(PARITY_BIT),
		.tx_out(TX_OUT)
	);

endmodule
