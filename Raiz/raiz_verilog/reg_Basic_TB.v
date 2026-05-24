//timescale unidad de tiempo / precisión
`timescale 1ns / 1ps

module reg_Basic_TB;

    //====================================================
    // SEÑALES
    //====================================================

    // Entradas del DUT -> reg
    reg clk;

    reg [31:0] in;
    reg [31:0] alu_out;

    reg load;
    reg wr;

    // Salidas del DUT -> wire
    wire [31:0] out;

    //====================================================
    // DUT
    //====================================================

    reg_Basic DUT(
        .clk(clk),
        .in(in),
        .alu_out(alu_out),
        .load(load),
        .wr(wr),
        .out(out)
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

        // Inicialización de señales
        in      = 0;
        alu_out = 0;

        load    = 0;
        wr      = 0;

        //------------------------------------------------
        // TEST 1 : LOAD
        //------------------------------------------------

        $display("----- TEST 1 : LOAD -----");

        in = 32'd15;

        @(posedge clk);
        @(posedge clk);
        // Activar señal ANTES del flanco
        load = 1;

        // Esperar captura del registro
        @(posedge clk);

        // Desactivar load
        load = 0;

        // Esperar estabilización
        @(posedge clk);

        // Verificación
        if(out == 32'd15)
            $display("PASS");
        else
            $display("FAIL");

        //------------------------------------------------
        // TEST 2 : WRITE
        //------------------------------------------------

        $display("----- TEST 2 : WRITE -----");

        alu_out = 32'd100;

        wr = 1;

        @(posedge clk);

        wr = 0;

        @(posedge clk);

        if(out == 32'd100)
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
        $dumpfile("reg_Basic_TB.vcd");
        $dumpvars(0, reg_Basic_TB);
    end

endmodule