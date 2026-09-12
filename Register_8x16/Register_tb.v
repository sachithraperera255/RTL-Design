`timescale 1ns/1ns


module Register_tb ();

	//Testbench signals
	reg	[15:0]		WriteData_tb;
	reg [2:0]		Addr_tb;
	reg				WriteEn_tb;
	reg				ReadEn_tb;
	reg				clk_tb;
	reg				rst_tb;
	wire [15:0]		ReadData_tb;

	initial
	begin
		$dumpfile("Register.vcd");
		$dumpvars;
		
		// Initial signal values
		WriteData_tb = 16'd0;
		Addr_tb		 = 3'b000;
		WriteEn_tb 	 = 1'b0;
		ReadEn_tb	 = 1'b0;
		clk_tb		 = 1'b0;
		rst_tb		 = 1'b0; // Active low async reset is active

		#10
		rst_tb		 = 1'b1; // Reset is deactivated
		

 		$display("Writing Operation\n");

		ReadEn_tb		= 1'b0;
		WriteEn_tb		= 1'b1;
		Addr_tb			= 3'b001;
		WriteData_tb	= 16'd15;

		@(posedge clk_tb);
		#1
		

		ReadEn_tb		= 1'b0;
		WriteEn_tb		= 1'b1;
		Addr_tb			= 3'b101;
		WriteData_tb	= 16'd10;

		@(posedge clk_tb);
		#1


		ReadEn_tb		= 1'b0;
		WriteEn_tb		= 1'b1;
		Addr_tb			= 3'b111;
		WriteData_tb	= 16'd25;

		@(posedge clk_tb);
		#1

		
 		$display("Reading Operation\n");
		ReadEn_tb		= 1'b1;
		WriteEn_tb		= 1'b0;
		Addr_tb			= 3'b001;

		@(posedge clk_tb);
		#1		
		if(ReadData_tb == 16'd15)
		begin
			$display("Test Passed\n");
		end
		else
		begin
			$display("Test Failed\n");
		end


		ReadEn_tb		= 1'b1;
		WriteEn_tb		= 1'b0;
		Addr_tb			= 3'b101;

		@(posedge clk_tb);
		#1
		if(ReadData_tb == 16'd10)
		begin
			$display("Test Passed\n");
		end
		else
		begin
			$display("Test Failed\n");
		end
		
		
		ReadEn_tb		= 1'b1;
		WriteEn_tb		= 1'b0;
		Addr_tb			= 3'b111;

		@(posedge clk_tb);
		#1		
		if(ReadData_tb == 16'd25)
		begin
			$display("Test Passed\n");
		end
		else
		begin
			$display("Test Failed\n");
		end

		
		$stop;
	end
		
	always #5 clk_tb = ~clk_tb;
		
	Register DUT
	(
		.WriteData(WriteData_tb),
		.addr(Addr_tb),
		.WriteEn(WriteEn_tb),
		.clk(clk_tb),
		.rst(rst_tb),
		.ReadEn(ReadEn_tb),
		.ReadData(ReadData_tb)
	);

endmodule
		