# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Nand2Tetris implementation in pure Verilog, building a complete 16-bit processor from NAND gates. The project follows a Test-Driven Development (TDD) approach with hierarchical design, progressing from basic logic gates to a fully functional CPU that can execute Hack assembly programs.

## Key Commands

### Testing
- `make test` - Run all tests using the Python test framework
- `python3 scripts/test_runner.py` - Run all tests (equivalent to make test)
- `python3 scripts/test_runner.py test <testbench_file>` - Run a specific test
- `python3 scripts/test_runner.py -v` - Run tests with verbose output
- `python3 scripts/test_runner.py deps` - Show module dependency tree

### Development Tools
- `python3 scripts/test_runner.py generate <module_name>` - Generate test template for new modules
- `gtkwave temp/*.vcd` - View simulation waveforms after running tests
- `make clean` - Clean temporary files and simulation artifacts
- `make watch` - Watch for file changes and auto-run tests (requires fswatch)

### Prerequisites
- `iverilog` (Icarus Verilog) for simulation
- `gtkwave` for waveform viewing
- Python 3 for test framework

## Architecture

The codebase is organized in hierarchical layers:

### 1. Basic Logic Gates (`src/gates/`)
- `nand_gate.v` - Primitive NAND gate (foundation)
- `not_gate.v`, `and_gate.v`, `or_gate.v`, `xor_gate.v` - Built from NAND
- 16-bit versions: `not16_gate.v`, `and16_gate.v`, `or16_gate.v`
- Multiplexers/Demultiplexers: `mux.v`, `dmux.v` and multi-way variants

### 2. Arithmetic Logic (`src/arithmetic/`)
- `half_adder.v`, `full_adder.v` - Basic addition circuits
- `add16.v` - 16-bit ripple-carry adder
- `inc16.v` - 16-bit incrementer
- `alu.v` - Complete ALU with 6 control bits (18 operations)

### 3. Sequential Logic (`src/sequential/`)
- `dff.v` - D-Flip-Flop (basic memory element)
- `bit.v` - 1-bit register with load control
- `register16.v` - 16-bit register
- `program_counter.v` - PC with reset/load/increment

### 4. Memory Hierarchy (`src/memory/`)
- `ram8.v` - 8-register memory (3-bit address)
- `ram64.v` - 64-register memory (6-bit address)
- Higher capacity modules (RAM512, RAM4K, RAM16K) planned

### 5. Complete Computer (`src/computer/`)
- `cpu.v` - Full Nand2Tetris CPU with A/D registers, ALU, and jump logic
- `computer.v` - Complete computer (CPU + memory) [planned]

## Code Conventions

- **File naming**: `module_name.v` for implementations, `module_name_tb.v` for testbenches
- **Style**: Pure structural Verilog (no behavioral constructs)
- **Ports**: Always use `input wire` and `output wire`
- **Dependencies**: The test framework automatically resolves module dependencies

## Test Framework Features

- **Automatic dependency resolution**: Analyzes module instantiations and includes required source files
- **Hierarchical testing**: Tests are organized by component layer in `tests/` directory
- **VCD generation**: All tests generate waveform files in `temp/` directory
- **Template generation**: Automatic test template creation for new modules

## Module Dependencies (Key Examples)

- `cpu` → `alu`, `register16`, `program_counter`
- `alu` → `mux16`, `not16_gate`, `and16_gate`, `add16`, `or8way`
- `add16` → 16x `full_adder`
- `full_adder` → 2x `half_adder`, `or_gate`
- All gates ultimately derive from `nand_gate`

## Development Workflow

1. Create module implementation in appropriate `src/` subdirectory
2. Generate test template: `python3 scripts/test_runner.py generate <module>`
3. Write comprehensive test cases in corresponding `tests/` subdirectory
4. Run specific test: `python3 scripts/test_runner.py test <module>_tb.v`
5. Debug with waveforms: `gtkwave temp/<module>.vcd`
6. Run full test suite: `make test`