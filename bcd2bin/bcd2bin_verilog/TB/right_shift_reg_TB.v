`timescale 1ns/1ps

module right_shift_reg_TB;

    reg clk;
    reg load;
    reg shift;
    reg [4:0] wr_bcd;

    reg [19:0] in_bcd;
    reg [19:0] in_bin;

    wire [19:0] out_bcd;
    wire [15:0] out_bin;

    right_shift_reg DUT(
        .clk(clk),
        .load(load),
        .shift(shift),
        .wr_bcd(wr_bcd),
        .in_bcd(in_bcd),
        .in_bin(in_bin),
        .out_bcd(out_bcd),
        .out_bcd2(out_bin)
    );

    parameter PERIOD = 20;

    initial
        clk = 0;

    always #(PERIOD/2)
        clk = ~clk;

    task run_test;
        input [3:0] value;
        input [4:0] wr;
        input [5:0] pos;

        begin
            in_bcd = 0;
            load = 1;
            @(posedge clk);
            load = 0;

            in_bin = {5{value}};
            wr_bcd = wr;

            @(posedge clk);

            if (DUT.temp[pos +: 4] == value)
                $display("PASS");
            else begin
                $display("FAIL");
                $display("Esperado=%h Obtenido=%h",
                         value,
                         DUT.temp[pos +: 4]);
            end
        end
    endtask

    initial begin

        load   = 0;
        shift  = 0;
        wr_bcd = 0;
        in_bcd = 0;
        in_bin = 0;

        @(posedge clk);

        //-------------------------------------------------
        // TEST 1 : LOAD
        //-------------------------------------------------

        $display("TEST 1 : LOAD");

        in_bcd = 20'hABCDE;

        load = 1;
        @(posedge clk);
        load = 0;

        @(posedge clk);

        if (DUT.temp[35:16] == 20'hABCDE &&
            DUT.temp[15:0]  == 16'h0000)
            $display("PASS");
        else begin
            $display("FAIL");
            $display("temp=%h", DUT.temp);
        end

        //-------------------------------------------------
        // TEST 2 : SHIFT RIGHT
        //-------------------------------------------------

        $display("TEST 2 : SHIFT RIGHT");

        shift = 1;
        @(posedge clk);
        shift = 0;

        @(posedge clk);

        if (DUT.temp == ({20'hABCDE,16'h0000} >> 1))
            $display("PASS");
        else begin
            $display("FAIL");
            $display("temp=%h", DUT.temp);
        end

        //-------------------------------------------------
        // TEST 3 : WRITE BCD NIBBLES
        //-------------------------------------------------

        $display("TEST 3 : WRITE BCD");

        run_test(4'hA, 5'b10000, 32);
        run_test(4'hB, 5'b01000, 28);
        run_test(4'hC, 5'b00100, 24);
        run_test(4'hD, 5'b00010, 20);
        run_test(4'hE, 5'b00001, 16);

        #(PERIOD*2);

        $finish;
    end

    initial begin
        $dumpfile("right_shift_reg_TB.vcd");
        $dumpvars(0,right_shift_reg_TB);
    end

endmodule