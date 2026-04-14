`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2026 17:25:28
// Design Name: 
// Module Name: TRANSMISSION_tb
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


module TRANSMISSION_tb;

logic clk;
logic rst;
logic [7:0] data_in;
logic send;
logic tx;
logic busy;
logic [7:0] received;

TRANSMISSION #(
    .CLK_FREQ(50),
    .BAUD_RATE (5)
)dut(
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .send(send),
    .tx(tx),
    .busy(busy)
);

initial clk=0;
always #5 clk = ~clk;

task send_byte;
    input [7:0] byte_to_send;
    integer i;
    begin
        wait(busy==1'b0);
        wait(clk == 1'b1);
        
        data_in=byte_to_send;
        send = 1'b1;
        @(posedge clk);
        send=1'b0;
        
        wait (busy==1'b1);
        
        wait (tx==1'b0);
        $display("Start bit detected");
        repeat(15) @(posedge clk);
        
        received = 8'b0;
        for (i=0;i<8;i=i+1)begin
            received[i]=tx;
            $display("Bit received , Bit[%0d] = %b",i,tx);
            if(i<7)
                repeat(10)@(posedge clk);
        end
        
        repeat(10)@(posedge clk);
        if(tx == 1'b1)
            $display("Stopped");
        else    
            $display("Not stopped");
            
        wait(busy==1'b0);
        
        if(received == byte_to_send)
            $display("PASS - %02h , %02h",byte_to_send,received);
        else
            $display ("FAIL - %02h , %02h",byte_to_send,received);
            
        repeat(5)@(posedge clk);
            
    end
endtask

initial begin
    rst=1'b1;
    send=1'b0;
    data_in=8'b0;
    
    repeat(2)@(posedge clk);
    rst=1'b0;
    repeat(2)@(posedge clk);
    
    $display("====TRANSMISSION TB====\n");
    
    $display("1) 0x55");
    send_byte(8'h55);
    
    $display("2) 0x41");
    send_byte(8'h41);
    
    $display("3) 0x00");
    send_byte(8'h00);
    
    $display("4) 0xFF");
    send_byte(8'hFF);
    
    $display("5) 0xA5");
    send_byte(8'hA5);
    
    $finish;
end
endmodule
    
        
        
        
    
   
    
    
    



