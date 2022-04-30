`timescale 1ns / 1ps


module Frequency_Signal_Detection(
    input JB7, JB8, JB9, clock,
    output [1:0] forward_signal, left_signal, right_signal,
    output LED9, LED12, LED13
    );
    reg LED9_temp, LED12_temp, LED13_temp;
    reg [31:0] counter, delay1, delay2, delay3;
    reg [16:0] forward_counter;
    reg [16:0] left_counter;
    reg [16:0] right_counter;
    reg last_forward, last_left, last_right, latch1, latch2, latch3;
    reg [5:0] signal_temp, last_signal, return_signal, previous_signal;
    parameter   friendly_freq_high = 33,
                friendly_freq_low = 8,
                enemy_freq_high = 90,
                enemy_freq_low = 34,
                clock_max = 5000000;


    initial begin
        counter = 0;
        last_forward = 0;
        last_left = 0;
        last_right = 0;
        forward_counter = 0;   
        left_counter = 0;      
        right_counter = 0;
        signal_temp[1:0] <= 0;
        signal_temp[5:4] <= 0;
        signal_temp[3:2] <= 0;
        previous_signal[1:0] <= 0;
        previous_signal[3:2] <= 0;
        previous_signal[5:4] <= 0;
        last_signal[1:0] <= 0;
        last_signal[3:2] <= 0;
        last_signal[5:4] <= 0;
        delay1 = 0;
        delay2 = 0;
        delay3 = 0;
        latch1 = 0;
        latch2 = 0;
        latch3 = 0;
    end


    always@(posedge clock) begin
        if (counter == 0) begin     // if one cycle completes
            counter <= clock_max;   // reset to max
            if(last_signal[1:0] == 2'b00) begin
                LED13_temp <= 1;
                LED12_temp <= 0;
                LED9_temp <= 0; end
            else if(last_signal[1:0] == 2'b01) begin
                LED9_temp <= 1;
                LED13_temp <= 0;
                LED12_temp <= 0; end
            else if(last_signal[1:0] == 2'b10) begin
                LED12_temp <= 1;
                LED9_temp <= 0;
                LED13_temp <= 0; end

            forward_counter = 0;   // reset forward counter
            left_counter = 0;      // reset left counter                         (made non-blocking)
            right_counter = 0;     // reset right counter
            
            last_signal[1:0] <= signal_temp[1:0];
            last_signal[3:2] <= signal_temp[3:2];
            last_signal[5:4] <= signal_temp[5:4];
            
            previous_signal[1:0] <= last_signal[1:0];
            previous_signal[3:2] <= last_signal[3:2];
            previous_signal[5:4] <= last_signal[5:4];
            
            if(last_signal[1:0] != 2'b00 && delay1 < 2)
                delay1 <= delay1 + 1;     
            else if(last_signal[1:0] == 2'b00 || previous_signal[3:2] != last_signal[3:2]) begin
                delay1 <= 0;
                latch1 <= 0;
            end
            else if(delay1 >= 2)
                latch1 <= 1;
                        
            if(last_signal[3:2] != 2'b00 && delay2 < 2)
                delay2 <= delay2 + 1;     
            else if(last_signal[3:2] == 2'b00 || previous_signal[3:2] != last_signal[3:2]) begin
                delay2 <= 0;    
                latch2 <= 0;
            end
            else if(delay2 >= 2)
                latch2 <= 1;
                        
            if(last_signal[5:4] != 2'b00 && delay3 < 2)
                delay3 <= delay3 + 1;     
            else if(last_signal[5:4] == 2'b00 || previous_signal[5:4] != last_signal[5:4]) begin
                delay3 <= 0;    
                latch3 <= 0;
            end
            else if(delay3 >= 2)
                latch3 <= 1;
            
            if(latch1 == 1)
                return_signal[1:0] <= last_signal[1:0];
            else if(latch1 == 0)
                return_signal[1:0] <= 2'b00;
                        
            if(latch2 == 1)
                return_signal[3:2] <= last_signal[3:2];
            else if(latch2 == 0)
                return_signal[3:2] <= 2'b00; 
                           
            if(latch3 == 1)
                return_signal[5:4] <= last_signal[5:4];
            else if(latch3 == 0)
                return_signal[5:4] <= 2'b00;
            
            
            
        end
        else begin
            counter <= counter - 1; //decrement

            if (JB7 != last_forward && last_forward == 0)
                forward_counter <= forward_counter + 1;
            if (JB8 != last_left && last_left == 0)
                left_counter <= left_counter + 1;
            if (JB9 != last_right && last_right == 0)
                right_counter <= right_counter + 1;

            last_forward <= JB7;
            last_left <= JB8;
            last_right <= JB9;
            //--------------------FORWARD SIGNAL CONDITION CHECK---------------------//
            if (((forward_counter <= friendly_freq_high) && (forward_counter >= friendly_freq_low))) begin
                signal_temp[1:0] <= 2'b01; // friendly 
                //LED9_temp <= 1; 
                end
            else if ((forward_counter <= enemy_freq_high && forward_counter >= enemy_freq_low)) begin
                signal_temp[1:0] <= 2'b10; // enemy
                //LED12_temp <= 1; 
                end
            else begin
                signal_temp[1:0] <= 2'b00; // no detection
                //LED13_temp <= 1; 
                end
            //--------------------LEFT SIGNAL CONDITION CHECK---------------------//
            if ((left_counter <= friendly_freq_high && left_counter >= friendly_freq_low)) begin  //&& counter <= clock_thresh
                signal_temp[5:4] <= 2'b01;
                //LED9_temp <= 1; 
                end
            else if ((left_counter >= enemy_freq_low && left_counter <= enemy_freq_high)) begin
                signal_temp[5:4] <= 2'b10;
                //LED9_temp <= 1; 
                end
            else if ((left_counter < friendly_freq_low || left_counter > enemy_freq_high)) begin
                signal_temp[5:4] <= 2'b00;
                //LED9_temp <= 0; 
                end
        //--------------------RIGHT SIGNAL CONDITION CHECK---------------------//
        if ((right_counter <= friendly_freq_high && right_counter >= friendly_freq_low)) begin
            signal_temp[3:2] <= 2'b01;
            //LED9_temp <= 1; 
            end
        else if ((right_counter <= enemy_freq_high && right_counter >= enemy_freq_low)) begin
            signal_temp[3:2] <= 2'b10;
            //LED9_temp <= 1; 
            end
        else begin
            signal_temp[3:2] <= 2'b00;
            //LED9_temp <= 0; 
            end

        end
    end
    assign LED9 = LED9_temp;
    assign LED12 = LED12_temp;
    assign LED13 = LED13_temp;
    assign forward_signal[1:0] = return_signal[1:0];
    assign right_signal[1:0] = return_signal[3:2];
    assign left_signal[1:0] = return_signal[5:4];

endmodule
