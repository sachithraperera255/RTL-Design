//time_unit = 1ns and time precision = 1ps
`timescale 1ns/1ps


module ALU_tb ();

	// In testbenches inputs are 'reg' type and output are 'wire' type
	reg [15:0]		a_tb;
	reg	[15:0]		b_tb;
	reg [3:0]		alu_fun_tb;
	reg				clk_tb;
	
	wire [15:0]		alu_out_tb;
	wire 			carry_tb;
	wire			arith_tb;
	wire			logic_tb;
	wire			cmp_tb;
	wire			shift_tb;

	initial
	begin
		$dumpfile("ALU.vcd"); // waveform data save in this file
		$dumpvars; // save waveform data during the simulation
		a_tb = 16'd0;
		b_tb = 16'd0;
		alu_fun_tb = 4'b0;
		clk_tb = 1'b0;
		
		#10		
		$display ("TEST CASE 1: Addition test with no carry");

		a_tb = 16'd10;
		b_tb = 16'd5;
		alu_fun_tb = 4'b0000;
		#10
		
		if(alu_out_tb == 16'd15 && carry_tb == 1'b0 && arith_tb == 1'b1)
			$display("TEST 1: Addition test passed");
		else
			$display("TEST 1: Addition test failed");

		#10		
		$display ("TEST CASE 2: Addition test with carry");

		a_tb = 16'hFFFF;
		b_tb = 16'd1;
		alu_fun_tb = 4'b0000;
		#10
		
		if(alu_out_tb == 16'b0000 && carry_tb == 1'b1 && arith_tb == 1'b1)
			$display("TEST 2: Addition test passed");
		else
			$display("TEST 2: Addition test failed");
		

		#10		
		$display ("TEST CASE 3: Subtraction test");

		a_tb = 16'd10;
		b_tb = 16'd2;
		alu_fun_tb = 4'b0001;
		#10
		
		if(alu_out_tb == 16'd8 && carry_tb == 1'b0 && arith_tb == 1'b1)
			$display("TEST 3: Subtraction test passed");
		else
			$display("TEST 3: Subtraction test failed");


		#10		
		$display ("TEST CASE 4: Multiplication test");

		a_tb = 16'd3;
		b_tb = 16'd2;
		alu_fun_tb = 4'b0010;
		#10
		
		if(alu_out_tb == 16'd6 && arith_tb == 1'b1)
			$display("TEST 4: Multiplication test passed");
		else
			$display("TEST 4: Multiplication test failed");


		#10		
		$display ("TEST CASE 5: Division test");

		a_tb = 16'd8;
		b_tb = 16'd2;
		alu_fun_tb = 4'b0011;
		#10
		
		if(alu_out_tb == 16'd4 && arith_tb == 1'b1)
			$display("TEST 5: Division test passed");
		else
			$display("TEST 5: Division test failed");



		#10		
		$display ("TEST CASE 6: AND test");

		a_tb = 16'b1010;
		b_tb = 16'b0001;
		alu_fun_tb = 4'b0100;
		#10
		
		if(alu_out_tb == 16'b0000 && logic_tb == 1'b1)
			$display("TEST 6: AND test passed");
		else
			$display("TEST 6: AND test failed");


		#10		
		$display ("TEST CASE 7: OR test");

		a_tb = 16'b1010;
		b_tb = 16'b0001;
		alu_fun_tb = 4'b0101;
		#10
		
		if(alu_out_tb == 16'b1011 && logic_tb == 1'b1)
			$display("TEST 7: OR test passed");
		else
			$display("TEST 7: OR test failed");


		#10		
		$display ("TEST CASE 8: NAND test");

		a_tb = 16'b1010;
		b_tb = 16'b0001;
		alu_fun_tb = 4'b0110;
		#10
		
		if(alu_out_tb == 16'hFFFF && logic_tb == 1'b1)
			$display("TEST 8: NAND test passed");
		else
			$display("TEST 8: NAND test failed");


		#10		
		$display ("TEST CASE 9: NOR test");

		a_tb = 16'b1010;
		b_tb = 16'b0001;
		alu_fun_tb = 4'b0111;
		#10
		
		if(alu_out_tb == 16'hFFF4 && logic_tb == 1'b1)
			$display("TEST 9: NOR test passed");
		else
			$display("TEST 9: NOR test failed");



		#10		
		$display ("TEST CASE 10: XOR test");

		a_tb = 16'b1010;
		b_tb = 16'b0110;
		alu_fun_tb = 4'b1000;
		#10
		
		if(alu_out_tb == 16'b1100 && logic_tb == 1'b1)
			$display("TEST 10: XOR test passed");
		else
			$display("TEST 10: XOR test failed");


		#10		
		$display ("TEST CASE 10: XNOR test");

		a_tb = 16'b1010;
		b_tb = 16'b0110;
		alu_fun_tb = 4'b1001;
		#10
		
		if(alu_out_tb == 16'hFFF3 && logic_tb == 1'b1)
			$display("TEST 10: XNOR test passed");
		else
			$display("TEST 10: XNOR test failed");


		#10		
		$display ("TEST CASE 11: Equal test, A equal to B ");

		a_tb = 16'b1010;
		b_tb = 16'b1010;
		alu_fun_tb = 4'b1010;
		#10
		
		if(alu_out_tb == 16'b1 && cmp_tb == 1'b1)
			$display("TEST 11: Equal test passed");
		else
			$display("TEST 11: Equal test failed");


		#10		
		$display ("TEST CASE 11: Equal test, A not equal to B");

		a_tb = 16'b1010;
		b_tb = 16'b1011;
		alu_fun_tb = 4'b1010;
		#10
		
		if(alu_out_tb == 16'b0 && cmp_tb == 1'b1)
			$display("TEST 11: Not equal test passed");
		else
			$display("TEST 11: Not equal test failed");


		#10		
		$display ("TEST CASE 12: Testing a > b");

		a_tb = 16'b1111;
		b_tb = 16'b1011;
		alu_fun_tb = 4'b1011;
		#10
		
		if(alu_out_tb == 16'b10 && cmp_tb == 1'b1)
			$display("TEST 12: Test passed");
		else
			$display("TEST 12: Test failed");


		#10		
		$display ("TEST CASE 13: Testing a < b");

		a_tb = 16'd11;
		b_tb = 16'd15;
		alu_fun_tb = 4'b1100;
		#10
		
		if(alu_out_tb == 16'b11 && cmp_tb == 1'b1)
			$display("TEST 13: Test passed");
		else
			$display("TEST 13: Test failed");


		#10		
		$display ("TEST CASE 14: Testing >>");

		a_tb = 16'b0101;
		alu_fun_tb = 4'b1101;
		#10
		
		if(alu_out_tb == 16'b0010 && shift_tb == 1'b1)
			$display("TEST 14: Test passed");
		else
			$display("TEST 14: Test failed");


		#10		
		$display ("TEST CASE 15: Testing <<");

		a_tb = 16'b0000000000001111;
		alu_fun_tb = 4'b1110;
		#10
		
		if(alu_out_tb == 16'b0000000000011110 && shift_tb == 1'b1)
			$display("TEST 15: Test passed");
		else
			$display("TEST 15: Test failed");

        #10;
        $display("TEST CASE 16: NOP/default test");

        a_tb       = 16'd10;
        b_tb       = 16'd5;
        alu_fun_tb = 4'b1111;

        #10;

        if(alu_out_tb == 16'd0 &&
           carry_tb == 1'b0 &&
           arith_tb == 1'b0 &&
           logic_tb == 1'b0 &&
           cmp_tb == 1'b0 &&
           shift_tb == 1'b0)

            $display("TEST 16: NOP/default test passed");
        else
            $display("TEST 16: NOP/default test failed");


		#20
		$finish;

	end

	// clock generator
	always #5 clk_tb = ~clk_tb;


	
	// design instantiation
	ALU DUT (
		.a(a_tb),
		.b(b_tb),
		.alu_fun(alu_fun_tb),
		.clk(clk_tb),
		.alu_out(alu_out_tb),
		.carry_flag(carry_tb),
		.arith_flag(arith_tb),
		.logic_flag(logic_tb),
		.cmp_flag(cmp_tb),
		.shift_flag(shift_tb)
	);

endmodule


