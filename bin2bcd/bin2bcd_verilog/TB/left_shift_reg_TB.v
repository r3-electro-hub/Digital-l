`timescale 1ns/1ps
module left_shift_reg_TB;
    reg clk;
    reg load;
    reg shift;
    reg [4:0] wr_bcd;
    reg [15:0] in_bin;
    reg [19:0] in_bcd;
    wire [19:0] out_bcd;
    
    left_shift_reg DUT(
        .clk(clk),
        .load(load),
        .shift(shift),
        .wr_bcd(wr_bcd),
        .in_bin(in_bin),
        .in_bcd(in_bcd),
        .out_bcd(out_bcd)
    );

    //CLOCK
    parameter PERIOD = 20;

    initial
        clk = 0;
    always #(PERIOD/2)
        clk = ~clk;

    //TAREA AUTOMATIZADA
    task run_test;
        input [3:0] value;
        input [4:0] wr;
        input [5:0] pos;

        begin
            in_bin = 0;

            load = 1;
            @(posedge clk);
            load = 0;

            in_bcd = {5{value}};
            wr_bcd = wr;

            @(posedge clk);

            if (DUT.temp[pos +: 4] == value)
                $display("PASS");
            else begin
                $display("FAIL");
                $display("esperado=%h obtenido=%h",
                        value,
                        DUT.temp[pos +: 4]);
            end
        end
    endtask

    //INICIALIZACIÓN
    initial begin
        load    = 0;
        shift   = 0;
        wr_bcd  = 5'b00000;
        in_bin  = 16'h0000;
        in_bcd = 20'h00000;
        @(posedge clk)

        //----------------------TEST 1----------------------------------------
        $display("TEST 1: LOAD");
        
        in_bin = 16'h00A0;
        @(posedge clk)

        load = 1;
        @(posedge clk)
        load = 0;
        @(posedge clk)
        
        if (DUT.temp[15:0] == 16'h00A0 && DUT.temp[35:16] == 16'h00000 )
            $display("PASS");
        else begin
            $display("FAIL");
            $display("temp = %h", DUT.temp);
        end
        
        //----------------------TEST 2----------------------------------------
        $display("TEST 2: LOAD");
        
        shift = 1;
        @(posedge clk)
        shift = 0;
        @(posedge clk)
        
        if (DUT.temp[35:0] == 36'h0000000A0 << 1)
            $display("PASS");
        else begin
            $display("FAIL");
            $display("temp = %h", DUT.temp);
        end

        //----------------------TEST 3----------------------------------------
        $display("TEST 3: write nibbles");

        run_test(4'ha, 5'b00001, 16);
        run_test(4'hb, 5'b00010, 20);
        run_test(4'hc, 5'b00100, 24);
        run_test(4'hd, 5'b01000, 28);
        run_test(4'he, 5'b10000, 32);
        

        //------------------------FINISH--------------------------------
        #(PERIOD*2)
        $finish;
    end

    //ARCHIVOS PARA SIMULACIÓN
    initial begin
        $dumpfile("left_shift_reg_TB.vcd");
        $dumpvars(0, left_shift_reg_TB);
    end
endmodule