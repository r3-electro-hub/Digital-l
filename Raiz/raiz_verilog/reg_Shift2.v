module reg_Shift2(
    input clk,

    input [31:0] alu_out,

    input shift,
    input load,
    input wr,

    output reg [31:0] bit1
);

always @(negedge clk) begin

    if(load)
        bit1 <= 32'h40000000;

    else if(wr)
        bit1 <= alu_out;

    else if(shift)
        bit1 <= bit1 >> 2;

end

endmodule