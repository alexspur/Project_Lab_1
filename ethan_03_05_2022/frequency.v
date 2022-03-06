`timescale 1ns / 1ps


module Frequency_Signal_Detection(
    input JB7, JB8, JB9, clock,
    output reg [1:0] forward_signal, left_signal, right_signal
    );

    reg [31:0] counter;
    reg [16:0] forward_counter;
    reg [16:0] left_counter;
    reg [16:0] right_counter;
    reg last_forward, last_left, last_right;

    parameter   friendly_freq_high = 16,
                friendly_freq_low = 14,
                enemy_freq_high = 51,
                enemy_freq_low = 49,
                clock_max = 5000000;


    initial begin
        counter = 0;
        last_forward = 0;
        last_left = 0;
        last_right = 0;
        forward_counter = 0;   
        left_counter = 0;      
        right_counter = 0;
        forward_signal = 0;
        left_signal = 0;
        right_signal = 0;
    end


    always@(*) begin
        if (counter == 0) begin     // if one cycle completes
            counter <= clock_max;   // reset to max

            forward_counter <= 0;   // reset forward counter
            left_counter <= 0;      // reset left counter
            right_counter <= 0;     // reset right counter
        end
        else begin
            counter <= counter - 1; //decrement

            if (JB7 != last_forward)
                forward_counter <= forward_counter + 1;
            if (JB8 != last_left)
                left_counter <= left_counter + 1;
            if (JB9 != last_right)
                right_counter <= right_counter + 1;

            last_forward <= JB7;
            last_left <= JB8;
            last_right <= JB9;

        //--------------------FORWARD SIGNAL CONDITION CHECK---------------------//
        if ((forward_counter <= friendly_freq_high) && (forward_counter >= friendly_freq_low))
            forward_signal <= 2'b01; // friendly
        else if (forward_counter <= enemy_freq_high && forward_counter >= enemy_freq_low)
            forward_signal <= 2'b10; // enemy
        else
            forward_signal <= 2'b00; // no detection
        //--------------------LEFT SIGNAL CONDITION CHECK---------------------//
        if (left_counter <= friendly_freq_high && left_counter >= friendly_freq_low)
            left_signal <= 2'b01;
        else if (left_counter <= enemy_freq_high && left_counter >= enemy_freq_low)
            left_signal <= 2'b10;
        else
            left_signal <= 2'b00;
        //--------------------RIGHT SIGNAL CONDITION CHECK---------------------//
        if (right_counter <= friendly_freq_high && right_counter >= friendly_freq_low)
            right_signal <= 2'b01;
        else if (right_counter <= enemy_freq_high && right_counter >= enemy_freq_low)
            right_signal <= 2'b10;
        else
            right_signal <= 2'b00;

        end
    end

    //assign forwardLED = JB7;
    //assign leftLED = JB8;
    //assign rightLED = JB9;

endmodule
