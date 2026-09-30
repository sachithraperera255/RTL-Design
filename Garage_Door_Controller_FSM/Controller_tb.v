`timescale 1ns/1ps

module controller_tb ();
	
	reg		up_max_tb;
	reg		activate_tb;
	reg		dn_max_tb;
	reg		clk_tb;
	reg		rst_tb;

	wire	up_m_tb;
	wire	dn_m_tb;

	//initialize values
	task initialize;
	begin
		up_max_tb 	= 1'b0;
		activate_tb = 1'b0;
		dn_max_tb	= 1'b1;
		clk_tb		= 1'b1;
		rst_tb		= 1'b1; // to prevent starting rst_tb as X
	end
	endtask
		

	task reset;
	begin
		rst_tb = 1'b1; //initialize the rest
		#10
		rst_tb = 1'b0; //reset activate
		#10
		rst_tb = 1'b1; //release the rest
	end
	endtask


	task activate;
	begin
		@(negedge clk_tb)
		activate_tb = 1'b1;
		@(negedge clk_tb)
		activate_tb = 1'b0; //the button is both pressed and reseale at negetive clock edge to make sure that 
							// positive edge at in between catch the signigal
	end
	endtask


	task open_sensor;
	begin
		@(negedge clk_tb)
		dn_max_tb = 1'b0; // door is leaving the closed postion 
		
		// The door is opening for 3 negetive edges
		repeat(3) @(negedge clk_tb);

		up_max_tb = 1'b1; // door is reaching the open position
	end
	endtask


	task close_sensor;
	begin

		@(negedge clk_tb)
		up_max_tb = 1'b0; // door is leaving the open position

		// The door is closing for 3 negetive edges
		repeat(3) @(negedge clk_tb);

		dn_max_tb = 1'b1; // door is reaching the close position
	end
	endtask

	task motor_check
	(
		input reg UP_M,
		input reg DN_M
	);
	begin
		
		if(up_m_tb === UP_M && dn_m_tb === DN_M)
		begin
			$display("Motor is working as expected");
		end
		else
		begin
			$display("Motor does not working as expected");
		end
		
	end
	endtask

	initial
	begin
		
		$dumpfile("Controller.vcd");
		$dumpvars;

		// initialize the signals
		initialize();
		
		// reset the circuit
		reset();

		// activate the motor
		activate();

		// enter the signals to check open door function
		motor_check(1'b1, 1'b0);
		
		// activate the open sensor
		open_sensor();

		// activate the motor
		activate();

		// enter the signals to check open door function
		motor_check(1'b0, 1'b1);
		
		// activate the close sensor
		close_sensor();
		
		#30
		
		$stop;
		
	end


	always #10 clk_tb = ~clk_tb;

	Controller DUT
	(
		.up_max(up_max_tb),
		.activate(activate_tb),
		.dn_max(dn_max_tb),
		.clk(clk_tb),
		.rst(rst_tb),
		.up_m(up_m_tb),
		.dn_m(dn_m_tb)
	);


endmodule
