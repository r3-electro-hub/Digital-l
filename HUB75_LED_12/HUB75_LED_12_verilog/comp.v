module comp #(
    parameter BITS  = 10 
) (
    input  [BITS-1:0] A,
    input  [BITS-1:0] B,
    output            z   
);

    assign z = (A == B);

endmodule