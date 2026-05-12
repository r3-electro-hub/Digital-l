module left_shift(
    input clk,
    input [31:0] A_in,
    input load,
    input shift,
    output reg [31:0] s_A
);

always @(negedge clk)
begin
    if(load)
        s_A <= A_in;
    else if(shift)
        s_A <= s_A << 1;
end

endmodule