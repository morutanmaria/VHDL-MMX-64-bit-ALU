Project Overview

This project implements a simplified MMX (MultiMedia eXtension) Arithmetic Logic Unit in VHDL, targeting the Basys 3 FPGA (Artix-7) development board. The MMX ALU is designed to perform SIMD (Single Instruction, Multiple Data) operations, enabling multiple parallel arithmetic operations on packed integer data — a key feature for multimedia processing, such as image, audio, and video applications.

The ALU supports a subset of MMX instructions, including PADD, PSUB, PMUL, PINC, PDEC, and PAVG, and provides mechanisms for control, status flags, and busy signals for multi-cycle operations like multiplication.
Features

Supported Operations:

PADD (Packed Add): Parallel addition of multiple subword elements (bytes, words, doublewords).

PSUB (Packed Subtract): Parallel subtraction on multiple subword elements.

PMUL (Packed Multiply): Parallel multiplication on packed integers.

PINC (Packed Increment): Increment multiple elements in parallel.

PDEC (Packed Decrement): Decrement multiple elements in parallel.

PAVG (Packed Average): Compute the average of corresponding elements in parallel.

Data Width: 64-bit MMX registers supporting SIMD-style computation.

Control Signals: DONE flag, PMUL_BUSY signal, CARRY and UNDERFLOW flags for arithmetic checks.

User Interface: Basys 3 switches for opcode selection, buttons for step-through ROM address selection, and 7-segment displays for result viewing.
Design Components

MMX ALU: Core VHDL module implementing arithmetic operations.

ROM Module: Holds input data vectors for testing and demonstration.

Debouncer Module: Ensures clean button inputs for stepping through ROM addresses.

SSD (Seven-Segment Display) Driver: Displays selected portions of the ALU result.

Top-Level Basys Integration: Connects ALU, ROM, debouncer, and display modules for full FPGA implementation.
Requirements

FPGA Board: Basys 3 (Artix-7)

Software: Xilinx Vivado 2023.x

Hardware Description Language: VHDL
Getting Started

Clone the Repository:

git clone https://github.com/<your-username>/mmx_alu.git

Open the Project in Vivado:

Create a new Vivado project targeting the Basys 3 FPGA.

Add all VHDL source files: mmx_alu.vhd, mmx_basys.vhd, mmx_rom.vhd, debouncer.vhd, ssd.vhd.

Synthesize and Implement:

Run synthesis, implementation, and generate bitstream.

Connect Basys 3 board via USB and program the FPGA.

Operating the System:

Use switches SW[15:13] to select the ALU opcode.

Press the step button (BTN) to load the next ROM data vector.

View the selected 16-bit portion of the result on the 7-segment display (SW[1:0]).

LEDs indicate ALU status: busy, done, or current ROM address.
Testing and Validation

Edge Cases Tested:

Addition with carry: FF + 01

Subtraction underflow: 00 - 01

Multiplication maximum: FF * FF = FE01

Average with rounding

Increment/decrement at boundaries: 00 → FF, FF → 00

Expected Behavior:

ALU produces correct packed SIMD results per operation.

PMUL_BUSY signals active during multi-cycle multiplication.

CARRY_OUT and UNDERFLOW_OUT accurately reflect arithmetic overflows/underflows.
