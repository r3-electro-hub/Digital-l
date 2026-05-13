module divisor (
    input clk,
    input rst,
    input start,

    input [15:0] A,
    input [15:0] B,

    output [15:0] Result,
    output done
); // reset = init
    wire reset, shift, dec, lsb_DV, r_A ;

    wire MSB_A;
    wire z;
    
    wire [4:0] c;
    wire [15:0] Result_resta;
    wire [15:0] Reg_A;

    left_shift_register left_shift (
        //señales de control
        .clk(clk),
        .reset(reset),
        .shift(shift),
        .r_A(r_A),
        .lsb_dv(lsb_DV), 
        //inputs
        .DV_in(A),
        .A_in(Result_resta),
        //outputs
        .A(Reg_A),
        .r_out(Result)
    );
    resta resta0(
        //inputs
        .A_in(Reg_A),
        .DR_in(B),
        //outputs
        .MSB_A(MSB_A),
        .A(Result_resta)
    );
    contador count(
        //INPUT
        .clk(clk),
        .reset(reset),
        .dec(dec),
        .c(c)
    );
    check_c check(
    //input
     .c(c),
    //output
     .z(z)
    );

    div_control ctrl(
        .clk(clk),
        .rst(rst),
        .start(start),
        .MSB_A(MSB_A),
        .z(z),

        .reset(reset),
        .shift(shift),
        .dec(dec),
        .lsb_DV(lsb_DV),
        .r_A(r_A),
        .done(done)
    );

endmodule