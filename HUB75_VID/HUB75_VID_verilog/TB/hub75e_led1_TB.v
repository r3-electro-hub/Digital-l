`timescale 1ns/1ps

module hub75e_led1_TB;
    reg     clk;
    reg     reset;


    wire    latch;
    wire    nOE;
    wire    [3:0] ABCD;
    wire    [2:0] RGB0;
    wire    [2:0] RGB1;

    hub75e_led1 DUT(
        .clk(clk),
        .reset(reset),
        .nOE(nOE),
        .latch(latch),
        .RGB0(RGB0),
        .RGB1(RGB1),
        .ABCD(ABCD)
    );

    parameter PERIOD = 20;
    initial begin
        clk = 0; reset = 0;
    end

    initial clk<= 0;
    always #(PERIOD/2)
        clk = ~clk;
    


    initial begin 
     // Reset 
        @(posedge clk);
        reset = 1;
        @ (posedge clk);
        reset = 0;
        #(PERIOD*4)
        @ (posedge clk);
    end

    integer idx;
    initial begin: TEST_CASE
        $dumpfile("hub75e_led1_TB.vcd");
        $dumpvars(-1, hub75e_led1_TB);
        for(idx = 0; idx < 100; idx = idx +1)  $dumpvars(0, hub75e_led1_TB.DUT.mem0.MEM[idx]);
            #(PERIOD*100000) $finish;
   end
endmodule