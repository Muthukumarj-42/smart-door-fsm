# 🔐 Smart Door Access Control System (RFID – FSM on FPGA)

A **Finite State Machine (FSM)** based **Smart Door Access Control System** implemented in **Verilog**.  
The system simulates RFID-based authentication using slide switches and push buttons, providing clear *Access Granted* / *Access Denied* indications along with a door unlock signal.

---

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
- **Xilinx Zynq-7000 ZedBoard (Zynq-7000 ZC702)**
- **8 Slide Switches** → Simulated RFID input
- **Push Button 1** → Submit RFID
- **Push Button 2** → Reset
- **LEDs** → Indicate system states & access results

---

## ⚙️ FSM States
| State | Description |
|-------|-------------|
| **IDLE** | System waits for user input. |
|**SCAN** | Reading the RFID code |
| **CHECK_ID** | Compares entered RFID with stored valid IDs. |
| **ACCESS_GRANTED** | Unlock signal given, "Granted" LED ON. |
| **ACCESS_DENIED** | "Denied" LED ON for invalid ID. |
| **DOOR_LOCK** | Door locked, system returns to IDLE. |

![STATE](https://github.com/Muthukumarj-42/smart-door-fsm/blob/c939e130490b5be1438129fe11093c0646f9b8c4/Images/FSM%20STATE%20DIAGRAM.png)

---
## Verilog code (smart_door_fsm.v)
<pre>module smart_door_fsm (
    input clk,
    input rst,
    input submit,
    input [7:0] rfid_in,
    output reg unlock,
    output reg granted,
    output reg denied
);

    parameter IDLE = 2'b00,
              CHECK = 2'b01,
              ACCESS_GRANTED = 2'b10,
              ACCESS_DENIED = 2'b11;
    parameter VALID1 = 8'h21,
              VALID2 = 8'hd3;
    reg [1:0] current_state, next_state;
    reg [7:0] rfid_reg;
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end
    always @(posedge clk or posedge rst) begin
        if (rst)
            rfid_reg <= 8'h00;
        else if (current_state == IDLE && submit)
            rfid_reg <= rfid_in;
        else if (current_state == ACCESS_GRANTED || current_state == ACCESS_DENIED)
            rfid_reg <= 8'h00;
    end
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: if (submit) next_state = CHECK;
            CHECK: begin
                if (rfid_reg == VALID1 || rfid_reg == VALID2)
                    next_state = ACCESS_GRANTED;
                else
                    next_state = ACCESS_DENIED;
            end
            ACCESS_GRANTED,
            ACCESS_DENIED: next_state = IDLE;
        endcase
    end
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            unlock <= 0;
            granted <= 0;
            denied <= 0;
        end else begin
            unlock <= (current_state == CHECK && next_state == ACCESS_GRANTED);
            granted <= (current_state == CHECK && next_state == ACCESS_GRANTED);
            denied <= (current_state == CHECK && next_state == ACCESS_DENIED);
        end
    end
endmodule</pre>

---

## Testbench code (smart_door_fsm_tb.v)
<pre>`timescale 1ns / 1ps
module smart_door_fsm_tb;

    reg clk;
    reg rst;
    reg submit;
    reg [7:0] rfid_in;
    wire unlock;
    wire granted;
    wire denied;


    smart_door_fsm dut (
        .clk(clk),
        .rst(rst),
        .submit(submit),
        .rfid_in(rfid_in),
        .unlock(unlock),
        .granted(granted),
        .denied(denied)
    );


    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
     
        rst = 1;
        submit = 0;
        rfid_in = 8'h00;

        #20 rst = 0;
        rfid_in = 8'h33;
        #10 submit = 1; #10 submit = 0;
        #10 $display("Time=%0t RFID=%h  Unlock=%b Granted=%b Denied=%b", $time, rfid_in, unlock, granted, denied);
        #50;
        rfid_in = 8'h12;
        #10 submit = 1; #10 submit = 0;
        #10 $display("Time=%0t RFID=%h  Unlock=%b Granted=%b Denied=%b", $time, rfid_in, unlock, granted, denied);
        #50;
        rfid_in = 8'ha1;
        #10 submit = 1; #10 submit = 0;
        #10 $display("Time=%0t RFID=%h  Unlock=%b Granted=%b Denied=%b", $time, rfid_in, unlock, granted, denied);
        #50;

        $finish;
    end

endmodule</pre>

---

## Waveform

![image ](https://github.com/Muthukumarj-42/smart-door-fsm/blob/d34c248c3e0a9bc855ed3aaa3d299cf9988a8627/Images/FSM-GRAPH.jpg)


