module reg_Basic(
    input clk,
    input [31:0] in,
    input [31:0] alu_out,
    input load,
    input wr,

    output reg [31:0] out
);

always @(negedge clk) begin

    if(load)
        out <= in;

    else if(wr)
        out <= alu_out;

end

endmodule