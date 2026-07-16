`timescale 1ns/1ps

module control_TB;
    reg     clk;
    reg     reset;
    reg     z_row;
    reg     z_col;
    reg     z_del;

    wire    rst_r;
    wire    rst_c;
    wire    rst_d;
    wire    inc_r;
    wire    inc_c;
    wire    inc_d;
    wire    px_clk_en;
    wire    latch;
    wire    nOE;

    control DUT(
        .clk(clk),
        .reset(reset),
        .z_row(z_row),
        .z_col(z_col),
        .z_del(z_del),
        .rst_r(rst_r),
        .rst_c(rst_c),
        .rst_d(rst_d),
        .inc_r(inc_r),
        .inc_c(inc_c),
        .inc_d(inc_d),
        .px_clk_en(px_clk_en),
        .latch(latch),
        .nOE(nOE)
    );

    parameter PERIOD = 20;
    initial
        clk = 0;
    always #(PERIOD/2)
        clk = ~clk;
    
    integer i;

    initial begin
        reset = 0;
        z_row = 0;
        z_col = 0;
        z_del = 0;

        $display("------ INICIANDO TESTBENCH DE CONTROL MATRIX ------");
        
        @(negedge clk);
        reset = 1;
        @(negedge clk);
        reset = 0;

        $display("Esperando ciclos de inicialización en START...");
        for (i = 0; i < 30; i = i + 1) begin
            @(negedge clk);
        end

        @(negedge clk);
        $display("FSM en ciclo de transmisión (INC_COL)...");

        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        
        $display("Simulando Fin de Columnas (z_col = 1)");
        z_col = 1;
        @(negedge clk);
        z_col = 0;

        @(negedge clk);
        $display("FSM en tiempo de espera (DELAY_ROW)...");

        @(negedge clk);
        @(negedge clk);

        $display("Simulando Fin de Delay (z_del = 1)");
        z_del = 1;
        @(negedge clk);
        z_del = 0;

        @(negedge clk);
        $display("FSM evaluando fin de cuadro (READY_FRAME)...");

        z_row = 0;
        @(negedge clk);
        
        if (inc_c && px_clk_en)
            $display("TEST REGRESO A FILA: PASS (Volvió a INC_COL con éxito)");
        else
            $display("TEST REGRESO A FILA: FAIL");

        z_col = 1;
        @(negedge clk);
        z_col = 0;
        @(negedge clk);
        z_del = 1;
        @(negedge clk);
        z_del = 0;
        @(negedge clk);

        $display("Simulando Fin de Pantalla Completa (z_row = 1)");
        z_row = 1;
        @(negedge clk);
        z_row = 0;
        
        @(negedge clk);

        #(PERIOD*2);
        $display("------ SIMULACIÓN TERMINADA ------");
        $finish;
    end

    initial begin
        $dumpfile("control_TB.vcd");
        $dumpvars(0, control_TB);
    end

endmodule