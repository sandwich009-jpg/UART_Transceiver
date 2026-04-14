`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.04.2026 11:53:22
// Design Name: 
// Module Name: RECIEVER_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RECIEVER_tb;

logic clk;
logic rst;
logic rx;
logic [7:0] data_out;
logic rx_done;

RECEIVER #(
    .CLK_FREQ(1600),
    .BAUD_RATE(5)
)dut(
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .data_out(data_out),
    .rx_done(rx_done)
);

initial clk=0;
always #5 clk = ~clk;

logic [7:0] received;

task transmit_byte;
    input [7:0]byte_to_send;
    integer i;
    begin
        rx = 1'b0;
        repeat(320) @(posedge clk);
        
        for(i=0;i<8;i= i +1)begin
            rx = byte_to_send[i];
            repeat(320) @(posedge clk);
        end
        
        rx=1'b1;
        repeat(320) @(posedge clk);
        
    end
endtask

task check_byte;
    input [7:0] expected;
    begin
        wait(rx_done == 1'b1);
        @(posedge clk);
        
        if(received == expected) begin
            $display("PASS - %02h %02h",expected,data_out);
        end
        else begin
            $display("FAIL - %02h %02h",expected,data_out);
        end
    end
endtask

initial begin

rst = 1'b1;
rx= 1'b1;

repeat(2) @(posedge clk);
rst = 1'b0;
repeat(2) @(posedge clk);

$display ("====UART RECEIVER====\n");

$display("1) 0x55");
fork
    transmit_byte(8'h55);
    check_byte(8'h55);
join

$display("2) 0x41");
fork
    transmit_byte(8'h41);
    check_byte(8'h41);
join

$display("3) 0x00");
fork
    transmit_byte(8'h00);
    check_byte(8'h00);
join

$display("4) 0xFF");
fork
    transmit_byte(8'hFF);
    check_byte(8'hFF);
join

$display("5) 0xA5");
fork 
    transmit_byte(8'hA5);
    check_byte(8'hA5);
join

$finish;
end

endmodule
