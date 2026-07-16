`timescale 1ns/1ps

module count_TB;

    reg clk;

    // ROW
    reg rst_r;
    reg inc_r;
    wire [3:0] row;
    wire z_row;

    // COL
    reg rst_c;
    reg inc_c;
    wire [5:0] col;
    wire z_col;

    // DELAY
    reg rst_d;
    reg inc_d;
    wire [11:0] delay;
    wire z_del;

    //---------------- DUTS ----------------

    count #(
        .MAX_VALUE(15),
        .BITS(4)
    ) ROW_COUNTER(
        .clk(clk),
        .rst(rst_r),
        .inc(inc_r),
        .count_out(row),
        .z(z_row)
    );

    count #(
        .MAX_VALUE(63),
        .BITS(6)
    ) COL_COUNTER(
        .clk(clk),
        .rst(rst_c),
        .inc(inc_c),
        .count_out(col),
        .z(z_col)
    );

    count #(
        .MAX_VALUE(1000),
        .BITS(12)
    ) DELAY_COUNTER(
        .clk(clk),
        .rst(rst_d),
        .inc(inc_d),
        .count_out(delay),
        .z(z_del)
    );

    //---------------- CLOCK ----------------

    parameter PERIOD = 20;

    initial
        clk = 0;

    always #(PERIOD/2)
        clk = ~clk;

    integer i;

    //---------------- TESTS ----------------

    initial begin

        // Inicialización
        rst_r = 0;
        rst_c = 0;
        rst_d = 0;

        inc_r = 0;
        inc_c = 0;
        inc_d = 0;

        //---------------- RESET GENERAL ----------------

        $display("TEST 1: RESET GENERAL");

        rst_r = 1;
        rst_c = 1;
        rst_d = 1;

        @(posedge clk);

        rst_r = 0;
        rst_c = 0;
        rst_d = 0;

        @(posedge clk);

        if((row == 0) && (col == 0) && (delay == 0))
            $display("PASS");
        else
            $display("FAIL");

        //---------------- TEST ROW ----------------

        $display("TEST 2: ROW");

        for(i=0;i<15;i=i+1)
        begin
            inc_r = 1;
            @(posedge clk);
        end

        inc_r = 0;

        if((row == 15) && z_row)
            $display("PASS");
        else
            $display("FAIL");

        //---------------- RESET ROW ----------------

        rst_r = 1;
        @(posedge clk);
        rst_r = 0;

        //---------------- TEST COL ----------------

        $display("TEST 3: COL");

        for(i=0;i<63;i=i+1)
        begin
            inc_c = 1;
            @(posedge clk);
        end

        inc_c = 0;

        if((col == 63) && z_col)
            $display("PASS");
        else
            $display("FAIL");

        //---------------- RESET COL ----------------

        rst_c = 1;
        @(posedge clk);
        rst_c = 0;

        //---------------- TEST DELAY ----------------

        $display("TEST 4: DELAY");

        for(i=0;i<1000;i=i+1)
        begin
            inc_d = 1;
            @(posedge clk);
        end

        inc_d = 0;

        if((delay == 1000) && z_del)
            $display("PASS");
        else
            $display("FAIL");

        //---------------- RESET DELAY ----------------

        rst_d = 1;
        @(posedge clk);
        rst_d = 0;

        //---------------- FIN ----------------

        #(PERIOD*5);

        $finish;

    end

    initial begin
        $dumpfile("count_TB.vcd");
        $dumpvars(0,count_TB);
    end

endmodule