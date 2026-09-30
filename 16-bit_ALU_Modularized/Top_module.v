//******************************************************
//************************Top ALU Unit******************
//******************************************************


module TopMod

#(
	parameter INOUT_DATA_WIDTH = 16,
			  ARITH_OUTPUT_DATA_WIDTH = 32
)


(
	input wire [INOUT_DATA_WIDTH-1:0]		A,
	input wire [INOUT_DATA_WIDTH-1:0]		B,
	input wire [3:0]						ALU_FUN,
	input wire 								CLK,
	input wire								RST,
	
	
	//Arithmetic unit
	output wire	[ARITH_OUTPUT_DATA_WIDTH-1:0]		ARITH_OUT,
	output wire										ARITH_FLAG,

	//Logic unit
	output wire	[INOUT_DATA_WIDTH-1:0]				LOGIC_OUT,
	output wire										LOGIC_FLAG,

	//CMP unit
	output wire	[INOUT_DATA_WIDTH-1:0]				CMP_OUT,
	output wire										CMP_FLAG,

	//Shift unit
	output wire	[INOUT_DATA_WIDTH-1:0]				SHIFT_OUT,
	output wire										SHIFT_FLAG
);


	// internal signals
	wire ARITH_EN, LOGIC_EN, CMP_EN, SHIFT_EN;
	
	DecoderUnit Decoder_inst
	(
		.alu_fun(ALU_FUN[3:2]),
		.arith_en(ARITH_EN),
		.logic_en(LOGIC_EN),
		.cmp_en(CMP_EN),
		.shift_en(SHIFT_EN)
	);
	

	ArithmeticUnit
	#(
		.INPUT_DATA_WIDTH(INOUT_DATA_WIDTH),
		.OUTPUT_DATA_WIDTH(ARITH_OUTPUT_DATA_WIDTH)
	)
	Arithmetic_inst
	(
		.a(A),
		.b(B),
		.clk(CLK),
		.rst(RST),
		.alu_fun(ALU_FUN [1:0]),
		.arith_en(ARITH_EN),
		.arith_out(ARITH_OUT),
		.arith_flag(ARITH_FLAG)
	);
	
	
	LogicUnit
	#(
		.DATA_WIDTH(INOUT_DATA_WIDTH)
	)
	Logic_inst
	(
		.a(A),
		.b(B),
		.clk(CLK),
		.rst(RST),
		.alu_fun(ALU_FUN [1:0]),
		.logic_en(LOGIC_EN),
		.logic_out(LOGIC_OUT),
		.logic_flag(LOGIC_FLAG)
	);
	
	
	CmpUnit
	#(
		.DATA_WIDTH(INOUT_DATA_WIDTH)
	) 
	Cmp_inst
	(
		.a(A),
		.b(B),
		.clk(CLK),
		.rst(RST),
		.alu_fun(ALU_FUN [1:0]),
		.cmp_en(CMP_EN),
		.cmp_out(CMP_OUT),
		.cmp_flag(CMP_FLAG)
	);
	
	
	ShiftUnit
	#(
		.DATA_WIDTH(INOUT_DATA_WIDTH)
	) 
	Shift_inst
	(
		.a(A),
		.b(B),
		.clk(CLK),
		.rst(RST),
		.alu_fun(ALU_FUN [1:0]),
		.shift_en(SHIFT_EN),
		.shift_out(SHIFT_OUT),
		.shift_flag(SHIFT_FLAG)
	);

endmodule
