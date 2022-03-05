`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2022 12:21:06 PM
// Design Name: 
// Module Name: Nano_project_MotorDriver
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


module Pico_project_MotorDriver(

    input reset,
	input compA, compB, JB1, JB2, JB3,
	output reg [3:0] direction,
    output JA1, JA2, JA3, JA4
    );
		//-------------STATE DECODING----------------------------------		
        localparam stop = 4'b0000;
		localparam forward = 4'b0001;
		localparam backward = 4'b0010;
		localparam right = 4'b0100;
		localparam left = 4'b1000;
	//------------------STATE ENCODING----------------------------------	
		localparam stop_control = 4'b0000;
		localparam forward_control = 4'b1001; 
		localparam backward_control = 4'b0110;
		localparam right_control = 4'b0101;
		localparam left_control = 4'b1010;
		
//-------------PARAMETER INITIALIZATION------------------------
        initial begin
			direction = stop_control;
			
        end
//----------CHANGE DETECTION BASED CONTROL-----------------------------------
        always @ (*) begin
            if(reset || compA == 0 || compB == 0) begin
                direction = stop_control;
                end
            else begin
            if (JB1 && JB2 && JB3) // If no sensor detection, go back
            direction = backward_control;
       
            else if (!JB1 && JB2 && JB3) // If only the middle sensor is activated, go forward
            direction = forward_control;
            
            else if (!JB1 && JB2 && !JB3)begin // if turning right
                if( !JB1 && !JB2 && !JB3) // if while turning right, a left sensor is detected, turn left (90 degree turn).
                direction = left_control;
                else
                direction = right_control; // else keep turning right
            end
            
            else if (!JB1 && !JB2 && JB3) begin // if turning left
                if (!JB1 && !JB2 & !JB3) // if while turning left, a right sensor is detected, turn right (90 degrees)
                direction = right_control;
                else
                direction = left_control; // else keep turning left
            end
		  end
        end

//---------FINAL OUTPUT ASSIGNMENTS-----------------------------------------

	//set control bits to value of control switches
	assign JA1 = direction[0];
	assign JA2 = direction[1];
	assign JA3 = direction[2];
	assign JA4 = direction[3];
	
endmodule
