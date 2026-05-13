module left_shift_register(
    input clk,
    input reset,
    input shift,
    input r_A,
    input lsb_dv, //no se usa pero es practico tenerlo en cuenta para la ASM

    input [15:0] DV_in,
    input [15:0] A_in,

    output reg [15:0] A,
    output reg [15:0] r_out
);

reg [15:0] DV;

always @(negedge clk) begin
    if (reset) begin
        A     <= 0;
        DV    <= DV_in;
        r_out <= 0;
    end

    else if (shift) begin
        {A,DV} <= {A,DV} << 1;
        r_out <= DV;
    end

    else if (r_A) begin
        A     <= A_in;
        DV[0] <= 1'b1;
    end
end

endmodule