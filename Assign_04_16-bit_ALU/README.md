# 16-bits ALU Test Plan

ALU testbench drives only the input of TOP_ALU and monitors its top-level output. The internal functional units are verified indirectly through the integrated top-level design.

Units of the TOP_ALU:

- ARITHMETIC_UNIT
- LOGIC_UNIT
- CMP_UNIT
- SHIFT_UNIT

Following sections describe test cases for each ALU function that is mentioned above.

## ARITHMETIC_UNIT

| # of Tests | ALU_FUN | Operation | Input of A | Input of B | Expected TOP_ALU_out | Arith_flag |
| --- | --- | --- | --- | --- | --- | --- |
|  | 0000 | ADD + + | 16'sd10 | 16'sd20 | 32'sd30 | 1'b1 |
|  | 0000 | ADD + - | 16'sd10 | -16'sd4 | 32'sd6 | 1'b1 |
|  | 0000 | ADD - + | -16'sd20 | 16'sd10 | -32'sd10 | 1'b1 |
|  | 0000 | ADD - - | -16'sd10 | -16'sd10 | -32'sd20 | 1'b1 |
|  | 0001 | SUB + + | 16'sd10 | 16'sd4 | 32'sd6 | 1'b1 |
|  | 0001 | SUB + - | 16'sd10 | -16'sd4 | 32'sd14 | 1'b1 |
|  | 0001 | SUB - + | -16'sd10 | 16'sd10 | -32'sd20 | 1'b1 |
|  | 0001 | SUB - - | -16'sd10 | -16'sd5 | -32'sd5 | 1'b1 |
|  | 0010 | MUL + + | 16'sd2 | 16'sd2 | 32'sd4 | 1'b1 |
|  | 0010 | MUL + - | 16'sd5 | -16'sd2 | -32'sd10 | 1'b1 |
|  | 0010 | MUL - + | -16'sd2 | 16'sd3 | -32'sd6 | 1'b1 |
|  | 0010 | MUL - - | -16'sd5 | -16'sd5 | 32'sd25 | 1'b1 |
|  | 0011 | DIV + + | 16'sd8 | 16'sd2 | 32'sd4 | 1'b1 |
|  | 0011 | DIV + - | 16'sd10 | -16'sd2 | -32'sd5 | 1'b1 |
|  | 0011 | DIV - + | -16'sd20 | 16'sd10 | -32'sd2 | 1'b1 |
|  | 0011 | DIV - - | -16'sd4 | -16'sd2 | 32sd2 | 1'b1 |

## LOGIC_UNIT

| # of Tests | ALU_FUN | Operation | Input of A | Input of B | Expected TOP_ALU_out | Logic_flag |
| --- | --- | --- | --- | --- | --- | --- |
|  | 0100 | AND | 16'h00F3 | 16'h0F0F | 16'h0003 | 1'b1 |
|  | 0101 | OR | 16'h00F3 | 16'h0F0F | 16'h0FFF | 1'b1 |
|  | 0110 | NAND | 16'h00F3 | 16'h0F0F | 16'hFFFC | 1'b1 |
|  | 0111 | NOR | 16'h00F3 | 16'h0F0F | 16'F000 | 1'b1 |

## CMP_UNIT

| # of Tests | ALU_FUN | Operation | Input of A | Input of B | Expected TOP_ALU_out | CMP_flag |
| --- | --- | --- | --- | --- | --- | --- |
| 21. | 1000 | NOP | - | - | 2'b00 | 1'b1 |
| 22. | 1001 | = | 16'd10 | 16'd10 | 2'b01 else 2'b00 | 1'b1 |
| 23. | 1010 | > | 16'd10 | 16'd8 | 2'b10 else 2'b00 | 1'b1 |
| 24. | 1011 | < | 16'd5 | 16'd10 | 2'b11 else 2'b00 | 1'b1 |

## SHIFT_UNIT

| # of Tests | ALU_FUN | Operation | Input of A | Input of B | Expected TOP_ALU_out | Shift_flag |
| --- | --- | --- | --- | --- | --- | --- |
| 25. | 1100 | >> | 16'b0110 | - | 16'b0011 | 1'b1 |
| 26. | 1101 | << | 16'b0011 | - | 16'b0110 | 1'b1 |
| 27. | 1110 | >> | - | 16'b1100 | 16'b0011 | 1'b1 |
| 28. | 1111 | << | - | 16'b0011 | 16'b0110 | 1'b1 |
