module right_shift(
    input clk,
    input [15:0] B_in,
    input load,
    input shift,
    output reg [15:0] shift_B
);

always @(negedge clk)
begin
    if(load)
        shift_B <= B_in;
    else if(shift)
        shift_B <= shift_B >> 1;
end

endmodule