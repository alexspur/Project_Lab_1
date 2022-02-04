`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Oh yes
// Engineer: James Mcarthy
// 
// Create Date: 02/03/2022 01:44:14 PM
// Design Name: 
// Module Name: Mini_project
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


module Mini_project(

    input SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,SW15,
    input clock,
    output LED0,LED1,LED2,LED3,LED4,LED5,LED6,LED7,LED14,LED15,
    output a, b, c, d, e, f, g, dp,
    output [3:0] an,  
    output [3:0] JA
   
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
    reg [20:0] speed;
    reg [N-1:0]countn;
    reg [1:0] reset;
    reg [1:0] resetn;
    reg [6:0]sseg;
    reg [3:0]an_temp;
    reg [6:0] sseg_temp;
    reg [30:0] stop;
    reg LEDONOFF;
    reg JA_temp;
    reg JA0_temp, JA1_temp, JA2_temp, JA3_temp;
   
    assign LED14 = LEDONOFF;
   
    initial begin
        counter = 0;
        count = 0;
        countn = 0;
        
        speed = 0;
        stop = 0;
        width=0;
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
            
              //25% duty cycle
            in1 = 5;
            in2 = 2;
            in3 = 15;
        end 
        else if(SW1)
        begin
            
              //50% duty cycle
            in1 = 0;
            in2 = 5;
            in3 = 15;
        end 
        else if(SW2)
        begin
          
              //75% duty cycle
            in1 = 5;
            in2 = 7;
            in3 = 15;
        end 
        else if(SW3)
        begin
            
              //100% duty cycle
            in1 = 0;
            in2 = 0;
            in3 = 1;
        end 
        else 
        begin
            
            speed = 0; //OFF
            in1 = 0;
            in2 = 0;
            in3 = 0;
        end
    end
   
    always@(*)begin                 //assigns width value to create PWM signal
    case({SW3,SW2,SW1,SW0})
    4'b0001: speed=416667; //
    4'b0010: speed=833333;
    4'b0100: speed=1249999;
    4'b1000: speed=1666667;
    default: speed = 0;
    endcase
    end
    // DISPLAY STUFF (NOT IMPORTANT)
    always@(posedge clock) begin
        if (resetn)                     //counter for 7-segment display multiplexing
            countn <= 0;
        else
            countn <= countn + 1;
    end
   
   always@(posedge clock) begin
        
        if (counter == 1666667)  
            counter <= 0;
            
        else
            counter <= counter + 1;
        if(counter < speed)begin
                JA_temp <= 1;
            end
            else begin
                JA_temp <= 0;
            end
    end
    
   
    always @(*)begin
    if(SW4 && counter < speed) begin //Forwards
        JA0_temp = 1;
        JA1_temp = 0;
        JA2_temp = 0;
        JA3_temp = 1;
        
        
    end 
    else if(SW5 && counter < speed) begin //Backwards
        JA0_temp = 0;
        JA1_temp = 1;
        JA2_temp = 1;
        JA3_temp = 0;
        
    end 
    else if (SW6 && counter < speed) begin //Left
        JA0_temp = 0;
        JA1_temp = 1;
        JA2_temp = 0;
        JA3_temp = 1;
        
    end       
        
    if(SW6 && counter < speed) begin //Right
        JA0_temp = 1;
        JA1_temp = 0;
        JA2_temp = 1;
        JA3_temp = 0;
        
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
   
    
   assign JA[0] = JA0_temp;
   assign JA[1] = JA1_temp; 
   assign JA[2] = JA2_temp; 
   assign JA[3] = JA3_temp;
   
   

endmodule
