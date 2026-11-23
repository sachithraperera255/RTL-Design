module FSM_RX
    (
        input wire           rx_in,
        input wire           parity_en,
        input wire           parity_error,
        input wire           start_error,
        input wire           stop_error,
        input wire [2:0]     bit_count,
        input wire           bit_done,
        input wire [4:0]     edge_count,
        input wire           last_data_bit,
        input wire           clk,
        input wire           rst,
        input wire [5:0]     prescale,

        output reg         parity_check_en,
        output reg         start_check_en,
        output reg         stop_check_en,
        output reg         data_valid,
        output reg         deserializer_en,
        output reg         data_phase,
        output reg         bit_count_en,
        output reg         data_sample_en
    );

    localparam [2:0] IDLE   = 3'b000,
                     START  = 3'b001,
                     DATA   = 3'b010,
                     PARITY = 3'b011,
                     STOP   = 3'b111;

    reg [2:0] next_state, current_state;
    wire [4:0] mid_position;
    reg check_pending_4x;

    assign mid_position = (prescale == 6'd4) ? 5'd3 : ((prescale >> 1) + 6'd2);

    /*
    6'd2 is added to the mid_position calculation becuase the is sampled in data_sample module
    using majority vote. The module sample mid data point, left and right to the mid poit
    adding two allow sample_bit to settle in the module before START state compare the values

    if prescale is 4, the mid point is 3
    */

    always @(posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            current_state <= IDLE;
        end
        else
        begin
            current_state <= next_state;

            check_pending_4x <= (prescale == 6'd4) && bit_done && ((current_state == START) || (current_state == STOP));
        end
    end

    always @(*)
    begin

        next_state = current_state;

        parity_check_en    = 1'b0;
        start_check_en     = 1'b0;
        stop_check_en      = 1'b0;
        data_valid         = 1'b0;
        deserializer_en    = 1'b0;
        data_phase         = 1'b0;
        bit_count_en       = 1'b0;
        data_sample_en     = 1'b0;

        case (current_state)
            IDLE:
            begin

                if(check_pending_4x)
                begin
                    if(!stop_error && (!parity_en || !parity_error))
                    begin
                        data_valid = 1'b1;
                    end
                end
                if(!rx_in) // rx_in is LOW here because start bit of the sequence is LOW
                begin
                    next_state  = START;
                end
                else
                begin
                    next_state = IDLE;
                end
            end
            START:
            begin
                bit_count_en    = 1'b1;
                data_sample_en  = 1'b1;

                if(edge_count == mid_position)
                begin
                    start_check_en = 1'b1;
                end
                if(prescale == 6'd4)
                begin
                    // Wait for registered START result.
                    // Counter continues running.
                    if(check_pending_4x)
                    begin
                        if(!start_error)
                            next_state = DATA;
                        else
                            next_state = IDLE;
                    end
                end
                else if (bit_done)
                begin
                    if(!start_error)
                    begin
                        next_state = DATA;
                    end
                    else
                    begin
                        next_state = IDLE;
                    end
                end
            end
            DATA:
            begin
                bit_count_en    = 1'b1;
                data_sample_en  = 1'b1;
                data_phase      = 1'b1;

                if (bit_done)
                begin
                    deserializer_en = 1'b1;
                end

                if(last_data_bit)
                begin
                    if (parity_en)
                    begin
                        next_state = PARITY;
                    end
                    else
                    begin
                        next_state = STOP;
                    end
                end
            end
            PARITY:
            begin
                bit_count_en    = 1'b1;
                data_sample_en  = 1'b1;

                if (edge_count == mid_position)
                begin
                    parity_check_en = 1'b1;
                end

                if (bit_done)
                begin
                    next_state = STOP;
                end
            end
            STOP:
            begin
                bit_count_en    = 1'b1;
                data_sample_en  = 1'b1;

                if (edge_count == mid_position)
                begin
                    stop_check_en  = 1'b1;
                end

                if(bit_done)
                begin
                    // 8x, 16x and 32x
                    if(prescale != 6'd4)
                    begin
                        if(!stop_error && (!parity_en || !parity_error))
                        begin
                            data_valid = 1'b1;
                        end
                    end

                    // For 4x, validation happens in IDLE
                    next_state = IDLE;
                end
            end
            default:
                next_state = IDLE;
        endcase
    end

endmodule
