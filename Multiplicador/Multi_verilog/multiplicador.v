module multiplicador(
    input reset,
    input clk,
    input start,
    input [15:0] A,
    input [15:0] B,
    output [31:0] p,
    output done
);

wire w_sh;
wire w_reset;
wire w_add;
wire w_z;

wire [31:0] w_A;
wire [15:0] w_B;

right_shift right_shift0 (
    .clk(clk),
    .B_in(B),
    .load(w_reset),
    .shift(w_sh),
    .shift_B(w_B)
);

left_shift left_shift0 (
    .clk(clk),
    .A_in({16'b0, A}),
    .load(w_reset),
    .shift(w_sh),
    .s_A(w_A)
);

comparador comparador0 (
    .B(w_B),
    .z(w_z)
);

accum accum0 (
    .clk(clk),
    .A(w_A),
    .add(w_add),
    .reset(w_reset),
    .p(p)
);

control control0 (
    .clk(clk),
    .rst(reset),
    .lsb_B(w_B[0]),
    .start(start),
    .z(w_z),
    .done(done),
    .shft(w_sh),
    .reset_out(w_reset),
    .add(w_add)
);

endmodule