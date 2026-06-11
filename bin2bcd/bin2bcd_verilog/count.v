module count (
    input   clk,
    input   reset,
    input   dec,
    output  z
);

reg [4:0] c;

always @(negedge clk) begin
    if (reset)
        c <= 5'b10000;   // 16
    else if (dec)
        c <= c - 1;
end

assign z = (c == 0);

endmodule