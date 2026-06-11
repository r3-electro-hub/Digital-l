`timescale 1ns/1ps
module control_TB;
    reg     clk;
    reg     start;
    reg     reset;
    reg     z;
    wire    load;
    wire    shift;
    wire    sel;
    wire    out_en;
    wire    ld_reg;
    wire    done;

    control DUT(
        .clk(clk),
        .start(start),
        .reset(reset),
        .z(z),
        .load(load),
        .shift(shift),
        .sel(sel),
        .out_en(out_en),
        .ld_reg(ld_reg),
        .done(done)
    );

    //_________________________CLK______________________________-
    parameter PERIOD = 20;
    initial
        clk = 0;
    always #(PERIOD/2)
        clk = ~clk;
    
    initial begin
        start = 0;
        reset = 0;
        z = 0;

        $display("TEST 1: END");
        @(negedge clk)
        reset = 1;
        @(negedge clk)
        reset = 0;

        @(negedge clk)
        start = 1;
        @(negedge clk)
        start = 0;

        //shift
        @(negedge clk)
        
        //check
        @(negedge clk)
        
        //load
        @(negedge clk)

        //sum
        @(negedge clk)

        //shift
        @(negedge clk)

        //check
        @(negedge clk)
        
        //load
        @(negedge clk)

        //sum
        z=1;
        @(negedge clk)

         //shift
        @(negedge clk)
        @(negedge clk)
        
        if(done)
            $display("PASS");
        else
            $display("FAIL");

        #(PERIOD*2)
        $finish;

    end
initial begin
    $dumpfile("control_TB.vcd");
    $dumpvars(0,control_TB);
end

endmodule