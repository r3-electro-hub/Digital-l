`timescale 1ns / 1ps

module control_raiz_TB;

reg clk;
reg start;
reg rst;

reg z;

reg a_ge_res_bit;

wire load;
wire wr_a;

wire shift_res;
wire wr_res;

wire shift_bit;
wire done;

control_raiz DUT(

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

parameter PERIOD = 20;

initial
    clk = 0;

always #(PERIOD/2)
    clk = ~clk;

initial begin

    rst = 0;
    start = 0;

    z = 0;
    a_ge_res_bit = 0;

    @(negedge clk);
    rst = 1;

    @(negedge clk);
    rst = 0;

    @(negedge clk);
    start = 1;

    // INIT

    @(negedge clk);

    // while(bit != 0)

    z = 0;

    @(negedge clk);

    // if(A >= res+bit)

    a_ge_res_bit = 1;

    @(negedge clk);

    // A = A - (res+bit)

    @(negedge clk);

    // res = (res >> 1) + bit

    @(negedge clk);

    // bit = bit >> 2

    @(negedge clk);

    // segunda iteración

    z = 0;
    a_ge_res_bit = 0;

    @(negedge clk);

    // A < res+bit

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