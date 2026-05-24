module raiz32 (
    input clk,
    input rst,
    input start,

    input [31:0] A,

    output [31:0] Result,
    output done

);

    wire load, wr_a, shift_res, wr_res, shift_bit, wr_bit, wr_temp, sel_op;
    wire [1:0] sel_A;
    wire [1:0] sel_B;
    wire z, bit_gt_a, a_ge_temp;
    wire [31:0] alu_out;

    wire [31:0] reg_A_out ;
    wire [31:0] reg_res_out ;
    wire [31:0] reg_bit_out ;
    wire [31:0] reg_temp_out ;

    wire [31:0] aluA_in ;
    wire [31:0] aluB_in ;


    reg_Basic reg_A(
        .clk(clk),
        .in(A),
        .alu_out(alu_out),
        .load(load),
        .wr(wr_a),
        .out(reg_A_out)
    );
    reg_Shift1 reg_res(
        .clk(clk),
        .alu_out(alu_out),
        .shift(shift_res),
        .load(load),
        .wr(wr_res),
        .res(reg_res_out)
    );
    reg_Shift2 reg_bit(
        .clk(clk),
        .alu_out(alu_out),
        .shift(shift_bit),
        .load(load),
        .wr(wr_bit),
        .bit1(reg_bit_out)
    );
    reg_Basic reg_temp(
        .clk(clk),
        .in(32'b0),
        .alu_out(alu_out),
        .load(load),
        .wr(wr_temp),
        .out(reg_temp_out)
    );

    mux muxA(
        .A(reg_bit_out),
        .B(reg_res_out),
        .C(reg_A_out),
        .sel(sel_A),
        .Y(aluA_in)
    );
    mux muxB(
        .A(reg_res_out),
        .B(reg_bit_out),
        .C(reg_temp_out),
        .sel(sel_B),
        .Y(aluB_in)
    );
    alu alu1(
        .A(aluA_in),
        .B(aluB_in),
        .alu_op(sel_op),
        .result(alu_out)
    );
    comp comp1(
        .A(reg_A_out),
        .bit1(reg_bit_out),
        .temp(reg_temp_out),
        .z(z),
        .bit_gt_a(bit_gt_a),
        .a_ge_temp(a_ge_temp)
    );
    control_raiz ctrl(
        .clk(clk),
        .start(start),
        .rst(rst),
        .z(z),
        .bit_gt_a(bit_gt_a),
        .a_ge_temp(a_ge_temp),
        .load(load),
        .wr_a(wr_a),
        .shift_res(shift_res),
        .wr_res(wr_res),
        .shift_bit(shift_bit),
        .wr_bit(wr_bit),
        .wr_temp(wr_temp),
        .sel_A(sel_A),
        .sel_B(sel_B),
        .sel_op(sel_op),
        .done(done)
    );
    assign Result = reg_res_out[15:0];
endmodule