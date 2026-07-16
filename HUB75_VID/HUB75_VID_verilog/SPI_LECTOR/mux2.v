module mux2 (
    input [7:0]     A,
    input [23:0]    B,
    input           sel,
    output          out_mux
);

    assign out_mux = (sel == 1'b1) ? B[23] : A[7];
    
endmodule