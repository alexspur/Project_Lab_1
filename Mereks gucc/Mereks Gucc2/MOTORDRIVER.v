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
        always @ (*) begin
            if(reset || !compA || !compB) begin
                direction = stop_control;
                
                
                end
            else begin
			case(state)
				stop : begin
					direction = 0;
					
				end
				forward : begin
					direction = forward_control;

				end
				
				backward : begin
					direction = backward_control;
					
				end
				
				right : begin
					direction = right_control;
					
				end
				
				left : begin
					direction = left_control;
					
				end
				
				default : begin
					direction = 0;
					
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
