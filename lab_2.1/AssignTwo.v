module Counter(
	input wire [3:0] 		in,
	input wire 				latch,
	input wire 				dec,
	input wire 				clk,

	output wire				zero,
	output reg [3:0]	counter		
	);

	always @(posedge clk)
	begin
		if(latch)
		begin
			counter <= in;
		end
		else if (dec && !zero)
		begin
			counter <= counter - 4'b0001;
		end
	end
	
	assign zero = (counter == 0);

endmodule


//module Counter(
//	input wire [3:0] 		in,
//	input wire 				latch,
//	input wire 				dec,
//	input wire 				clk,
//
//	output wire				zero,
//	output reg [3:0]	counter		
//	);
//	
//	reg [3:0]	nextCount;
//
//	always @(*)
//	begin
//		nextCount = counter;
//		if(latch)
//		begin
//			 nextCount = in;
//		end
//		else if (dec && !zero)
//		begin
//			 nextCount =  nextCount - 4'b0001;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		counter <= nextCount;
//	end
//
//	assign zero = (counter == 0);
//
//endmodule
//
//











