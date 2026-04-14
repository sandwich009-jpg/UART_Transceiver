`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2026 10:42:00
// Design Name: 
// Module Name: baud_gen
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


module baud_gen #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 9600
)(
    input logic clk,
    input logic rst,
    output logic baud_tick
);

localparam DIVIDER = CLK_FREQ/BAUD_RATE;

logic[$clog2(DIVIDER)-1:0] count;

always_ff@(posedge clk or posedge rst)begin
    if(rst)
        count<=0;
    else if (count == DIVIDER -1)
        count<=0;
    else 
        count<=count + 1;
end

assign baud_tick= (count == DIVIDER -1);

endmodule
