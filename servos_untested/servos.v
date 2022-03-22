`timescale 1ns / 1ps

module servo_controller(
    input clock,
    input [1:0] forward_signal, left_signal, right_signal,
    output aim_servo, fire_servo, aiming
);
    reg [21:0] counter;
    reg aiming_reg, firing_reg, fired, aiming_temp;
    reg [17:0] aim_control = 0;
    reg [17:0] fire_control = 0;
    reg [17:0] release_next = 0;    // initialize this to whatever then start incrementing by release_rband for each fire
    parameter   aim_left = 33,      // full left turn ETHAN change this to 0
                aim_right = 8,      // full right turn ETHAN change this to 100000
                aim_forward = 90,   // forward on servo ETHAN change this to 200000
                release_rband = 3; // enough spin to release a single rubber band ETHAN a 45 degree turn is 45) 50000 - 90) 100000 - 135) 150000
    initial begin
        counter = 0;
        aiming_temp = 0;
        aiming_reg = 0;
        firing_reg = 0;
        fired = 0;
    end
    
    
    always @(posedge clock) begin
        counter <= counter  + 1;
        if (counter == 'd1999999) // Good value
            counter <= 0;
        if(counter < ('d70000 + aim_control))
            aiming_reg <= 1;
        else
            aiming_reg <= 0;
        if(counter < ('d70000 + fire_control))
            firing_reg <= 1;
        else begin
            firing_reg <= 0;
            release_next <= release_next + release_rband;   // get ready to fire the next rubber band
            fired <= 1; end     // latch so you don't fire twice
            

        if (forward_signal == 2'b10  && !fired)                 // front phototransistor detects new enemy
            fire_control <= release_next;                           // make it turn enough to fire once
        else if (left_signal == 2'b10 && !fired) begin          // left phototransistor detects new enemy
            aim_control <= aim_left;                                // make it turn all the way to the left
            aiming_temp <= 1; end                                   // stop the rover     
        else if (right_signal == 2'b10 && !fired) begin         // right phototransistor detects enemy
            aim_control <= aim_right;                               // make it turn all the way to the right
            aiming_temp <= 1; end                                   // stop the rover       
        else if ((forward_signal || left_signal || right_signal) && fired) // same hit target is detected, but nothing new
            aiming_temp <= 0;                                       // let the rover resume
        else       // nothing detected at all (triggers reset)
            fired <= 0; // be ready to fire next time it sees a new enemy
            //aiming_temp <= 0;   // possibly redundant as long as it's initialized as 0, but just to be on the safe side
        
    end

 assign aiming = aiming_temp;
 assign aim_servo = aiming_reg;
 assign fire_servo = firing_reg;
    
endmodule
