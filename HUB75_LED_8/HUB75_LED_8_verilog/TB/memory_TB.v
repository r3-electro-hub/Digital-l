`timescale 1ns/1ps

module memory_TB;
    reg         clk;
    reg [9:0]  address;
    reg         read;
    wire [5:0]  data_out;

    memory DUT (
        .clk(clk),
        .address(address),
        .read(read),
        .data_out(data_out)
    );

    parameter PERIOD = 20;

    initial
        clk = 0;
    always #(PERIOD/2)
        clk = ~clk;

    task run_test;
        input [9:0] addr;
        input [5:0]  expected_val;
        begin
            address = addr;
            read = 1;
            @(posedge clk);
            
            if (data_out == expected_val)
                $display("PASS: addr=%h data_out=%h", addr, data_out);
            else begin
                $display("FAIL: addr=%h", addr);
                $display("esperado=%h obtenido=%h", expected_val, data_out);
            end
        end
    endtask

    initial begin
        read      = 0;
        address = 10'h000;
        @(posedge clk);

        $display("TEST 1: Lecturas secuenciales habilitadas");
        run_test(10'h000, 6'h24);
        run_test(10'h001, 6'h24);
        run_test(10'h002, 6'h24);
        run_test(10'h00D, 6'h20);
        run_test(10'h033, 6'h1C);

        $display("TEST 2: Verificación de read deshabilitado");
        read = 0;
        address = 10'h000;
        @(posedge clk);

        if (data_out == 6'h1C)
            $display("PASS");
        else begin
            $display("FAIL");
            $display("data_out = %h", data_out);
        end

        #(PERIOD*2)
        $finish;
    end

    initial begin
        $dumpfile("memory_TB.vcd");
        $dumpvars(0, memory_TB);
    end
endmodule