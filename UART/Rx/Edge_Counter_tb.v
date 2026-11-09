`timescale 1ns/1ps

module edge_bit_counter_tb();

    reg			clk_tb;
    reg			rst_tb;
    reg			enable_tb;
    reg			data_phase_tb;
    reg	[5:0]	prescale_tb;

    wire [4:0]	edge_cnt_tb;
    wire [2:0]	bit_cnt_tb;
    wire		bit_done_tb;
    wire		last_data_bit_tb;


    integer test_count	= 0;
    integer fail_count	= 0;
    integer	expected_edge = 0;

    reg expected_bit_done;



    task initialize;
    begin
        enable_tb 		= 1'b0;
        data_phase_tb 	= 1'b0;
        prescale_tb		= 6'd0;
        clk_tb			= 1'b1;
        rst_tb			= 1'b1;

    end
    endtask



    task reset;
    begin
        @(negedge clk_tb)
        rst_tb = 1'b0; // reset is active

        expected_edge = 0;

        repeat(2)@(negedge clk_tb);
        rst_tb = 1'b1; // reset is release
    end
    endtask

    // Validate the prescale input
    function valid_prescale_func;
        input [5:0]	val;
    begin

        valid_prescale_func = (	val == 	6'd4 || val	==	6'd8 || val	==	6'd16 || val ==	6'd32);

    end
    endfunction

    // Validate bit_done
    function bit_done_func;
        input 			enable;
        input [5:0] 	prescale_val;
        input integer	edge_cnt_val;
    begin

        bit_done_func = enable && valid_prescale_func(prescale_val) && (edge_cnt_val == prescale_val - 6'd1);

    end
    endfunction


    task update_expected_edge;
    begin

        if (!rst_tb || !enable_tb ||
            !valid_prescale_func(prescale_tb))
        begin
            expected_edge = 0;
        end
        else if (expected_edge == prescale_tb - 1)
        begin
            expected_edge = 0;
        end
        else
        begin
            expected_edge = expected_edge + 1;
        end

    end
    endtask




    task test_config;

        input         enable_config;
        input         data_phase_config;
        input [5:0]   prescale_config;
        input integer cycles;

        integer i;

    begin

        @(negedge clk_tb);

        enable_tb     = enable_config;
        data_phase_tb = data_phase_config;
        prescale_tb   = prescale_config;

        $display("Testing enable=%b, data_phase=%b, Prescale=%0d", enable_tb, data_phase_tb, prescale_tb);

        for (i = 0; i < cycles; i = i + 1)
        begin

            @(posedge clk_tb);

            // Calculate expected edge counter
            update_expected_edge();

            // Wait for DUT outputs to update
            #1;

            // Calculate expected bit_done
            expected_bit_done = bit_done_func(enable_tb, prescale_tb, expected_edge);

            test_count = test_count + 1;
            // Compare actual and expected outputs
            if (edge_cnt_tb === expected_edge[4:0] && bit_done_tb === expected_bit_done)
            begin
                $display("PASS: edge=%0d bit_done=%b",edge_cnt_tb, bit_done_tb);
            end
            else
            begin
                fail_count = fail_count + 1;
                $display("FAIL: Expected edge=%0d, bit_done=%b",expected_edge, expected_bit_done);
            end

        end

    end
    endtask



    initial
    begin

        $dumpfile("Edge_Counter.vcd");
        $dumpvars;

        initialize();

        reset();

        //test_config(enable_tb, data_phase_tb, prescale_tb);
        test_config(1'b0, 1'b0, 6'd0, 4);

        test_config(1'b1, 1'b0, 6'd4, 8);

        test_config(1'b1, 1'b0, 6'd8, 16);

        $display("=========================");
        $display("Total Tests  : %0d", test_count);
        $display("Failed Tests : %0d", fail_count);
        $display("=========================");

        if (fail_count != 0)
        begin
            $fatal(1, "Testbench Failed");
        end

        $finish;

    end

    always #2.5 clk_tb = ~clk_tb;



    edge_bit_counter DUT(
        .clk(clk_tb),
        .rst(rst_tb),
        .enable(enable_tb),
        .data_phase(data_phase_tb),
        .Prescale(prescale_tb),
        .edge_cnt(edge_cnt_tb),
        .bit_done(bit_done_tb),
        .bit_cnt(bit_cnt_tb),
        .last_data_bit(last_data_bit_tb)
    );


endmodule
