module comp (

    input [31:0] A,
    input [31:0] bit1,
    input [31:0] temp,

    output z,
    output bit_gt_a,
    output a_ge_temp

);

assign z = (bit1 == 0);
assign bit_gt_a   = (bit1 > A);
assign a_ge_temp  = (A >= temp);

endmodule