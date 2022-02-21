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
	input [5:0] state,
	input compA,compB,
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
			direction = 0;
			
        end
//----------CHANGE DETECTION BASED CONTROL-----------------------------------
	always @ (*) begin						// at every positive and negative edge of the clock
		if(reset || compA == 0 || compB == 0) begin			// if the reset button is pressed or overcurrent protection is triggered
                	direction = stop_control;					// stop all movement
                end								
            	else begin							// else
			case(state)							// case statement for the "state" input
				stop : begin							// if the case is "stop" 
					direction = 0;							// no direction
				end
				forward : begin							// if the case is "forward"
					direction = forward_control;					// go forwards
				end
				backward : begin						// if the case is "backward"
					direction = backward_control;					// go backwards
				end
				right : begin							// if the case is "right"
					direction = right_control;					// turn right
				end
				left : begin							// if the case is "left"
					direction = left_control;					// turn left
				end
				default : begin							// if no switch is on
					direction = 0;							// no direction
				end
			endcase
		  end
        end

//---------FINAL OUTPUT ASSIGNMENTS-----------------------------------------

	//set control bits to value of control switches
	assign JA1 = direction[0];
	assign JA2 = direction[1];
	assign JA3 = direction[2];
	assign JA4 = direction[3];
	
endmodule
