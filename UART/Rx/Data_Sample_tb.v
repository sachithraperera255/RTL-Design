
`timescale 1ns/1ps

module data_sample_tb();

    // Testbench inputs
    reg         rx_in_tb;
    reg [5:0]   prescale_tb;
    reg [4:0]   edge_cnt_tb;
    reg         clk_tb;
    reg         rst_tb;
    reg         data_sample_en_tb;

    // DUT output
    wire        sample_bit_tb;

    // Test counters
    integer test_count = 0;
    integer fail_count = 0;

    // Expected values
    wire [4:0] expected_mid_point;

    reg expected_sample_one;
    reg expected_sample_two;
    reg expected_sample_bit;

    assign expected_mid_point = prescale_tb >> 1;



    // Initialize all signals
    task initialize;
    begin
        rx_in_tb            = 1'b0;
        prescale_tb         = 6'd0;
        edge_cnt_tb         = 5'd0;
        clk_tb              = 1'b1;
        rst_tb              = 1'b1;
        data_sample_en_tb   = 1'b0;

        expected_sample_one = 1'b0;
        expected_sample_two = 1'b0;
        expected_sample_bit = 1'b0;
    end
    endtask


    // Compare actual and expected outputs
    task check_sample;
    begin

        test_count = test_count + 1;

        if (sample_bit_tb === expected_sample_bit)
        begin
            $display("PASS: Prescale=%0d Edge=%0d Expected=%b Actual=%b",
                     prescale_tb, edge_cnt_tb,
                     expected_sample_bit, sample_bit_tb);
        end
        else
        begin
            fail_count = fail_count + 1;

            $display("FAIL: Prescale=%0d Edge=%0d Expected=%b Actual=%b",
                     prescale_tb, edge_cnt_tb,
                     expected_sample_bit, sample_bit_tb);
        end

    end
    endtask


    // Asynchronous active-low reset
    task reset;
    begin

        @(negedge clk_tb);
        rst_tb = 1'b0;

        expected_sample_one = 1'b0;
        expected_sample_two = 1'b0;
        expected_sample_bit = 1'b0;

        // Check reset before the next rising edge
        #0.1;
        check_sample();

        repeat(2) @(negedge clk_tb);
        rst_tb = 1'b1;

    end
    endtask


    // Calculate expected sampling behavior
    task update_expected_sample;
    begin

        if (!rst_tb)
        begin
            expected_sample_one = 1'b0;
            expected_sample_two = 1'b0;
            expected_sample_bit = 1'b0;
        end

        else if (data_sample_en_tb)
        begin

            // 4x oversampling
            if (prescale_tb == 6'd4)
            begin
                if (edge_cnt_tb == expected_mid_point)
                begin
                    expected_sample_bit = rx_in_tb;
                end
            end

            // 8x, 16x and 32x oversampling
            else
            begin

                if (edge_cnt_tb == expected_mid_point - 5'd1)
                begin
                    expected_sample_one = rx_in_tb;
                end

                if (edge_cnt_tb == expected_mid_point)
                begin
                    expected_sample_two = rx_in_tb;
                end

                if (edge_cnt_tb == expected_mid_point + 5'd1)
                begin

                    // Equivalent majority-voting rule:
                    // If first two agree, use their value.
                    // Otherwise, use the third sample.

                    if (expected_sample_one == expected_sample_two)
                        expected_sample_bit = expected_sample_one;
                    else
                        expected_sample_bit = rx_in_tb;

                end

            end

        end

        else
        begin
            expected_sample_one = 1'b0;
            expected_sample_two = 1'b0;
            // sampled bit retains its value
        end

    end
    endtask


    // Apply inputs for one RX clock cycle
    task drive_sample;

        input [5:0] prescale_value;
        input [4:0] edge_value;
        input       rx_value;
        input       enable_value;

    begin

        @(negedge clk_tb);

        prescale_tb       = prescale_value;
        edge_cnt_tb       = edge_value;
        rx_in_tb          = rx_value;
        data_sample_en_tb = enable_value;

        @(posedge clk_tb);

        // Update testbench reference model
        update_expected_sample();

        // Wait for DUT nonblocking assignments
        #1;

        check_sample();

    end
    endtask


    // Test one complete UART bit period
    task test_config;

        input [5:0] selected_prescale;
        input [2:0] samples;

        integer i;
        reg incoming_bit;
        reg expected_final;

    begin

        $display("\nTesting Prescale = %0d, Samples = %b",
                 selected_prescale, samples);

        // samples[2] = first sample
        // samples[1] = second sample
        // samples[0] = third sample

        for (i = 0; i < selected_prescale; i = i + 1)
        begin

            incoming_bit = 1'b0;

            if (i == (selected_prescale / 2) - 1)
                incoming_bit = samples[2];

            else if (i == (selected_prescale / 2))
                incoming_bit = samples[1];

            else if (i == (selected_prescale / 2) + 1)
                incoming_bit = samples[0];

            drive_sample(
                selected_prescale,
                i[4:0],
                incoming_bit,
                1'b1
            );

        end

        // Independently check the final decision
        if (selected_prescale == 6'd4)
        begin
            expected_final = samples[1];
        end
        else
        begin
            expected_final =
                (samples[2] & samples[1]) |
                (samples[2] & samples[0]) |
                (samples[1] & samples[0]);
        end

        test_count = test_count + 1;

        if (sample_bit_tb === expected_final)
            $display("PASS: Final sampled bit = %b", sample_bit_tb);
        else
        begin
            fail_count = fail_count + 1;
            $display("FAIL: Final expected=%b Actual=%b",
                     expected_final, sample_bit_tb);
        end

    end
    endtask


    // Main test sequence
    initial
    begin

        $dumpfile("Data_Sample.vcd");
        $dumpvars(0, data_sample_tb);

        initialize();

        // TEST 01: Reset
        $display("\nTEST 01: Asynchronous reset");
        reset();


        // TEST 02: 4x single sampling
        $display("\nTEST 02: Prescale 4");

        test_config(6'd4, 3'b010);
        test_config(6'd4, 3'b000);


        // TEST 03: 8x majority voting
        $display("\nTEST 03: Prescale 8");

        test_config(6'd8, 3'b101);
        test_config(6'd8, 3'b010);
        test_config(6'd8, 3'b111);
        test_config(6'd8, 3'b000);


        // TEST 04: 16x majority voting
        $display("\nTEST 04: Prescale 16");

        test_config(6'd16, 3'b011);
        test_config(6'd16, 3'b100);


        // TEST 05: 32x majority voting
        $display("\nTEST 05: Prescale 32");

        test_config(6'd32, 3'b110);
        test_config(6'd32, 3'b001);


        // TEST 06: Sampling disabled
        $display("\nTEST 06: Sampling disabled");

        // First produce a sampled value of 1
        test_config(6'd8, 3'b101);

        // Disable sampling with RX_IN = 0
        // The output should remain 1
        drive_sample(6'd8, 5'd4, 1'b0, 1'b0);
        drive_sample(6'd8, 5'd5, 1'b0, 1'b0);


        // TEST 07: Reset during operation
        $display("\nTEST 07: Reset during operation");

        test_config(6'd8, 3'b101);
        reset();

        // Verify receiver can sample again
        test_config(6'd8, 3'b010);


        // Final report
        $display("\n================================");
        $display("DATA SAMPLE TEST RESULTS");
        $display("================================");

        $display("Total checks : %0d", test_count);
        $display("Failed checks: %0d", fail_count);

        if (fail_count == 0)
            $display("ALL TESTS PASSED");
        else
            $fatal(1, "Data sampling verification failed");

        $finish;

    end

    always #2.5 clk_tb = ~clk_tb;

    // DUT Instantiation
    data_sample DUT
    (
        .rx_in          (rx_in_tb),
        .prescale       (prescale_tb),
        .edge_cnt       (edge_cnt_tb),
        .clk            (clk_tb),
        .rst            (rst_tb),
        .data_sample_en (data_sample_en_tb),
        .sample_bit     (sample_bit_tb)
    );


endmodule
