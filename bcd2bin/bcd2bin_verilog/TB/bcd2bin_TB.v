`timescale 1ns/1ps

module bcd2bin_TB; 

    reg clk;
    reg reset;
    reg start;
    reg [19:0] A_in;
    wire [15:0] Result;
    wire done;
    
    bcd2bin DUT(
        .clk(clk),
        .reset(reset),
        .start(start),
        .A_in(A_in),
        .Result(Result),
        .done(done)
    );

//     always @(posedge clk) begin
//     $display("z=%b done=%b", DUT.w_z, DUT.w_done);
// end
    //CLK
    parameter PERIOD = 20;
    initial
        clk = 0;
    always #(PERIOD/2)
        clk = ~clk;

    task run_test;
        input [19:0] value;
        input [15:0] expected;

        begin
            wait(!done);

            @(negedge clk);
            A_in = value;
            start = 1;

            @(negedge clk);
            start = 0;

            @(posedge done);

            @(negedge clk);

            if(Result==expected)
                $display("PASS | A = %h | Result = %d | Expected = %d", value, Result, expected);
            else
                $display("FAIL | A = %h | Result = %d | Expected = %d", value, Result, expected);
            @(negedge clk);
        end

    endtask


    initial begin
        start = 0;
        reset = 0;
        A_in = 20'h0000;

        @(negedge clk);
        reset = 1;
        
        @(negedge clk);
        reset = 0;
        
        run_test(20'h00000, 16'd0    );
        run_test(20'h00001, 16'd1    );
        run_test(20'h00009, 16'd9    );
        run_test(20'h00010, 16'd10   );
        run_test(20'h00099, 16'd99   );
        run_test(20'h00100, 16'd100  );
        run_test(20'h00255, 16'd255  );
        run_test(20'h00256, 16'd256  );
        run_test(20'h00999, 16'd999  );
        run_test(20'h01000, 16'd1000 );
        run_test(20'h09999, 16'd9999 );
        run_test(20'h12345, 16'd12345);
        run_test(20'h65535, 16'd65535);

        #(PERIOD*2);
        $finish;
    end

initial begin
    $dumpfile("bcd2bin_TB.vcd");
    $dumpvars(0,bcd2bin_TB);
end
endmodule