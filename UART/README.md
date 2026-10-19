# UART (Work in Progress)

This project is being developed module by module. It is incomplete, and this snapshot is an early development checkpoint.

## Current Progress

- [Serializer](Tx/Serializer.v): captures an 8-bit input and serializes it least significant bit first over eight clock cycles. It provides a serialization enable input, a completion output, and an asynchronous active-low reset.
- [Parity calculator](Tx/ParityCalc.v): calculates and stores the parity bit for an 8-bit input when enabled, with selectable even or odd parity and an asynchronous active-low reset.
- [Serializer testbench](Tx/Serializer_tb.v): checks input capture, each serialized bit, and completion for `8'd10`, `8'h7D`, `8'hFF`, and `8'hE2`.
- [Parity calculator testbench](Tx/ParityCalc_tb.v): checks all four combinations of even/odd set-bit counts and even/odd parity using `8'b01100100` (100) and `8'b01100101` (101), plus output retention when the calculation enable is low.

## Parity Calculator

`ParityCalc` computes `parity_bit <= (^data) ^ parity_type` on the rising edge of `clk` when `parity_calc_en` is high.

| Input | Behavior |
| --- | --- |
| `data[7:0]` | Eight data bits used to calculate parity. |
| `parity_calc_en` | Enables an update on the rising clock edge; when low, the previous parity bit is retained. |
| `parity_type` | `0` selects even parity; `1` selects odd parity. |
| `rst` | Asynchronous active-low reset that clears `parity_bit` to `0`. |

For example, `8'h7D` contains six set bits, so its parity bit is `0` for even parity and `1` for odd parity. Reset clears the output regardless of the selected parity mode.

The parity calculator, serializer, and their testbenches compile successfully with ModelSim Intel FPGA Edition 2020.1 with zero errors and zero warnings. Functional simulation passes all five parity checks (four parity calculations and one output retention check while disabled) and all four serializer frames, including 32 serialized-bit checks and four completion checks.

## Serializer Simulation Waveform

The saved waveform below shows the serializer processing `8'b00001010` (decimal 10). After the enable pulse, `serial_data_tb` outputs the bits least significant bit first, and `serial_done_tb` asserts when the eighth bit is serialized.

![UART serializer simulation waveform for input value 10](Tx/serializer_waveform.png)

## Serializer Test Transcript

The saved transcript below shows successful input capture, matching output for all eight bits (0 through 7), and a passing `serial_done` check for input value 10. The current testbench also includes the additional input values listed above.

![UART serializer test transcript showing all eight bit checks and the completion check passing](Tx/serializer_test_transcript.png)

## Parity Calculator Simulation Waveform

The saved waveform shows the active-low reset clearing `parity_bit_tb`, followed by parity calculations for inputs 100 and 101. Each input is tested with odd parity and then even parity while `parity_calc_en_tb` is high. The final test changes the data to `8'b00000000` and selects odd parity while disabling calculation; the output retains its previous value of `0`, although the new inputs would produce `1` if enabled.

| Test | Data | Set-bit count | Parity mode | Expected parity bit | Result |
| --- | --- | --- | --- | --- | --- |
| 01 | `8'b01100100` (100) | 3 (odd) | Odd (`1`) | `0` | Passed |
| 02 | `8'b01100100` (100) | 3 (odd) | Even (`0`) | `1` | Passed |
| 03 | `8'b01100101` (101) | 4 (even) | Odd (`1`) | `1` | Passed |
| 04 | `8'b01100101` (101) | 4 (even) | Even (`0`) | `0` | Passed |
| 05 | `8'b00000000` (0) | 0 (even) | Odd (`1`), calculation disabled | `0` (retained) | Passed |

![UART parity calculator waveform showing reset, all four even/odd parity combinations, and disabled output retention](Tx/ParityCalc_waveform.png)

## Parity Calculator Test Transcript

The saved transcript shows all five checks passing: the four parity calculations produce `0`, `1`, `1`, and `0`, and Test 05 confirms that the output holds `0` when `parity_calc_en_tb` is low. The Test 04 description in the saved transcript says "odd parity"; its `parity_type_tb = 0` stimulus and expected output test even parity, as listed above.

![UART parity calculator test transcript showing all five parity and hold checks passing](Tx/ParityCalc_transcript.png)

The testbench applies reset during initialization. Output retention of `0` while disabled is now checked explicitly. Dedicated assertions for reset behavior and retention of `1` remain to be added.

## Remaining Work

- Complete the UART transmitter, including baud timing, frame control, and integration of the serializer and parity calculator.
- Expand testbenches and verify the UART behavior as each component is completed.

The serializer and parity calculator are building blocks for a UART transmitter. The included waveforms and test transcripts document their current module-level checks; integration and verification of a complete UART transmitter remain future work.

Further components and verification results will be added as the project progresses.
