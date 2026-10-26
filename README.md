# RTL Design

Verilog RTL design examples covering digital logic, counters, ALU design, register-based storage, and finite-state machines.

## Included Designs

- Basic digital circuit implementations.
- Combinational and sequential logic modules.
- 4-bit counter design with testbench.
- 5-bit up/down counter design with testbench.
- 16-bit ALU design with testbench.
- Modular 16-bit ALU with arithmetic, logic, comparison, shift, and decoder units.
- 8-entry, 16-bit register module with read/write enable controls.
- Mealy finite-state machine digital lock that recognizes the `01011` input sequence, with a testbench.
- Mealy finite-state machine garage door controller with open and closed limit switches.
- Programmable integer clock divider with an enable and active-low reset.
- UART transmitter with a `TOP_Tx` top level connecting the serializer, parity calculator, transmit FSM, and output multiplexer. The integrated RTL compiles with zero errors and warnings; all four component modules have testbenches with saved waveform and transcript PNGs. Full-frame verification, baud timing, and generalized serializer widths remain in progress. See [UART status](UART/README.md).

## Repository Contents

The repository tracks Verilog source files, testbenches, and supporting design documents. Saved waveform and test transcript PNGs are included in the documentation. Simulator working directories, raw waveform files, raw transcripts, backup files, and local project metadata are ignored.
