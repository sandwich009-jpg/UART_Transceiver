`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.04.2026 13:47:05
// Design Name: 
// Module Name: UART_TOP
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


module UART_TOP#(

parameter CLK_FREQ = 50000000,
parameter BAUD_RATE = 9600
)(
input logic clk,
input logic rst,
input logic [7:0] tx_data,
input logic send,
output logic tx_line,
output logic busy,
output logic [7:0] rx_data,
output logic rx_done
);

logic serial_wire;

TRANSMISSION#(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
)tx_inst(
    .clk(clk),
    .rst(rst),
    .data_in(tx_data),
    .send(send),
    .tx(serial_wire),
    .busy(busy)
);

RECEIVER #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
)rx_inst(
    .clk(clk),
    .rst(rst),
    .rx(serial_wire),
    .data_out(rx_data),
    .rx_done(rx_done)
);

endmodule






