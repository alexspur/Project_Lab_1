module frequencytest;
    reg JB7, JB8, JB9, clock;
    output [1:0] forward_signal, left_signal, right_signal;
    reg [16:0] delay;

    initial begin
     $dumpfile("frequencytest.vcd");
     $dumpvars(0,frequencytest);
    end

    Frequency_Signal_Detection UUT (.JB7(JB7), .JB8(JB8), .JB9(JB9),
                                    .forward_signal(forward_signal), .left_signal(left_signal),
                                    .right_signal(right_signal));

    always #1 clock = !clock;
    always @(posedge clock) begin
        if (delay == 100000) begin // it's just 5 million divided by 50, so enemy detection
            JB7 <= ~JB7;
            JB8 <= ~JB8;
            JB9 <= ~JB9; 
            delay <= 0; end
        else
            delay <= delay + 1;
    end


endmodule
