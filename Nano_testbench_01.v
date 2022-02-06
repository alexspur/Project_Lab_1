`include "NANO_MAIN.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2022 02:00:52 PM
// Design Name: 
// Module Name: Nano_testbench
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


module Nano_testbench(
);
    reg SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,SW15;
    reg clock, reset;
    wire enableA,enableB;
    wire JA1,JA2,JA3,JA4;
NANO_MAIN UUT(clock,SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,enableA,
enableB,JA1,JA2,JA3,JA4, LED0, LED1, LED2, LED3, LED4, LED5,
LED6, LED7);



 initial begin

        $dumpfile("NANO_MAIN.vcd");
        $dumpvars(0, Nano_testbench);
        $display("Start of Test.");
    clock = 0;
    #100;
    $display("%b -- Enable A, %b -- Enable B", enableA, enableB);
 

    SW0=0;
    SW1=0;
    SW2=1;
    SW3=0;
    SW4=1;
    SW5=0;
    SW6=0;
    SW7=0;
    
    #1000000;

    $finish;

    
    
    
    
    
 end 
 
 always begin
     clock = ~clock;
     #5;
end  
endmodule
