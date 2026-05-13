module resta (

    input  [15:0] A_in,
    input  [15:0] DR_in,

    output reg MSB_A,
    output reg [15:0] A

);

reg [15:0] temp;

always @(*) begin

    temp = A_in + (~DR_in) + 16'd1;

    A     = temp;
    MSB_A = temp[15];

end

endmodule