module LOCKER_tb ();

	reg	BUTTON_ONE_tb;
	reg	BUTTON_ZERO_tb;
	reg	CLK_tb;
	reg RST_tb;
	wire UNLOCK_tb;

	// This task initialize values
	task initial_val;
	begin
		BUTTON_ONE_tb 	= 1'b0;
		BUTTON_ZERO_tb 	= 1'b0;
		CLK_tb			= 1'b0;
	end
	endtask

	// This is use to reset the circuit
	task reset;
	begin
		RST_tb		= 1'b1;
		#1
		RST_tb		= 1'b0;
		#1
		RST_tb		= 1'b1;
	end
	endtask
	
	// This task automate the press of buttons
	task button
	(
		input reg [4:0]		BUTTON_ONE,
		input reg [4:0]		BUTTON_ZERO
	);
	
	integer i;
	
	begin
		for(i = 0; i < 5; i = i +1)
		begin
			@(negedge CLK_tb)
			 BUTTON_ONE_tb  = BUTTON_ONE[i];
			 BUTTON_ZERO_tb = BUTTON_ZERO[i];
		end
	end
	endtask

	initial
	begin
		
		$dumpfile("LOCKER.vcd");
		$dumpvars;

		initial_val();
		
		reset();


		button(5'b11010, 5'b00101);

		wait(UNLOCK_tb)
		$display("Lock is unlocked at time %d", $time);

		$finish;

	end

	// Clock generation
	always #0.5 CLK_tb = ~CLK_tb;	


	// Instantiation
	LOCKER DUT
	(
		.button_one(BUTTON_ONE_tb), 
		.button_zero(BUTTON_ZERO_tb),
		.rst(RST_tb),
		.clk(CLK_tb),
		.unlock(UNLOCK_tb)
	);
		
endmodule