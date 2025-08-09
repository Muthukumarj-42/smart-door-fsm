`timescale 1ns / 1ps
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

endmodule
