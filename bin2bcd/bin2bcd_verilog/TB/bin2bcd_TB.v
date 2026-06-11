`timescale 1ns/1ps

module bin2bcd_TB; 

    reg clk;
    reg reset;
    reg start;
    reg [15:0] A_in;
    wire [19:0] Result;
    wire done;
    
    bin2bcd DUT(
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
        input [15:0] value;
        input [19:0] expected;

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
                $display("PASS | A = %d | Result = %h | Expected = %h", value, Result, expected);
            else
                $display("FAIL | A = %d | Result = %h | Expected = %h", value, Result, expected);
            @(negedge clk);
        end

    endtask


    initial begin
        start = 0;
        reset = 0;
        A_in = 16'h0000;

        @(negedge clk);
        reset = 1;
        
        @(negedge clk);
        reset = 0;
        
        run_test(16'd0,     20'h00000);
        run_test(16'd1,     20'h00001);
        run_test(16'd9,     20'h00009);
        run_test(16'd10,    20'h00010);
        run_test(16'd99,    20'h00099);
        run_test(16'd100,   20'h00100);
        run_test(16'd255,   20'h00255);
        run_test(16'd256,   20'h00256);
        run_test(16'd999,   20'h00999);
        run_test(16'd1000,  20'h01000);
        run_test(16'd9999,  20'h09999);
        run_test(16'd12345, 20'h12345);
        run_test(16'd65535, 20'h65535);

        #(PERIOD*2);
        $finish;
    end

initial begin
    $dumpfile("bin2bcd_TB.vcd");
    $dumpvars(0,bin2bcd_TB);
end
endmodule