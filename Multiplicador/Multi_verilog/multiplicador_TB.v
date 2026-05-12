`timescale 1ns / 1ps
`define BENCH

module multiplicador_TB;

reg clk;
reg reset;
reg start;

reg [15:0] A;
reg [15:0] B;

wire [31:0] p;
wire done;

multiplicador uut(
    .reset(reset),
    .clk(clk),
    .start(start),
    .A(A),
    .B(B),
    .p(p),
    .done(done)
);

parameter PERIOD = 20;

initial
begin
    clk = 0;

    forever #(PERIOD/2)
        clk = ~clk;
end

initial
begin

    reset = 1;
    start = 0;

    A = 0;
    B = 0;

    #40;

    reset = 0;

    //------------------------------------------------------------------
    // TEST 1
    //------------------------------------------------------------------

    A = 16'd7;
    B = 16'd5;

    #20;
    start = 1;

    #20;
    start = 0;

    wait(done == 1);

    #40;

    $display("------------------------------------");
    $display("TEST 1");
    $display("A        = %d", A);
    $display("B        = %d", B);
    $display("Resultado= %d", p);
    $display("Esperado = %d", A*B);
    $display("------------------------------------");

    //------------------------------------------------------------------
    // TEST 2
    //------------------------------------------------------------------

    reset = 1;
    #20;
    reset = 0;

    A = 16'd12;
    B = 16'd9;

    #20;
    start = 1;

    #20;
    start = 0;

    wait(done == 1);

    #40;

    $display("------------------------------------");
    $display("TEST 2");
    $display("A        = %d", A);
    $display("B        = %d", B);
    $display("Resultado= %d", p);
    $display("Esperado = %d", A*B);
    $display("------------------------------------");

    //------------------------------------------------------------------
    // TEST 3
    //------------------------------------------------------------------

    reset = 1;
    #20;
    reset = 0;

    A = 16'd25;
    B = 16'd13;

    #20;
    start = 1;

    #20;
    start = 0;

    wait(done == 1);

    #40;

    $display("------------------------------------");
    $display("TEST 3");
    $display("A        = %d", A);
    $display("B        = %d", B);
    $display("Resultado= %d", p);
    $display("Esperado = %d", A*B);
    $display("------------------------------------");

    //------------------------------------------------------------------

    #100;
    $finish;

end

initial
begin
    $dumpfile("multiplicador_TB.vcd");

    $dumpvars(0, uut);
    $dumpvars(0, multiplicador_tb);

end
endmodule