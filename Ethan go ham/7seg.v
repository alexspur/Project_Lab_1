`timescale 1ns / 1ps

module Pico_7seg(
    input clock,
    input SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,SW15, compA, compB, btnR,
    output a, b, c, d, e, f, g, dp,
    output [3:0] an
);
    reg [3:0] in0, in1, in2, in3;
    reg [N-1:0]countn;
    reg [1:0] resetn;
    reg [6:0]sseg;
    reg [3:0]an_temp;
    reg [6:0] sseg_temp;
    reg stop1;
    reg [31:0] surge_clock1;
    

    initial begin

        countn = 0;
        resetn = 0;
        in0 = 0;
        in1 = 0;
        in2 = 0;
        in3 = 0;
        stop1 = 0;
        surge_clock1 = 0;
    end
    
    localparam N = 18;


// DISPLAY STUFF (NOT IMPORTANT)
    always@(posedge clock) begin
        if (resetn)                     //counter for 7-segment display multiplexing
            countn <= 0;
        else
            countn <= countn + 1; 
    end



always@(posedge clock) begin    //sets speed value and updates 7-seg to display duty cycle
        if (btnR)
        stop1 <= 0;
        
        
        if(stop1 == 0) begin
            if (!compA || !compB)
            surge_clock1 <= surge_clock1 + 1;
            end
        else begin
        surge_clock1 <= 0;
        end
        if (surge_clock1 >= 8000000)
        stop1 <= 1;
        
        
        if ((compA == 0 || compB == 0) && stop1 == 1)begin
            in0 <= 11;
            in1 <= 11;
            in2 <= 11;
            in3 <= 11;
        end
       
       else if (compA == 1 && compB == 1 && !stop1) begin
       
        if(SW0)
        begin
            in1 = 5;
            in2 = 2;
            in3 = 15;
        end 
        else if(SW1)
        begin
            in1 = 0;
            in2 = 5;
            in3 = 15;
        end 
        else if(SW2)
        begin
            in1 = 5;
            in2 = 7;
            in3 = 15;
        end 
        else if(SW3)
        begin
            in1 = 0;
            in2 = 0;
            in3 = 1;
        end 
        else 
        begin
            in1 = 0;
            in2 = 0;
            in3 = 0;
        end
    end

   //Assigns direction for the two motors and updates the 7-seg to display direction
        if(compA == 1 && compB == 1 && !stop1) begin
            if(SW4)begin                            //FORWARDS
                in0 <= 11;
            end
            
            if(SW5)begin                            //BACKWARDS
                in0 <= 10;
            end    
            if(SW6)begin                            //LEFT
                in0 <= 13;
            end   
            if(SW7)begin                            //RIGHT
                in0 <= 12;
            end  
            if(~SW4 && ~SW5 && ~SW6 && ~SW7)begin   //STOPPED if switches are not on
                in0 <= 15;
            end
       end
    end

always @ (*)begin       //turn on anode 0-3
    case(countn[N-1:N-2]) //using only the 2 MSB's of the counter 
        2'b00 :  //When the 2 MSB's are 00 enable the fourth display
        begin
            sseg = in0;
            an_temp = 4'b1110;
        end
        2'b01:  //When the 2 MSB's are 01 enable the third display
        begin
            sseg = in1;
            an_temp = 4'b1101;
        end
        2'b10:  //When the 2 MSB's are 10 enable the second display
        begin
            sseg = in2;
            an_temp = 4'b1011;
        end
        2'b11:  //When the 2 MSB's are 11 enable the first display
        begin
            sseg = in3;
            an_temp = 4'b0111;
        end
    endcase
    end
    
    assign an = an_temp;    //turn on anode 0-3


always @ (*)begin       //assign which segments are turned off/on to display a character
    case(sseg)
        4'd0 : sseg_temp = 7'b1000000; //to display 0
        4'd1 : sseg_temp = 7'b1111001; //to display 1
        4'd2 : sseg_temp = 7'b0100100; //to display 2
        4'd3 : sseg_temp = 7'b0110000; //to display 3
        4'd4 : sseg_temp = 7'b0011001; //to display 4
        4'd5 : sseg_temp = 7'b0010010; //to display 5
        4'd6 : sseg_temp = 7'b0000010; //to display 6
        4'd7 : sseg_temp = 7'b1111000; //to display 7
        4'd8 : sseg_temp = 7'b0000000; //to display 8
        4'd9 : sseg_temp = 7'b0010000; //to display 9
        4'd10 : sseg_temp = 7'b0000011;//to display b
        4'd11 : sseg_temp = 7'b0001110;//to display F
        4'd12 : sseg_temp = 7'b1000111;//to display L
        4'd13 : sseg_temp = 7'b0101111;//to display R
        default : sseg_temp = 7'b0111111; //dash
    endcase
    end

    assign {g, f, e, d, c, b, a} = sseg_temp; 
    assign dp = 1'b1;//The decimal point on the 7-seg display is always off

endmodule
