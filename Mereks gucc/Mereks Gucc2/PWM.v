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
    input clock,
    input reset,
    input SW0,SW1,SW2,SW3, compA, compB,
    output enableA, enableB
);
    reg temp_PWM;
    reg [19:0] counter;
    reg [19:0] speed;
    reg [19:0] bufferCounter_clock;
    reg [3:0] bufferCounter = 4'b1111;

    initial begin
        //speed and direction
        counter = 0;
        speed =0;
        temp_PWM = 0;
    end

    always@(posedge clock) begin        // updates during every rising edge of the clock
        if (!compA || !compB) begin     // if either motor triggers overcurrent protection

            if (bufferCounter == 4'b1111 && !compBuffer))       // if the counter has finished (or has just been initialized) and the buffer flag is not set --> begin
            compBuffer <= 1;             // enable the buffer flag; 
            bufferCounter <= 0;          // reset the higher-level precision counter;
            bufferCounter_clock <= 0;    // reset the lower-level clock counter;
            
            else if (bufferCounter != 4'b1111) begin       // change bufferCounter for easier buffer time control. change between "if" or "while" if error
                bufferCounter_clock <= bufferCounter_clock + 1;     // try a blocking statement here if needed
                if (bufferCounter_clock >= 1666667) begin       // arbitrary large number
                    bufferCounter_clock <= 0;                   // reset large number
                    bufferCounter <= bufferCounter + 1;         // increment precision counter
                end
            end

            else if(bufferCounter == 4'b1111 && compBuffer) begin      // once the buffer is finished
                //bufferCounter_clock <= 0;       // reset the buffer clock (extraneous, use for debugging)
                //bufferCounter <= 0;         // reset the buffer precision counter (extraneous, use for debugging)
                compBuffer <= 0;        // disable the buffer flag
            end

        end
        else if (!compBuffer) begin     // if the buffer flag is not enabled
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
