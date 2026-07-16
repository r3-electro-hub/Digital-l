module comp #(
    parameter VALUE = 10,
    parameter BITS  = 10 
) (
    input  [BITS-1:0] A,
    output            z   
);

    assign z = (A == VALUE);

endmodule