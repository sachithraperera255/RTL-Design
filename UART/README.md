# UART (Work in Progress)

This project is being developed module by module. It is incomplete, and this snapshot is an early development checkpoint.

## Current Progress

- [Serializer](Tx/Serializer.v): captures an 8-bit input and serializes it least significant bit first over eight clock cycles. It provides a serialization enable input, a completion output, and an asynchronous active-low reset.
- [Parity calculator](Tx/ParityCalc.v): calculates and stores the parity bit for an 8-bit input when enabled, with selectable even or odd parity and an asynchronous active-low reset.
- [Serializer testbench](Tx/Serializer_tb.v): checks input capture, each serialized bit, and completion for `8'd10`, `8'h7D`, `8'hFF`, and `8'hE2`.

## Parity Calculator

`ParityCalc` computes `parity_bit <= (^data) ^ parity_type` on the rising edge of `clk` when `parity_calc_en` is high.

| Input | Behavior |
| --- | --- |
| `data[7:0]` | Eight data bits used to calculate parity. |
| `parity_calc_en` | Enables an update on the rising clock edge; when low, the previous parity bit is retained. |
| `parity_type` | `0` selects even parity; `1` selects odd parity. |
| `rst` | Asynchronous active-low reset that clears `parity_bit` to `0`. |

For example, `8'h7D` contains six set bits, so its parity bit is `0` for even parity and `1` for odd parity. Reset clears the output regardless of the selected parity mode.

The module compiles successfully with ModelSim Intel FPGA Edition 2020.1 with zero errors and zero warnings. A dedicated parity testbench and functional simulation remain to be added.

## Serializer Simulation Waveform

The saved waveform below shows the serializer processing `8'b00001010` (decimal 10). After the enable pulse, `serial_data_tb` outputs the bits least significant bit first, and `serial_done_tb` asserts when the eighth bit is serialized.

![UART serializer simulation waveform for input value 10](Tx/serializer_waveform.png)

## Serializer Test Transcript

The saved transcript below shows successful input capture, matching output for all eight bits (0 through 7), and a passing `serial_done` check for input value 10. The current testbench also includes the additional input values listed above.

![UART serializer test transcript showing all eight bit checks and the completion check passing](Tx/serializer_test_transcript.png)

## Remaining Work

- Add a parity calculator testbench covering even and odd parity, enable/hold behavior, and reset.
- Complete the UART transmitter, including baud timing, frame control, and integration of the serializer and parity calculator.
- Expand testbenches and verify the UART behavior as each component is completed.

The serializer and parity calculator are building blocks for a UART transmitter. The included waveform and test transcript cover the serializer; parity simulation and verification of a complete UART transmitter remain future work.

Further components and verification results will be added as the project progresses.
