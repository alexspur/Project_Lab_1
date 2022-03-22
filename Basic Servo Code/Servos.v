`timescale 1ns / 1ps

module servo_controller(
    input clock, SW8, SW9, SW10,
    output servo, LED10
);
    reg [21:0] counter;
    reg servo_reg;
    reg [17:0] control = 0;
    reg toggle = 1;
    
    
    always @(posedge clock) begin
        counter <= counter  + 1;
        if (counter == 'd1999999) // maybe change to 10ms instead of 20ms period width? ie 1999999 --> 999999
            counter <= 0;
        if(counter < ('d70000 + control)) // 70000 correlates to 0 degrees for the HS-422 servo
            servo_reg <= 1;
        else
            servo_reg <= 0;

        if (SW8)
        control <= 'd0;
        if (SW9)
        control <= 'd50000;
        if (SW10)
        control <= 'd150000;
        
    end

 assign servo = servo_reg;
 assign LED10 = SW8;
    
endmodule
