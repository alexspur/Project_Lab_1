`include "Nano_7seg.v"
`timescale 1ns / 1ps



module Nano_7seg_testbench;
reg SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,SW15, CLK;
wire a, b, c, d, e, f, g, dp;
wire [3:0] an;

Nano_7seg U1(SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,SW15,
a, b, c, d, e, f, g, dp, an);


always begin
    CLK = ~CLK;
    #5;
end

initial begin
        $dumpfile("Nano_7seg.vcd");
        $dumpvars(0, Nano_7seg_testbench);
        $display("Start of Test.");

        
        CLK = 0;
        SW0 = 0;
        SW1 = 0;
        SW2 = 0;
        SW3 = 1;
        SW4 = 0;
        SW5 = 1;
        SW6 = 0;
        SW7 = 0;
        SW15 = 0;
        #10000;




    $finish;
end




endmodule