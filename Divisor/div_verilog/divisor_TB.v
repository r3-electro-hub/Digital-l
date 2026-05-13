`timescale 1ns/1ps

module divisor_TB;

    reg clk;
    reg rst;
    reg start;

    reg [15:0] A;
    reg [15:0] B;

    wire [15:0] Result;
    wire done;

    //========================================================
    // INSTANCIA DEL DUT
    //========================================================

    divisor uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .A(A),
        .B(B),
        .Result(Result),
        .done(done)
    );

    //========================================================
    // GENERADOR DE CLOCK
    //========================================================

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //========================================================
    // ESTÍMULOS
    //========================================================

    initial begin

        // Inicialización
        rst   = 1;
        start = 0;
        A     = 0;
        B     = 0;

        #20;

        rst = 0;

        //====================================================
        // CASO 1
        // 25 / 5 = 5
        //====================================================

        @(negedge clk);
        A = 16'd25;
        B = 16'd5;

        @(negedge clk);
        start = 1;

        @(negedge clk);
        start = 0;

        wait(done);

        #20;

        $display("----------------------------------");
        $display("CASO 1");
        $display("A = %d", A);
        $display("B = %d", B);
        $display("Resultado = %d", Result);
        $display("----------------------------------");

        //====================================================
        // CASO 2
        // 100 / 4 = 25
        //====================================================

        rst = 1;
        #20;
        rst = 0;

        @(negedge clk);
        A = 16'd100;
        B = 16'd4;

        @(negedge clk);
        start = 1;

        @(negedge clk);
        start = 0;

        wait(done);

        #20;

        $display("----------------------------------");
        $display("CASO 2");
        $display("A = %d", A);
        $display("B = %d", B);
        $display("Resultado = %d", Result);
        $display("----------------------------------");

        //====================================================
        // CASO 3
        // 17 / 3 = 5
        //====================================================

        rst = 1;
        #20;
        rst = 0;

        @(negedge clk);
        A = 16'd17;
        B = 16'd3;

        @(negedge clk);
        start = 1;

        @(negedge clk);
        start = 0;

        wait(done);

        #20;

        $display("----------------------------------");
        $display("CASO 3");
        $display("A = %d", A);
        $display("B = %d", B);
        $display("Resultado = %d", Result);
        $display("----------------------------------");

        //====================================================
        // FINALIZAR SIMULACIÓN
        //====================================================

        #100;

        $finish;

    end

    initial begin

    $dumpfile("divisor_TB.vcd");
    $dumpvars(0, divisor_TB);

    end
endmodule