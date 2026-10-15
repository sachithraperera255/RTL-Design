# UART (Work in Progress)

This project is being developed piece by piece. It is incomplete, and this snapshot is an early development checkpoint.

## Current Progress

- `Tx/Serializer.v`: captures an 8-bit input and serializes it least significant bit first over eight clock cycles.
- Provides a serialization enable input, a completion output, and an asynchronous active-low reset.

## Remaining Work

- Complete the UART transmitter, including baud timing and frame control.
- Add testbenches and verify the UART behavior as each component is completed.

The serializer alone is not a complete UART transmitter. No UART testbench is included in this snapshot, and its behavior has not been verified as part of this upload.

Further components and verification results will be added as the project progresses.
