`timescale 1ns / 1ps

module raiz32_TB;

reg clk;
reg rst;
reg start;

reg [31:0] A;

wire [31:0] Result;
wire done;

raiz32 DUT(
    .clk(clk),
    .rst(rst),
    .start(start),
    .A(A),
    .Result(Result),
    .done(done)
);

parameter PERIOD = 20;

initial
    clk = 0;

always #(PERIOD/2)
    clk = ~clk;

task run_test;

    input [31:0] value;
    input [31:0] expected;

begin

    @(negedge clk);

    A = value;
    start = 1;

    @(negedge clk);

    start = 0;

    wait(done);

    @(negedge clk);

    if(Result == expected)
        $display("PASS | A = %d | Result = %d", value, Result);
    else
        $display("FAIL | A = %d | Result = %d | Expected = %d",
                 value, Result, expected);

    @(negedge clk);

end

endtask

initial begin

    rst = 0;
    start = 0;
    A = 0;

    @(negedge clk);
    rst = 1;

    @(negedge clk);
    rst = 0;

    run_test(0, 0);
    run_test(1, 1);
    run_test(4, 2);
    run_test(9, 3);
    run_test(16, 4);
    run_test(25, 5);
    run_test(36,6);
    //run_test(121, 11);
    run_test(1024, 32);
    //run_test(65535, 255);
   
   #100;

    $finish;

end

initial begin

    $dumpfile("raiz32_TB.vcd");
    $dumpvars(0, raiz32_TB);

end

endmodule