`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2022 12:24:46 PM
// Design Name: 
// Module Name: Nano_project_inputswitches
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


module Pico_project_switches(
input SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,SW15,compA, compB,


output reg [5:0] state,
output reg end_reset,
    
    output LED0,LED1,LED2,LED3,LED4,LED5,LED6,LED7
    
    );
    always @ (*) begin
                state = {SW7,SW6,SW5,SW4};
                end_reset = SW15;
			end
   
	assign LED0 = SW0;
    assign LED1 = SW1;
    assign LED2 = SW2;
    assign LED3 = SW3;
    assign LED4 = SW4;
    assign LED5 = SW5;
    assign LED6 = SW6;
    assign LED7 = SW7;
    
endmodule
