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
- Fixed 8-bit UART transmitter with a `TOP_Tx` top level connecting the serializer, parity calculator, transmit FSM, and output multiplexer. The integrated RTL and top-level testbench compile with zero errors and warnings. All 36 top-level checks pass across three complete frames (parity disabled, odd parity, and even parity) and a no-request idle test. The top-level testbench and all four component testbenches have saved waveform and transcript PNGs; the top-level transcript includes the 36-check pass summary. Baud timing and additional corner-case coverage remain in progress. See [UART status](UART/README.md).
- UART receiver timing, sampling, and deserialization blocks: an edge/bit counter with 28 passing checks and a data sampler with midpoint sampling at prescale 4 and three-sample majority voting at prescales 8, 16, and 32. The sampler has a dedicated testbench with 177 passing checks across all four supported prescales, reset, and disabled output retention, with saved waveform and result images. The 8-bit deserializer assembles sampled data bits LSB-first, with an asynchronous active-low reset and enable-controlled shifting; it compiles with zero errors and warnings, while functional verification remains pending. Full receiver integration remains pending. See [UART receiver progress](UART/README.md#receiver-deserializer).

## Repository Contents

The repository tracks Verilog source files, testbenches, and supporting design documents. Saved waveform and test transcript PNGs are included in the documentation. Simulator working directories, raw waveform files, raw transcripts, backup files, and local project metadata are ignored.
