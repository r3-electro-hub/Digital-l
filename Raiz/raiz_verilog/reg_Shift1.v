module reg_Shift1(
    input clk,

    input [31:0] alu_out,

    input shift,
    input load,
    input wr,

    output reg [31:0] res
);

always @(negedge clk) begin

    if(load)
        res <= 0;

    else if(wr)
        res <= alu_out;

    else if(shift)
        res <= res >> 1;

end

endmodule