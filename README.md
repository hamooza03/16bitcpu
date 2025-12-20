# 16-bit CPU - Verilog Implementation

## Overview
In my Computer Organization we were instructed to create a 16-bit CPU in Logisim, a simulation software that allows you to place block diagrams to create Digital circuit designs. 
This is my attempt to convert the very same design into Verilog. I used Icarus Verilog to compile and GTKWave for simulation.

## Key Features
- 16-bit Datapath
- Synchronous, single clocked system

## Architecture Summary

## Current Components
- Arithmetic Logic Unit (ALU)
- Register File (RF)
- Finite State Machine (FSM)

## ALU Operations
| fun (Selector) | Mnemonic | Operation (Result `R`)                 | Notes |
|----------:|----------|----------------------------------------|-------|
| `000`     | ADD      | `R = A + B`                            | Addition |
| `001`     | SUB      | `R = A - B`                            | Subtraction |
| `010`     | AND      | `R = A & B`                            | Bitwise AND |
| `011`     | OR       | `R = A \| B`                           | Bitwise OR |
| `100`     | NOR      | `R = ~(A \| B)`                        | Bitwise NOR |
| `101`     | LSL      | `R = A << B[3:0]`                      | Logical shift left by `B[3:0]` |
| `110`     | LSR      | `R = A >> B[3:0]`                      | Logical shift right by `B[3:0]` |
| `111`     | ASR      | `R = $signed(A) >>> B[3:0]`            | Arithmetic shift right (sign-extends) |
