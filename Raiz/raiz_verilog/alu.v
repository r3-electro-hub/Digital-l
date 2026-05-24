module alu (
    input [31:0] A,
    input [31:0] B,
    input alu_op,

    output reg [31:0] result
);

always @(*) begin

    case(alu_op)

        0:
            result = A + B;

        1:
            result = A - B;

    endcase

end
    
endmodule