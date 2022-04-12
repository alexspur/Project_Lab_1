`timescale 1ns / 1ps


module Pico_project_MotorDriver(

    input reset,
	input compA, compB, JB1, JB2, JB3, clock,
	output reg [3:0] direction, M, L, R, L2, R2,
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
			M = 1;
			L = 0;
			R = 0;
			R2 = 0;
			L2 = 0;
			direction = stop_control;
        end
//----------CHANGE DETECTION BASED CONTROL-----------------------------------
        always @ (posedge clock) begin
            if(reset || compA == 0 || compB == 0) begin
                direction <= stop_control;
                end
            else begin
            if ((JB1 && JB2 && JB3) || (!JB1 && !JB2 && !JB3) || (JB1 && !JB2 && !JB3))begin // If no sensor detection, go back
            if (R == 1)
            direction <= right_control;
            if (L == 1)
            direction <= left_control;            
            end
               
            if((!JB1 && JB2 && JB3) || (((!JB1 && !JB2 && JB3) || (!JB1 && JB2 && !JB3)) && (R2 == 0 || L2 == 0)))
            direction = forward_control;
           
            if (!JB1 && !JB2 && JB3) begin // if left turn (middle and left)
            M = 0;
            L = 1;
            R = 0;
            R2 = 0;
            L2 = 0;
            end
            if ((JB1 && !JB2 && JB3) && (R != 1)) begin  // if left (only left) AND it was left and middle befor)
            direction = left_control;
            L2 = 1;
            end
            
            if (!JB1 && JB2 && !JB3) begin // if right turn (middle and right)
            M = 0;
            L = 0;
            R = 1;
            R2 = 0;
            L2 = 0;
            end
            if ((JB1 && JB2 && !JB3 && (L != 1))) begin // if right (only right) AND it was (right and middle before)
            direction a= right_control;
            R2 = 1;
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
