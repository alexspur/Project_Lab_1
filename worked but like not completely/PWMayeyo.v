`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2022 12:23:58 PM
// Design Name: 
// Module Name: Nano_PWM
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


module Pico_PWM(
    input btnC,
    input clock,
    input reset,
    input SW0,SW1,SW2,SW3, compA, compB,
    output enableA, enableB
);
    reg temp_PWM;
    reg [19:0] counter;
    reg [19:0] speed;
    reg [19:0] bufferCounter_clock;
    reg halt;

    initial begin
        //speed and direction
        counter = 0;
        speed =0;
        temp_PWM = 0;
        bufferCounter_clock = 0;
    end

    always@(posedge clock) begin
        if(btnC)
        begin
            halt <= 0;
        end
        if(!halt) begin
            if(!compA || !compB) begin
                bufferCounter_clock <= bufferCounter_clock + 1;
            end
            else begin
                bufferCounter_clock <= 0;
            end
            if (bufferCounter_clock > 160000000) begin
                temp_PWM = 0;
                halt <= 1;
            end

            if(reset)
                counter <= 0;
            else if (counter >= 1666667)    // code to control PWM cycle based on switch cases
                counter <= 0;
            else
                counter <= counter + 1;
            if(counter < speed)
                temp_PWM <= 1;
            
            if (counter > speed)
                temp_PWM <= 0;  
        end
    end

    always @ (*) begin

        case({SW2,SW0,SW3,SW1})
            4'b0001: speed = 416667; // 25%
            4'b0010: speed = 833333; // 50% 
            4'b0100: speed = 1250000; // 75%
            4'b1000: speed = 1666667; // 100%
            default : speed= 0;
        endcase
    end


    assign enableA = temp_PWM;
    assign enableB = temp_PWM;
endmodule
