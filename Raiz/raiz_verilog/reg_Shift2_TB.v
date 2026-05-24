`timescale 1ns / 1ps
//timescale unidad de tiempo / precisión

module reg_Shift2_TB;

    //====================================================
    // SEÑALES
    //====================================================

    // Entradas del DUT -> reg
    reg clk;

    reg [31:0] alu_out;

    reg shift;
    reg load;
    reg wr;

    // Salidas del DUT -> wire
    wire [31:0] bit1;

    //====================================================
    // DUT
    //====================================================

    reg_Shift2 DUT(
        .clk(clk),
        .alu_out(alu_out),
        .shift(shift),
        .load(load),
        .wr(wr),
        .bit1(bit1)
    );

    //====================================================
    // CLOCK
    //====================================================

    parameter PERIOD = 20;

    initial
        clk = 0;

    always #(PERIOD/2)
        clk = ~clk;

    //====================================================
    // TESTS
    //====================================================

    initial begin

        // Inicialización
        alu_out = 0;

        shift = 0;
        load  = 0;
        wr    = 0;

        //------------------------------------------------
        // TEST 1 : LOAD
        //------------------------------------------------

        $display("----- TEST 1 : LOAD -----");

        @(posedge clk);

        load = 1;

        @(posedge clk);

        load = 0;

        @(posedge clk);

        if(bit1 == (1<<30))
            $display("PASS");
        else
            $display("FAIL");

        //------------------------------------------------
        // TEST 2 : WRITE
        //------------------------------------------------

        $display("----- TEST 2 : WRITE -----");

        alu_out = 32'd64;

        wr = 1;

        @(posedge clk);

        wr = 0;

        @(posedge clk);

        if(bit1 == 32'd64)
            $display("PASS");
        else
            $display("FAIL");

        //------------------------------------------------
        // TEST 3 : SHIFT
        //------------------------------------------------

        $display("----- TEST 3 : SHIFT -----");

        shift = 1;

        @(posedge clk);

        shift = 0;

        @(posedge clk);

        if(bit1 == 32'd16)
            $display("PASS");
        else
            $display("FAIL");

        //------------------------------------------------
        // FIN SIMULACION
        //------------------------------------------------

        #(PERIOD*2);

        $finish;

    end

    //====================================================
    // WAVEFORMS
    //====================================================

    initial begin
        $dumpfile("reg_Shift2_TB.vcd");
        $dumpvars(0, reg_Shift2_TB);
    end

endmodule