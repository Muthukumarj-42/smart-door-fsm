# 🔐 Smart Door Access Control System (RFID – FSM on FPGA)

A **Finite State Machine (FSM)** based **Smart Door Access Control System** implemented in **Verilog**.  
The system simulates RFID-based authentication using slide switches and push buttons, providing clear *Access Granted* / *Access Denied* indications along with a door unlock signal.

---

---

# 🔐 Smart Door Access System (FSM on ZedBoard)

## 📌 Overview
This project implements a **Smart Door Access System** using **Finite State Machine (FSM)** design in **Verilog** on the **Xilinx Zynq-7000 (ZedBoard)** FPGA.  
The system uses **8 slide switches** to simulate RFID input, **one push button** to submit the ID, and **another push button** for reset.  
It checks the entered RFID against two valid IDs and outputs access status through LEDs.

---

## 🎯 Features
- **FSM-based design** for clear state transitions.
- **Two valid RFID IDs** (`8'h33` and `8'hA1`).
- **Access Granted/Denied** indicators.
- **Door Unlock** signal for successful entries.
- **Automatic return to IDLE state** after each attempt.
- **Simulation testbench** with visible state transitions and outputs.

---

## 🛠 Hardware Requirements
- **Xilinx Zynq-7000 ZedBoard (Zynq-7020 SoC)**
- **8 Slide Switches** → Simulated RFID input
- **Push Button 1** → Submit RFID
- **Push Button 2** → Reset
- **LEDs** → Indicate system states & access results

---

## ⚙️ FSM States
| State | Description |
|-------|-------------|
| **IDLE** | System waits for user input. |
| **CHECK_ID** | Compares entered RFID with stored valid IDs. |
| **ACCESS_GRANTED** | Unlock signal given, "Granted" LED ON. |
| **ACCESS_DENIED** | "Denied" LED ON for invalid ID. |
| **DOOR_LOCK** | Door locked, system returns to IDLE. |

---

## 📂 File Structure


