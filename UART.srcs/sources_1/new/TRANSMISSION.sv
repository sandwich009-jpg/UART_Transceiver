`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2026 16:26:53
// Design Name: 
// Module Name: TRANSMISSION
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


module TRANSMISSION #(
    parameter CLK_FREQ  = 50000000,
    parameter BAUD_RATE = 9600
)(
    input  logic       clk,
    input  logic       rst,
    input  logic [7:0] data_in,
    input  logic       send,
    output logic       tx,
    output logic       busy
);

    logic       baud_tick;
    logic       baud_rst;
    logic [7:0] shift_reg;
    logic [2:0] bit_cnt;

    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        START = 2'b01,
        DATA  = 2'b10,
        STOP  = 2'b11
    } state_t;

    state_t state;

    baud_gen #(
        .CLK_FREQ  (CLK_FREQ),
        .BAUD_RATE (BAUD_RATE)
    ) baud_inst (
        .clk       (clk),
        .rst       (rst || baud_rst),
        .baud_tick (baud_tick)
    );

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state     <= IDLE;
            tx        <= 1'b1;
            busy      <= 1'b0;
            baud_rst  <= 1'b0;
            shift_reg <= 8'b0;
            bit_cnt   <= 3'b0;
        end 
        else begin

            baud_rst <= 1'b0;

            case (state)

                IDLE: begin
                    tx   <= 1'b1;
                    busy <= 1'b0;
                    if (send) begin
                        shift_reg <= data_in;
                        busy      <= 1'b1;
                        baud_rst  <= 1'b1;
                        state     <= START;
                    end
                end

                START: begin
                    tx <= 1'b0;
                    if (baud_tick) begin
                        bit_cnt <= 3'b0;
                        state   <= DATA;
                    end
                end

                DATA: begin
                    tx <= shift_reg[0];
                    if (baud_tick) begin
                        shift_reg <= shift_reg >> 1;
                        if (bit_cnt == 3'd7)
                            state <= STOP;
                        else
                            bit_cnt <= bit_cnt + 1;
                    end
                end

                STOP: begin
                    tx <= 1'b1;
                    if (baud_tick)
                        state <= IDLE;
                end

            endcase
        end
    end

endmodule
