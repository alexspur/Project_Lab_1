module IPS_tutorial (
    input signal,
    output LED
);

assign LED = ~signal;

endmodule


