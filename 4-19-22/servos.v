`timescale 1ns / 1ps

module servo_controller(
    input clock,
    input [1:0] forward_signal, left_signal, right_signal,
    output aim_servo, fire_servo, aiming
);
    reg [21:0] counter;
    reg [23:0] fire_counter;
    reg aiming_reg, firing_reg, fired, aiming_temp;
    reg [4:0] how_many_times_has_this_fool_fired, fool_next;
    reg [17:0] aim_control = 0;
    reg [17:0] fire_control = 0;
    reg [17:0] release_next = 0;    // initialize this to whatever then start incrementing by release_rband for each fire
    parameter   aim_left = 0,      // full left turn
                aim_right = 200000,      // full right turn
                aim_forward = 100000,   // forward on servo
                release_rband = 50000; // enough spin to release a single rubber band
    initial begin
        counter = 0;
        aiming_temp = 0;
        aiming_reg = 0;
        firing_reg = 0;
        fired = 0;
        fire_counter = 0;
        release_next = 0;
        how_many_times_has_this_fool_fired = 0;
        fool_next = 1;
    end
    
    
    always @(posedge clock) begin
        counter <= counter  + 1;
        if (counter == 'd1999999) // maybe change to 10ms instead of 20ms period width? ie 1999999 --> 999999
            counter <= 0;
        if(counter < ('d70000 + aim_control))
            aiming_reg <= 1;
        else
            aiming_reg <= 0;
        if(counter < ('d70000 + release_next))
            firing_reg <= 1;
        else
            firing_reg <= 0;
        if (fire_counter > 'd100000 && !fired) begin
            fire_counter <= 'd0;
            fired <= 1;     // latch so you don't fire twice
                        
            if(how_many_times_has_this_fool_fired < 'd2 && !fired) begin
                how_many_times_has_this_fool_fired <= how_many_times_has_this_fool_fired + 1;
                release_next <= 40000; // get ready to fire the next rubber band
            end
            
            else if(how_many_times_has_this_fool_fired < 'd4 && how_many_times_has_this_fool_fired >= 'd2 && !fired) begin
                how_many_times_has_this_fool_fired <= how_many_times_has_this_fool_fired + 1;
                release_next <= 80000;
            end
                        
            else if(how_many_times_has_this_fool_fired < 'd6 && how_many_times_has_this_fool_fired >= 'd4 && !fired) begin
                how_many_times_has_this_fool_fired <= how_many_times_has_this_fool_fired + 1;
                release_next <= 120000;
            end 
                        
            else if(how_many_times_has_this_fool_fired >= 'd6 && !fired) begin
                if(how_many_times_has_this_fool_fired == 'd6)
                    how_many_times_has_this_fool_fired <= 'd7;
                else if(how_many_times_has_this_fool_fired == 'd7)
                    how_many_times_has_this_fool_fired <= 0;
                release_next <= 0;
            end
        end 

        if (forward_signal == 2'b10  && !fired) begin                 // front phototransistor detects new enemy
            fire_control <= release_next;                           // make it turn enough to fire once
            fire_counter <= fire_counter + 1; end
        else if (left_signal == 2'b10 && !fired) begin          // left phototransistor detects new enemy
            /*if(aim_control > aim_left)
                aim_control <= aim_control - 1;
            else */
            aim_control <= aim_left;                                // make it turn all the way to the left
            aiming_temp <= 1; end                                   // stop the rover     
        else if (right_signal == 2'b10 && !fired) begin         // right phototransistor detects enemy
            aim_control <= aim_right;                               // make it turn all the way to the right
            aiming_temp <= 1; end                                   // stop the rover       
        else if ((forward_signal || left_signal || right_signal) && fired) // same hit target is detected, but nothing new
            aiming_temp <= 0;                                       // let the rover resume
        else begin      // nothing detected at all (triggers reset)
            fired <= 0; // be ready to fire next time it sees a new enemy
            aiming_temp <= 0;   // possibly redundant as long as it's initialized as 0, but just to be on the safe side
            aim_control <= aim_forward;
            end
        
    end

 assign aiming = aiming_temp;
 assign aim_servo = aiming_reg;
 assign fire_servo = firing_reg;
    
endmodule
