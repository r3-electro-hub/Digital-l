module raiz32 (
    input clk,
    input rst,
    input start,

    input [31:0] A,

    output [31:0] Result,
    output done

);
    wire load, wr_a, shift_res, wr_res, shift_bit;

    wire z, a_ge_res_bit;

    wire [31:0] reg_A_out ;
    wire [31:0] reg_res_out ;
    wire [31:0] reg_bit_out ;

    wire [31:0] suma_out;
    wire [31:0] suma_res_out;
    wire [31:0] resta_out;

    reg_Basic reg_A(
        .clk(clk),
        .in(A),
        .alu_out(resta_out),
        .load(load),
        .wr(wr_a),
        .out(reg_A_out)
    );

    reg_Shift1 reg_Res(
        .clk(clk),
        .alu_out(suma_res_out),
        .shift(shift_res),
        .load(load),
        .wr(wr_res),
        .res(reg_res_out)
    );

    reg_Shift2 reg_Bit(
        .clk(clk),
        .shift(shift_bit),
        .load(load),
        .bit1(reg_bit_out)
    );

    sum  sum1(
        .A(reg_res_out),
        .B(reg_bit_out),
        .out_sum(suma_out)
    );
    sum  sumRes(
        .A(reg_res_out>>1),
        .B(reg_bit_out),
        .out_sum(suma_res_out)
    );

    subs subs1 (
        .A(reg_A_out),
        .B(suma_out),
        .out_subs(resta_out)
    );
    comp comp1(
        .A(reg_A_out),
        .out_sum(suma_out),
        .bit1(reg_bit_out),
        .z(z),
        .a_ge_res_bit(a_ge_res_bit)
    );
    control_raiz ctrl(
        .clk(clk),
        .start(start),
        .rst(rst),
        .z(z),
        .a_ge_res_bit(a_ge_res_bit),
        .load(load),
        .wr_a(wr_a),
        .shift_res(shift_res),
        .wr_res(wr_res),
        .shift_bit(shift_bit),
        .done(done)
    );


    assign Result = reg_res_out[31:0];
endmodule