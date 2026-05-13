module contador (
    input clk,
    input reset,
    input dec,

    output reg [4:0] c
);


always @(negedge clk) begin

    if (reset) begin
        c <= 5'b10000;
    end

    else if (dec && c != 0) begin
        c <= c - 1'b1;
    end

end

endmodule