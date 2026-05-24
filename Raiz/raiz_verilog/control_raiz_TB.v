`timescale 1ns / 1ps

module control_raiz_TB;

reg clk;
reg start;
reg rst;

reg z;
reg bit_gt_a;
reg a_ge_temp;

wire load;
wire wr_a;

wire shift_res;
wire wr_res;

wire shift_bit;
wire wr_bit;

wire wr_temp;

wire [1:0] sel_A;
wire [1:0] sel_B;

wire sel_op;

wire done;

control_raiz DUT(

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

parameter PERIOD = 20;

initial
    clk = 0;

always #(PERIOD/2)
    clk = ~clk;

initial begin

    rst = 0;
    start = 0;

    z = 0;
    bit_gt_a = 0;
    a_ge_temp = 0;

    @(negedge clk);
    rst = 1;

    @(negedge clk);
    rst = 0;

    @(negedge clk);
    start = 1;

    // INIT

    @(negedge clk);

    // while(bit > A)

    bit_gt_a = 1;

    @(negedge clk);

    bit_gt_a = 1;

    @(negedge clk);

    bit_gt_a = 0;

    // while(bit != 0)

    z = 0;

    @(negedge clk);

    // temp = res + bit

    @(negedge clk);

    // if(A >= temp)

    a_ge_temp = 1;

    @(negedge clk);

    // A = A - temp

    @(negedge clk);

    // res = res >> 1

    @(negedge clk);

    // res = res + bit

    @(negedge clk);

    // bit = bit >> 2

    @(negedge clk);

    // segunda iteración

    z = 0;
    a_ge_temp = 0;

    @(negedge clk);

    // temp = res + bit

    @(negedge clk);

    // A < temp

    @(negedge clk);

    // res = res >> 1

    @(negedge clk);

    // bit = bit >> 2

    @(negedge clk);

    // fin del algoritmo

    z = 1;

    @(negedge clk);

    if(done)
        $display("PASS");
    else
        $display("FAIL");

    #40;

    $finish;

end

initial begin

    $dumpfile("control_raiz_TB.vcd");
    $dumpvars(0, control_raiz_TB);

end

endmodule