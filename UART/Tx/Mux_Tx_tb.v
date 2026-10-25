`timescale 1ns/1ps

module Mux_tb();

	reg [1:0]	mux_sel_tb;
	reg			serialized_data_tb;
	reg			parity_bit_tb;
	wire		tx_out;

	task initialize;
	begin
		mux_sel_tb 				= 2'b00;
		serialized_data_tb 		= 1'b0;
		parity_bit_tb			= 1'b0;
	end
	endtask

	initial
	begin
		$dumpfile("Mux_Tx.vcd");
		$dumpvars;
		
		initialize();
		
		
		$display("Test 01: Testing STOP output");
		mux_sel_tb	= 2'b00;
		#1
		
		if(tx_out === 1'b1)
		begin
			$display("Test passed");
		end
		else
		begin
			$display("Test failed");
		end
		
		$display("Test 02: Testing START output");
		mux_sel_tb	= 2'b01;
		#1
		
		if(tx_out === 1'b0)
		begin
			$display("Test passed");
		end
		else
		begin
			$display("Test failed");
		end

		$display("Test 03: Testing DATA serialize output");
		mux_sel_tb			= 2'b10;
		serialized_data_tb 	= 1'b1;
		#1
		
		if(tx_out === 1'b1)
		begin
			$display("Test passed");
		end
		else
		begin
			$display("Test failed");
		end


		$display("Test 04: Testing PARITY output");
		mux_sel_tb		= 2'b11;
		parity_bit_tb	= 1'b1;
		#1
		
		if(tx_out === 1'b1)
		begin
			$display("Test passed");
		end
		else
		begin
			$display("Test failed");
		end

		#10
		$stop;

	end

	Mux DUT
	(
		.mux_sel(mux_sel_tb),
		.serialized_data(serialized_data_tb),
		.parity_bit(parity_bit_tb),
		.tx_out(tx_out)
	);


	
endmodule