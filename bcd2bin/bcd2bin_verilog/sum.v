module sum (
    input [3:0]     A,
    input [3:0]    B,
    output reg [3:0]    sum_out
);

always @(*) begin
    sum_out = A + B;
end

endmodule