`timescale 1ns/1ps

module count_TB;
    reg clk;
    reg reset;
    reg dec;
    wire z;

    count DUT(
        .clk(clk),
        .reset(reset),
        .dec(dec),
        .z(z)
    );

    //-------CLOCK-------------
    parameter PERIOD = 20;

    initial 
        clk = 0;
    always #(PERIOD/2)
        clk  = ~clk;

    //Inicialización
    initial begin
        reset   = 0;
        dec     = 0;

        @(posedge clk)


        $display("TEST 1: RESET");

        reset = 1; 
        @(posedge clk)
        reset = 0;
        @(posedge clk)

        if (DUT.c == 5'd16)
            $display("PASS");
        else
            $display("FAIL");


        $display("TEST 2: DEC");

        dec = 1; 
        @(posedge clk)
        dec = 0;
        @(posedge clk)

        if (DUT.c == 5'd15)
            $display("PASS");
        else
            $display("FAIL");


        $display("TEST 3: Z");

        reset = 1; 
        @(posedge clk)
        reset = 0;
        @(posedge clk)

        while (!z) begin
            @(posedge clk)
            dec = 1;

            @(posedge clk)
            dec = 0;
        end
        if (z == 1)
            $display("PASS");
        else
            $display("FAIL");

        #(PERIOD*2);
        $finish;
    
    end

    initial begin
        $dumpfile("count_TB.vcd");
        $dumpvars(0, count_TB);
    end
endmodule