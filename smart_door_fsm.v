module smart_door_fsm (
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
endmodule
