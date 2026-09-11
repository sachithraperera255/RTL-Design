module Register
	(
		input wire	[15:0]	WriteData,
		input wire  [2:0]	addr,
		input wire			WriteEn,
		input wire			clk,
		input wire			rst,
		input wire			ReadEn,
		output reg	[15:0]	ReadData
	);

	
	// 8x16 Register
	reg [15:0] register [7:0];
	
	always @(posedge clk or negedge rst)
	begin
		
		if(!rst)
		begin
			register[0] <= 0;
			register[1] <= 0;
			register[2] <= 0;
			register[3] <= 0;
			register[4] <= 0;
			register[5] <= 0;
			register[6] <= 0;
			register[7] <= 0;
		end
		else
		begin
			if (WriteEn && !ReadEn)
			begin
				register[addr] <= WriteData;
			end
			else if (ReadEn && !WriteEn)
			begin
				ReadData <= register[addr];
			end
		end
	end

endmodule
