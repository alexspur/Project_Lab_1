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
    
    reg clock;
    wire enableA,enableB;
    wire JA1,JA2,JA3,JA4;
NANO_MAIN UUT(clock,SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,enableA,enableB,JA1,JA2,JA3,JA4);
 initial begin
 clock =0;
 
 
    SW0=1;
    SW1=0;
    SW2=0;
    SW3=0;
    SW4=1;
    SW5=0;
    SW6=0;
    SW7=0;
    
    #1000000;
    
    
    
    
 end 
 
 always begin
    #5 clock = ~clock;
end  
endmodule
