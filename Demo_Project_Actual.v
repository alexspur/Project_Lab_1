`timescale 1ns / 1ps //
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/30/2022 10:59:10 AM
// Design Name: 
// Module Name: Demo_Project
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


`timescale 1ns / 1ps



module Demo_Project(
    input SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,SW15,
    input clock,
    output LED0,LED1,LED2,LED3,LED4,LED5,LED6,LED7,LED14,LED15,
    output a, b, c, d, e, f, g, dp,
    output [3:0] an,  
    output I1,I2,I3,I4,
    output reg enableA, enableB
    );
   
    assign LED0 = SW0;
    assign LED1 = SW1;
    assign LED2 = SW2;
    assign LED3 = SW3;
    assign LED4 = SW4;
    assign LED5 = SW5;
    assign LED6 = SW6;
    assign LED7 = SW7;
    assign LED15 = SW15;
    assign reset0 = SW15;
    assign resetn0 = SW15;
    
    localparam N = 18;
   
    reg [3:0] in0, in1, in2, in3;
    reg [18:0] counter;
    reg [24:0] count;
    reg [18:0] width;
    reg [2:0] speed;
    reg [N-1:0]countn;
    reg [1:0] reset;
    reg [1:0] resetn;
    reg [6:0]sseg;
    reg [3:0]an_temp;
    reg [6:0] sseg_temp;
    reg [30:0] stop;
    reg LEDONOFF;
    reg temp_PWM;
    reg temp_PWM1;
    reg temp_PWM2;
    reg temp_PWM3;
    reg temp_PWM4;
    
   
    assign LED14 = LEDONOFF;
   
    initial begin
        counter = 0;
        count = 0;
        countn = 0;
        width = 0;
        speed = 0;
        stop = 0;
        temp_PWM = 0;
        temp_PWM1 = 0;
        temp_PWM2 = 0;
        temp_PWM3 = 0;
        temp_PWM4 = 0;
        in0 = 0;
        in1 = 0;
        in2 = 0;
        in3 = 0;
        reset = 0;
        resetn = 0;
        LEDONOFF = 0;
    end  
   
    always@(*) begin    //sets speed value and updates 7-seg to display duty cycle
        if(SW0)
        begin
            enableA <= temp_PWM;
            enableB <= temp_PWM;
            speed = 0;  //25% duty cycle
            in1 = 5;
            in2 = 2;
            in3 = 15;
        end 
        else if(SW1)
        begin
            enableA <= temp_PWM;
            enableB <= temp_PWM;
            speed = 1;  //50% duty cycle
            in1 = 0;
            in2 = 5;
            in3 = 15;
        end 
        else if(SW2)
        begin
            enableA <= temp_PWM;
            enableB <= temp_PWM;
            speed = 2; //75% duty cycle
            in1 = 5;
            in2 = 7;
            in3 = 15;
        end 
        else if(SW3)
        begin
            enableA <= temp_PWM;
            enableB <= temp_PWM;
            speed = 3; //100% duty cycle
            in1 = 0;
            in2 = 0;
            in3 = 1;
        end 
        else 
        begin
            enableA <= 0;
            enableB <= 0;
            speed = 4;  //OFF
            in1 = 0;
            in2 = 0;
            in3 = 0;
        end
    end
   
    always@(*)begin                 //assigns width value to create PWM signal
    case(speed)
        2'd0 : width = 19'd196608; //25% duty cycle
        2'd1 : width = 19'd262144; //50% duty cycle
        2'd2 : width = 19'd393216; //75% duty cycle
        2'd3 : width = 19'd524287; //100% duty cycle
        default : width = 19'd0;
    endcase
    end
    // DISPLAY STUFF (NOT IMPORTANT)
    always@(posedge clock) begin
        if (resetn)                     //counter for 7-segment display multiplexing
            countn <= 0;
        else
            countn <= countn + 1;
    end
   
    always @(posedge clock)begin
        if(stop==0)begin
            if (count == 3000000)begin
                stop <= 1;
            end
            counter <= counter+1;
   
            if(counter < width)begin
                temp_PWM <= 1;
            end
            else begin
                temp_PWM <= 0;
            end
        end
        else begin
            if(stop == 1000)begin 
                stop <= 1;
            end
           
            stop <= stop + 1;
            temp_PWM <= 0;
           
            if(SW15)begin
                stop <= 0;
            end
        end
    end


   
    always@(*) begin    //Assigns direction for the two motors and updates the 7-seg to display direction
        if(SW4)begin                            //FORWARDS
            temp_PWM1 <= 1;
            temp_PWM2 <= 0;
            temp_PWM3 <= 0;
            temp_PWM4 <= 1;
            in0 <= 11;
        end
        if(SW5)begin                            //BACKWARDS
            temp_PWM1 <= 0;
            temp_PWM2 <= 1;
            temp_PWM3 <= 1;
            temp_PWM4 <= 0;
            in0 <= 10;
        end    
        if(SW6)begin                            //LEFT
            temp_PWM1 <= 0;
            temp_PWM2 <= 1;
            temp_PWM3 <= 0;
            temp_PWM4 <= 1;
            in0 <= 12;
        end  
        if(SW7)begin                            //RIGHT
            temp_PWM1 <= 1;
            temp_PWM2 <= 0;
            temp_PWM3 <= 1;
            temp_PWM4 <= 0;
            in0 <= 13;
        end  
        if(~SW4 && ~SW5 && ~SW6 && ~SW7)begin   //STOPPED if switches are not on
            temp_PWM1 <= 0;
            temp_PWM2 <= 0;
            temp_PWM3 <= 0;
            temp_PWM4 <= 0;
            in0 <= 15;
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
   
    assign {g, f, e, d, c, b, a} = sseg_temp;   //output the selected charater to segments a-g
   
    assign dp = 1'b1;       //The decimal point on the 7-seg display is always off
   
    assign I1 = temp_PWM1;  //Output power to the motors
    assign I2 = temp_PWM2;
    assign I3 = temp_PWM3;
    assign I4 = temp_PWM4;
   

endmodule

