`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2026 21:29:18
// Design Name: 
// Module Name: RECEIVER
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


module RECEIVER#(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 9600
)(
    input logic clk,
    input logic rst,
    input logic rx,
    output logic [7:0] data_out,
    output logic rx_done
);

logic baud_tick_16x;
logic [3:0] tick_cnt;
logic [2:0] bit_cnt;
logic [7:0] shift_reg;

typedef enum logic [1:0]{
    IDLE = 2'b00,
    START = 2'b01,
    DATA = 2'b10,
    STOP = 2'b11
}state_t;

state_t state;

baud_gen#(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE * 16)
)baud_inst(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick_16x)
);

always_ff@(posedge clk or posedge rst)begin
    if(rst) begin
        state <= IDLE;
        tick_cnt <= 4'b0;
        bit_cnt <= 3'b0;
        shift_reg <= 8'b0;
        data_out <= 8'b0;
        rx_done <= 1'b0;
    end
    else begin
    rx_done <= 1'b0;
    case(state)
    
        IDLE:begin
            tick_cnt <= 4'b0;
            bit_cnt <= 3'b0;
            if (rx == 1'b0)
                state <= START;
            end
            
        START:begin
            if(baud_tick_16x) begin
                if(tick_cnt == 4'd7)begin
                    if(rx == 1'b0) begin
                        tick_cnt <= 4'b0;
                        state <= DATA;
                    end
                    else begin
                        state <= IDLE;
                    end 
                end
                else begin
                    tick_cnt <= tick_cnt +1;
                end
            end
            end
            
            DATA:begin
                if(baud_tick_16x)begin
                    if(tick_cnt == 4'd15)begin
                        tick_cnt <= 4'b0;
                        shift_reg <= {rx,shift_reg[7:1]};
                        if (bit_cnt == 3'd7)begin
                            state <= STOP;
                        end
                        else begin
                            bit_cnt <= bit_cnt+1;
                        end
                    end
                    else begin
                        tick_cnt <= tick_cnt +1;
                    end
                end
                end
                
            STOP:begin
                if(baud_tick_16x)begin
                    if(tick_cnt == 4'd15)begin
                        if(rx==1'b1)begin
                            data_out <= shift_reg;
                            rx_done <= 1'b1;
                        end
                        tick_cnt <= 4'b0;
                        bit_cnt <= 3'b0;
                        state <= IDLE;
                    end
                    else begin
                    tick_cnt <= tick_cnt+1;
                    end
                end
                end
            
            default: state <= IDLE;
            endcase
        end
        end
        
endmodule        
        
            
            
    
    
    



