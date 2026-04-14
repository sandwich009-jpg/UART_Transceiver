`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.04.2026 13:54:51
// Design Name: 
// Module Name: UART_TOP_tb
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


module UART_TOP_tb;

logic clk;
logic rst;
logic [7:0] tx_data;
logic send;
logic tx_line;
logic busy;
logic [7:0] rx_data;
logic rx_done;

UART_TOP#(
    .CLK_FREQ(1600),
    .BAUD_RATE(5)
)dut(
    .clk(clk),
    .rst(rst),
    .tx_data(tx_data),
    .send(send),
    .tx_line(tx_line),
    .busy(busy),
    .rx_data(rx_data),
    .rx_done(rx_done)
);

initial clk =1'b0;
always #5 clk = ~clk;

task send_and_check;
    input[7:0] data;
    begin
        tx_data = data;
        send = 1'b1;
        @(posedge clk);
        send = 1'b0;
        
        wait(rx_done == 1'b1);
        @(posedge clk);
        
        if(rx_data == data)
            $display("PASS - %02h  %02h",rx_data,data);
        else 
            $display("FAIL - %02h %02h",rx_data,data);
            
        wait(busy == 1'b0);
        repeat(50)@(posedge clk);
    end
endtask


initial begin

rst=1'b1;
send=1'b0;
tx_data = 8'b0;

repeat(2)@(posedge clk);
rst=1'b0;
repeat(2) @(posedge clk);

$display("====UART FINAL BOSS====\n");

send_and_check(8'h55);
send_and_check(8'h41);
send_and_check(8'h00);
send_and_check(8'hFF);
send_and_check(8'hA5);

$finish;
end

endmodule



 










