`timescale 1ns/1ps

module left_shift_register_TB;

reg clk;
reg reset;
reg shift;
reg r_A;
reg lsb_dv;

reg [15:0] DV_in;
reg [15:0] A_in;

wire [15:0] A;
wire [15:0] r_out;


// Instancia del DUT
left_shift_register uut (
    .clk(clk),
    .reset(reset),
    .shift(shift),
    .r_A(r_A),
    .lsb_dv(lsb_dv),
    .DV_in(DV_in),
    .A_in(A_in),
    .A(A),
    .r_out(r_out)
);


// Generación de reloj
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end


initial begin

   
    reset  = 0;
    shift  = 0;
    r_A    = 0;
    lsb_dv = 0;

    DV_in  = 16'b0000_0000_0000_1010;
    A_in   = 16'b0000_0000_0000_0011;

    
    // =========================
    // RESET
    // =========================
    #2;
    reset = 1;

    #10;
    reset = 0;


    // =========================
    // SHIFT 1
    // =========================
    #10;
    shift = 1;

    #10;
    shift = 0;


    // =========================
    // SHIFT 2
    // =========================
    #10;
    shift = 1;

    #10;
    shift = 0;


    // =========================
    // CARGA DE A
    // =========================
    #10;
    r_A = 1;

    #10;
    r_A = 0;


    // =========================
    // SHIFT DESPUÉS DE LOAD
    // =========================
    #10;
    shift = 1;

    #10;
    shift = 0;


    // FIN
    #20;
    $finish;

end

initial begin
    $dumpfile("left_shift_register_TB.vcd");
    $dumpvars(0, left_shift_register_TB);
end
endmodule