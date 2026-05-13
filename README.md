# Parameterized ALU RTL Design and Functional Verification

## Project Overview

This project implements and verifies a parameterized Arithmetic Logic Unit (ALU) using Verilog HDL.  
The ALU supports multiple arithmetic and logical operations, including signed arithmetic, comparison operations, shift/rotate functions, and multi-cycle multiplication.

The project mainly focuses on:

- RTL Design
- Functional Verification
- Self-checking Testbench Development
- Waveform Debugging
- Pipeline Timing Verification
- Coverage Analysis

Verification was performed using Mentor Graphics QuestaSim/ModelSim in a Linux environment.

---

# ALU Features

- Parameterized ALU architecture
- Configurable operand width (default = 8-bit)
- Arithmetic and logical operation support
- Signed and unsigned arithmetic
- Carry and overflow detection
- Comparison flag generation
- Shift and rotate operations
- Multi-cycle multiplication support
- Error handling for invalid commands and inputs
- Registered synchronous output stage

---

# Supported Operations

## Arithmetic Mode (`mode = 1`)

| CMD | Operation |
|-----|------------|
| 0 | Addition |
| 1 | Subtraction |
| 2 | Addition with Carry |
| 3 | Subtraction with Borrow |
| 4 | Increment A |
| 5 | Decrement A |
| 6 | Increment B |
| 7 | Decrement B |
| 8 | Compare |
| 9 | Multiplication |
| 10 | Shift-Multiply |
| 11 | Signed Addition |
| 12 | Signed Subtraction |

---

## Logical Mode (`mode = 0`)

| CMD | Operation |
|-----|------------|
| 0 | AND |
| 1 | NAND |
| 2 | OR |
| 3 | NOR |
| 4 | XOR |
| 5 | XNOR |
| 6 | NOT A |
| 7 | NOT B |
| 8 | Right Shift A |
| 9 | Left Shift A |
| 10 | Right Shift B |
| 11 | Left Shift B |
| 12 | Rotate Right |
| 13 | Rotate Left |

---

# Design Architecture

The ALU is implemented as a synchronous parameterized RTL module with:

- Input pipeline registers
- Combinational logic block
- Registered output stage
- Internal pipeline counter FSM
- Multi-cycle latency support for multiplication operations

Default configuration:

- Operand Width = 8-bit
- Result Width = 16-bit

---

# Verification Methodology

Verification was implemented using:

- Directed testing
- Self-checking testbench
- Reference model comparison
- Corner-case verification
- Coverage-driven verification
- Waveform debugging

The DUT outputs were continuously compared against a combinational reference model (`alu_ref.v`).

PASS/FAIL messages were automatically displayed during simulation.

---

# Testbench Features

- Clock and reset generation
- Task-based stimulus generation
- Automatic DUT vs Reference comparison
- PASS/FAIL tracking
- Multi-cycle timing synchronization
- Boundary and corner-case testing
- Coverage collection support
- Waveform generation support

---

# Timing Behaviour

## Standard Operations

- 1-cycle registered output latency

## Multiplication Operations

CMD 9 and CMD 10 use:

- 2-cycle pipeline latency
- Intermediate X-state cycle
- Registered final output

---

# Tools Used

- Verilog HDL
- QuestaSim / ModelSim
- Vivado
- Linux Environment

---

# Simulation Summary

| Metric | Result |
|--------|---------|
| Total Test Cases | 177 |
| PASS | 122 |
| FAIL | 55 |
| Pass Percentage | 68.9% |
| Overall Coverage | 97.59% |

---

# Coverage Results

| Coverage Type | Coverage |
|---------------|-----------|
| Statement Coverage | 100% |
| Branch Coverage | 99.11% |
| FEC Expression Coverage | 100% |
| FEC Condition Coverage | 100% |
| Toggle Coverage | 94.76% |
| FSM Coverage | 91.66% |
| Overall Coverage | 97.59% |

---

# Major Bugs Identified

## Arithmetic Mode Issues

- Incorrect `inp_valid` handling for increment/decrement operations
- Upper-byte extension mismatch in addition operations
- Missing comparison flags for signed arithmetic
- Multiply pipeline synchronization issues
- Incorrect overflow handling in subtraction

## Logical Mode Issues

- Rotate-left and rotate-right implementations swapped

---

# Learning Outcomes

Through this project, practical experience was gained in:

- RTL Design and Verification
- Self-checking testbench development
- Pipeline timing verification
- Simulation waveform debugging
- Coverage analysis
- Corner-case validation
- Multi-cycle operation handling
- Functional bug analysis

---

# Future Improvements

- Fix all identified DUT bugs
- Achieve 100% test pass rate
- Constrained-random verification
- Assertion-based verification (SVA)
- Functional coverage implementation
- SystemVerilog/UVM environment
- Support for wider ALU configurations (16-bit / 32-bit)
- Formal verification integration

---

# File Structure

```text
├── alu.v              # RTL Design
├── alu_ref.v          # Reference Model
├── alu_tb.v           # Self-checking Testbench
├── coverage_report/   # Coverage Reports
├── waveform.vcd       # Simulation Waveform
└── README.md
```

---

# Simulation Commands

## Compile

```bash
vlog alu.v alu_ref.v alu_tb.v
```

## Simulate

```bash
vsim alu_tb
run -all
```

## Coverage Collection

```bash
vsim -coverage alu_tb
coverage save coverage_report.ucdb
```

## Generate Coverage Report

```bash
vcover report -html coverage_report.ucdb
```

