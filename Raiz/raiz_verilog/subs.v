module subs (
    input [31:0] A,
    input [31:0] B,

    output [31:0] out_subs
);

assign out_subs = A-B;
endmodule