module sum (
    input [31:0] A,
    input [31:0] B,

    output [31:0] out_sum
);

assign out_sum = A+B;
endmodule