`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2022 12:33:37 PM
// Design Name: 
// Module Name: NANO_MAIN
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


module PICO_MAIN(
input clock,
input SW1,SW2,SW3,SW4,SW5,SW6,SW7, SW0,
input compA, compB, btnC, btnR, JB1, JB2, JB3,
	
	output enableA,enableB,
    output JA1,JA2,JA3,JA4,
    output a, b, c, d, e, f, g, dp,
    output [3:0] an,
    
    output LED0,LED1,LED2,LED3,LED4,LED5,LED6,LED7
    );
    wire [2:0] speed;
    wire [3:0] direction;
	wire end_reset;
	

	Frequency_Signal_Detection (.LED1(LED1));
	
	Pico_PWM PWM1(
		.clock(clock),.reset(reset),
		
		
		.SW0(SW0),.SW1(SW1), .SW2(SW2), .SW3(SW3),
		
		.compA(compA), .compB(compB),
		
		.enableA(enableA), .enableB(enableB), .btnC(btnC), .JB1(JB1)
		
	);
	
	Pico_project_switches InputControl1(
		.SW0(SW0), .SW1(SW1), .SW2(SW2), .SW3(SW3),
        .SW4(SW4), .SW5(SW5), .SW6(SW6), .SW7(SW7),.SW15(SW15),
		
		.LED0(LED0),.LED1(LED1),.LED2(LED2),
		.LED3(LED3),.LED4(LED4),.LED5(LED5),
		.LED6(LED6),.LED7(LED7), .compA(compA), .compB(compB), .JB1(JB1), .JB2(JB2),
		
		
		.end_reset(end_reset)
	);
	
	Pico_project_MotorDriver MotorDriver1(
        .reset(reset),
        
        .compA(compA), .compB(compB),
		.direction(direction[3:0]),
        
        .JA1(JA1), .JA2(JA2),
        .JA3(JA3), .JA4(JA4), .JB1(JB1), .JB2(JB2), .JB3(JB3)
    );
    
    Pico_7seg display1(
    .clock(clock),.SW0(SW0), .SW1(SW1), .SW2(SW2), .SW3(SW3), .compA(compA), .compB(compB),
    .SW4(SW4), .SW5(SW5), .SW6(SW6), .SW7(SW7),.SW15(SW15),
    
    .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp), .an(an), .btnR(btnR)
    );
	
endmodule
