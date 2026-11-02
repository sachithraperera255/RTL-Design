module edge_bit_counter
	(
    	input wire        clk,
    	input wire        rst,
    	input wire        enable,
    	input wire        data_phase,
    	input wire [5:0]  Prescale,

    	output reg [4:0]  edge_cnt,
    	output reg [2:0]  bit_cnt,

    	output reg       bit_done,
    	output reg       last_data_bit
	);

    	// Check whether Prescale is supported
    	wire valid_prescale;

    	assign valid_prescale =
           	(Prescale == 6'd4)  ||
           	(Prescale == 6'd8)  ||
           	(Prescale == 6'd16) ||
           	(Prescale == 6'd32);


    	// Indicate the final RX clock position
    	// within the current UART bit period
    	assign bit_done = enable && valid_prescale && (edge_cnt == Prescale - 6'd1);


    	// Indicate completion of the eighth DATA bit
    	assign last_data_bit = bit_done && data_phase && (bit_cnt == 3'd7);


    	// Edge and bit counters
    	always @(posedge clk or negedge rst)
    	begin

        	if(!rst)
        	begin
            	edge_cnt <= 5'd0;
            	bit_cnt  <= 3'd0;
        	end

        	else if(!enable || !valid_prescale)
        	begin
            	edge_cnt <= 5'd0;
            	bit_cnt  <= 3'd0;
        	end

        	else if(bit_done)
        	begin
            	// Begin a new bit period
            	edge_cnt <= 5'd0;

            	// Increment bit counter only in DATA phase
            	if(data_phase)
            	begin
                	if(bit_cnt == 3'd7)
                    	bit_cnt <= 3'd0;
                	else
                   		bit_cnt <= bit_cnt + 1'b1;
            	end
        	end

        	else
        	begin
            	// Count receiver clock positions
            	edge_cnt <= edge_cnt + 1'b1;
        	end

    	end

endmodule

