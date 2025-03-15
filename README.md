# Four-way traffic light controller FSM
Implementation of a 4-way traffic light FSM in SystemVerilog
 
!["FSM diagram"](fsm_diagram.png)

# Overview

This SystemVerilog module implements a four-way traffic light controller using a finite state machine (FSM). The controller cycles through traffic light states for North, South, East, and West directions, managing both red/green and yellow light transitions.

# Four-Way Traffic Light FSM

## Overview
This SystemVerilog module implements a **finite state machine (FSM)** to control a four-way traffic light system. The FSM cycles through the traffic signals in a predefined sequence, ensuring safe and orderly traffic flow.

## Features
- Uses **SystemVerilog `enum`** for state representation.
- Implements **synchronous reset** for improved stability.
- Uses **non-blocking assignments (`<=`)** in sequential logic.
- Separates **sequential logic (`always_ff`)** from **combinational logic (`always_comb`)**.
- Provides **eight states**: Four main states (green lights) and four transition states (yellow lights).

## State Diagram
The FSM cycles through these states in the following order:

```
NORTH (N) → NORTH_Y (N_Y) → SOUTH (S_Y) → SOUTH_Y (S_Y) → EAST (E) → EAST_Y (E_Y) → WEST (W) → WEST_Y (W_Y) → (repeat)
```

Where:
- `NORTH`, `SOUTH`, `EAST`, `WEST` represent the **green light** for the respective direction.
- `NORTH_Y`, `SOUTH_Y`, `EAST_Y`, `WEST_Y` represent the **yellow light** transition before switching.

## Module Interface

### **Ports**
| Signal   | Direction | Width | Description |
|----------|----------|------|-------------|
| `clk`    | Input    | 1    | System clock |
| `rst`    | Input    | 1    | Synchronous reset (active high) |
| `n_lights` | Output | 2 | North traffic light (`00=off, 10=green, 01=yellow`) |
| `s_lights` | Output | 2 | South traffic light (`00=off, 10=green, 01=yellow`) |
| `e_lights` | Output | 2 | East traffic light (`00=off, 10=green, 01=yellow`) |
| `w_lights` | Output | 2 | West traffic light (`00=off, 10=green, 01=yellow`) |

### **State Encoding**
| State     | Binary Code | Description |
|-----------|------------|-------------|
| `NORTH`   | 000        | North green, others off |
| `NORTH_Y` | 001        | North yellow, others off |
| `SOUTH`   | 010        | South green, others off |
| `SOUTH_Y` | 011        | South yellow, others off |
| `EAST`    | 100        | East green, others off |
| `EAST_Y`  | 101        | East yellow, others off |
| `WEST`    | 110        | West green, others off |
| `WEST_Y`  | 111        | West yellow, others off |

## Timing Behavior
- Each green state lasts **8 clock cycles**.
- Each yellow state lasts **8 clock cycles**.
- The FSM continuously cycles through the states.

## Testbench
A testbench (`four_way_traffic_tb.sv`) is included to verify functionality:
- Generates a **50% duty cycle clock** (`#5 CLK = ~CLK`).
- **Applies reset** for the first 5 time units.
- **Monitors outputs** using `$monitor`.
- **Runs for 200 time units** before stopping.

## Simulation Instructions
1. Compile the module and testbench using a SystemVerilog simulator (e.g., **ModelSim, VCS, or Verilator**).
2. Run the testbench.
3. Observe the state transitions and light signals in the waveform viewer.


---

**Author:** Kartik Sahajpal  
**License:** MIT  
