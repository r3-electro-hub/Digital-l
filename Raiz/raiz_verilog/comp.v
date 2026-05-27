module comp (
    input [31:0] A,
    input [31:0] out_sum,
    input [31:0] bit1,

    output z,
    output a_ge_res_bit
);

assign z = (bit1 == 0);
assign a_ge_res_bit  = (A >= out_sum);

endmodule