`timescale 1ns/1ps

module reg_msb_TB;
    reg clk;
    reg reset;
    reg [3:0] in;
    reg ld_reg;
    reg out_en;
    wire [3:0] wr_bcd;

    reg_msb DUT(
        .clk(clk),
        .reset(reset),
        .in(in),
        .ld_reg(ld_reg),
        .out_en(out_en),
        .wr_bcd(wr_bcd)
    );

    parameter PERIOD = 20;

        initial
            clk = 0;

        always #(PERIOD/2)
            clk = ~clk;

    initial begin
        reset   = 0;
        in      = 4'b0000;
        ld_reg  = 0;
        out_en  = 0;

        $display("----- TEST 1 : LOAD -----");

        in = 4'b1010;

        @(posedge clk)
        @(posedge clk)

        ld_reg = 1;

        @(posedge clk)
        ld_reg = 0;
        @(posedge clk)

            // Verificación
        if(DUT.temp == 4'b1010)
            $display("PASS");
        else
            $display("FAIL");


        $display("----- TEST 2 : RESET -----");

        @(posedge clk)

        reset = 1;

        @(posedge clk)
        reset = 0;
        @(posedge clk)

            // Verificación
        if(DUT.temp == 0)
            $display("PASS");
        else
            $display("FAIL");

        $display("----- TEST 3 : OUT -----");

        in = 4'b1010;
        
        @(posedge clk)
        ld_reg  = 1;
        out_en = 1;

        @(posedge clk)
        ld_reg  = 0;
            // Verificación
        if(wr_bcd == 4'b0101)
            $display("PASS");
        else
            $display("FAIL");

        @(posedge clk)
        @(posedge clk)

        out_en = 0;
        @(posedge clk)


        //FINISH
        #(PERIOD*2);

        $finish;

    end
    initial begin
        $dumpfile("reg_msb_TB.vcd");
        $dumpvars(0, reg_msb_TB);
    end
    
endmodule