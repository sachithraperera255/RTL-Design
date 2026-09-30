module ALU (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire [3:0]  alu_fun,
    input  wire        clk,

    output reg  [15:0] alu_out,
    output reg         carry_flag,
    output reg         arith_flag,
    output reg         logic_flag,
    output reg         cmp_flag,
    output reg         shift_flag
);

    reg [15:0] NextAlu;


    // Registered ALU output
    always @(posedge clk)
    begin
        alu_out <= NextAlu;
    end


    // Combinational ALU logic
    always @(*)
    begin

        // Default values
        NextAlu    = 16'b0;
        carry_flag = 1'b0;
        arith_flag = 1'b0;
        logic_flag = 1'b0;
        cmp_flag   = 1'b0;
        shift_flag = 1'b0;


        case (alu_fun)

            // --------------------------------
            // Arithmetic Operations
            // --------------------------------

            // Addition
            4'b0000:
            begin
                {carry_flag, NextAlu} =
                    {1'b0, a} + {1'b0, b};

                arith_flag = 1'b1;
            end


            // Subtraction
            4'b0001:
            begin
                NextAlu = a - b;

                // Borrow occurs when A < B
                if (a < b)
                    carry_flag = 1'b1;
                else
                    carry_flag = 1'b0;

                arith_flag = 1'b1;
            end


            // Multiplication
            4'b0010:
            begin
                NextAlu = a * b;
                arith_flag = 1'b1;
            end


            // Division
            4'b0011:
            begin
                NextAlu = a / b;
                arith_flag = 1'b1;
            end


            // --------------------------------
            // Logic Operations
            // --------------------------------

            // AND
            4'b0100:
            begin
                NextAlu = a & b;
                logic_flag = 1'b1;
            end


            // OR
            4'b0101:
            begin
                NextAlu = a | b;
                logic_flag = 1'b1;
            end


            // NAND
            4'b0110:
            begin
                NextAlu = ~(a & b);
                logic_flag = 1'b1;
            end


            // NOR
            4'b0111:
            begin
                NextAlu = ~(a | b);
                logic_flag = 1'b1;
            end


            // XOR
            4'b1000:
            begin
                NextAlu = a ^ b;
                logic_flag = 1'b1;
            end


            // XNOR
            4'b1001:
            begin
                NextAlu = ~(a ^ b);
                logic_flag = 1'b1;
            end


            // --------------------------------
            // Comparison Operations
            // --------------------------------

            // A == B
            4'b1010:
            begin
                cmp_flag = 1'b1;

                if (a == b)
                    NextAlu = 16'd1;
                else
                    NextAlu = 16'd0;
            end


            // A > B
            4'b1011:
            begin
                cmp_flag = 1'b1;

                if (a > b)
                    NextAlu = 16'd2;
                else
                    NextAlu = 16'd0;
            end


            // A < B
            4'b1100:
            begin
                cmp_flag = 1'b1;

                if (a < b)
                    NextAlu = 16'd3;
                else
                    NextAlu = 16'd0;
            end


            // --------------------------------
            // Shift Operations
            // --------------------------------

            // Shift A right by 1
            4'b1101:
            begin
                NextAlu = a >> 1;
                shift_flag = 1'b1;
            end


            // Shift A left by 1
            4'b1110:
            begin
                NextAlu = a << 1;
                shift_flag = 1'b1;
            end


            // --------------------------------
            // Default / NOP
            // --------------------------------

            default:
            begin
                NextAlu    = 16'b0;
                carry_flag = 1'b0;
                arith_flag = 1'b0;
                logic_flag = 1'b0;
                cmp_flag   = 1'b0;
                shift_flag = 1'b0;
            end

        endcase
    end

endmodule