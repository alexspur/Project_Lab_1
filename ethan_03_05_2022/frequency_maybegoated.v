`timescale 1ns / 1ps


module Frequency_Signal_Detection(
    input JB7, JB8, JB9, clock,
    output [1:0] forward_signal, left_signal, right_signal,
    output LED9, signal_reset
    );
    reg LED9_temp, signal_reset_temp;
    reg [31:0] counter;
    reg [16:0] forward_counter;
    reg [16:0] left_counter;
    reg [16:0] right_counter;
    reg last_forward, last_left, last_right;
    reg [5:0] signal_temp, last_signal;
    parameter   friendly_freq_high = 16,
                friendly_freq_low = 14,
                enemy_freq_high = 51,
                enemy_freq_low = 49,
                clock_thresh = 10,
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
        signal_reset_temp = 0;
    end


    always@(posedge clock) begin
        if (counter == 0) begin     // if one cycle completes
            counter <= clock_max;   // reset to max
            signal_reset_temp <= 1;

            forward_counter = 0;   // reset forward counter
            left_counter = 0;      // reset left counter
            right_counter = 0;     // reset right counter
            
            last_signal[1:0] <= signal_temp[1:0];
            last_signal[3:2] <= signal_temp[3:2];
            last_signal[5:4] <= signal_temp[5:4];     
        end
        else begin
            signal_reset_temp <= 0;
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
                LED9_temp <= 1; end
            else if ((forward_counter <= enemy_freq_high && forward_counter >= enemy_freq_low)) begin
                signal_temp[1:0] <= 2'b10; // enemy
                LED9_temp <= 1; end
            else begin
                signal_temp[1:0] <= 2'b00; // no detection
                LED9_temp <= 0; end
            //--------------------LEFT SIGNAL CONDITION CHECK---------------------//
            if ((left_counter <= friendly_freq_high && left_counter >= friendly_freq_low)) begin  //&& counter <= clock_thresh
                signal_temp[5:4] <= 2'b01;
                LED9_temp <= 1; end
            else if ((left_counter >= enemy_freq_low && left_counter <= enemy_freq_high)) begin
                signal_temp[5:4] <= 2'b10;
                LED9_temp <= 1; end
            else if ((left_counter < friendly_freq_low || left_counter > enemy_freq_high)) begin
                signal_temp[5:4] <= 2'b00;
                LED9_temp <= 0; end
        //--------------------RIGHT SIGNAL CONDITION CHECK---------------------//
        if ((right_counter <= friendly_freq_high && right_counter >= friendly_freq_low)) begin
            signal_temp[3:2] <= 2'b01;
            LED9_temp <= 1; end
        else if ((right_counter <= enemy_freq_high && right_counter >= enemy_freq_low)) begin
            signal_temp[3:2] <= 2'b10;
            LED9_temp <= 1; end
        else begin
            signal_temp[3:2] <= 2'b00;
            LED9_temp <= 0; end

        end
    end
    assign LED9 = LED9_temp;
    assign forward_signal[1:0] = last_signal[1:0];
    assign right_signal[1:0] = last_signal[3:2];
    assign left_signal[1:0] = last_signal[5:4];
    assign signal_reset = signal_reset_temp;

    //assign forwardLED = JB7;
    //assign leftLED = JB8;
    //assign rightLED = JB9;

endmodule
