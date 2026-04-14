`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2026 15:26:14
// Design Name: 
// Module Name: baud_gen_tb
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


module baud_gen_tb;

logic clk;
logic rst;
logic baud_tick;

baud_gen#(
    .CLK_FREQ (50),
    .BAUD_RATE (5)
)dut(
    .clk (clk),
    .rst (rst),
    .baud_tick (baud_tick)
);

initial clk=0;
always #5 clk =~clk;

integer tick_count=0;
always_ff@(posedge clk)begin
    if(baud_tick)
        tick_count<=tick_count+1;
end

initial begin
rst=1;
repeat(2) @(posedge clk);
rst=0;

repeat(55)@(posedge clk);

if(tick_count == 5)
    $display("PASS %0d",tick_count);
else
    $display("FAIL %0d",tick_count);
    
$finish;
end

endmodule
