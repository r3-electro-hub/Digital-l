module check_c (
    input [4:0] c,
    output z
);

 assign z = (c == 0);
endmodule