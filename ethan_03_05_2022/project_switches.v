`timescale 1ns / 1ps


module Pico_project_switches(
input SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,SW15,compA, compB, JB1, JB2,

output reg end_reset,
    
    output LED0,LED1,LED2,LED3,LED4,LED5,LED6,LED7,LED8, LED14
    
    );
    always @ (*) begin
                
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
    //assign LED14 = compA;
    
endmodule
