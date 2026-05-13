module left_shift_register(

    input clk,
    input reset,
    input shift,
    input r_A,
    input lsb_dv,

    input [15:0] DV_in,
    input [15:0] A_in,

    output reg [15:0] A,
    output [15:0] r_out
);

reg [15:0] DV;

assign r_out = DV;

always @(negedge clk) begin

    if (reset) begin

        A  <= 0;
        DV <= DV_in;

    end

    else if (shift) begin

        {A,DV} <= {A,DV} << 1;

    end

    else if (r_A) begin

        A <= A_in;

        if(lsb_dv)
            DV[0] <= 1'b1;
        else
            DV[0] <= 1'b0;

    end
end

endmodule