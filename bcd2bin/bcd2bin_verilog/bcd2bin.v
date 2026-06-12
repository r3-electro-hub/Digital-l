module bcd2bin (
    input           clk,
    input           reset,
    input           start,
    input [19:0]    A_in,
    output [15:0]   Result,
    output          done
);
    //Señales de control
    wire w_z;
    wire w_load;
    wire w_shift;
    wire w_sel;
    wire w_out_en;
    wire w_ld_reg;

    wire [4:0] w_MSB; //entrada de reg_msb
    wire [4:0] w_wr_bcd; //Salida de reg_msb
    
    wire [19:0] w_in_bin; //Salida de suma
    wire [19:0] out_bcd;

    wire [3:0] w_decmil;
    wire [3:0] w_mil;
    wire [3:0] w_cent;
    wire [3:0] w_dec;
    wire [3:0] w_unit;

    wire [3:0] w_mux_in1;
    wire [3:0] w_mux_in2;

    wire [19:0]  w_mux_out ; //Salida del multiplexor concuerda con salida de la suma (se deben manejar los mismos bits)

    assign w_mux_in1 = 4'b1101; //-3
    assign w_mux_in2 = 4'b1011; //-5

    assign w_MSB={w_in_bin[19],w_in_bin[15],w_in_bin[11],w_in_bin[7],w_in_bin[3]}; //Bits mas significativos de cada nibble

    right_shift_reg rsr1(
        .clk(clk),
        .load(w_load),
        .shift(w_shift),
        .wr_bcd(w_wr_bcd),
        .in_bcd(A_in),
        .in_bin(w_in_bin),
        .out_bcd({w_decmil,w_mil,w_cent,w_dec,w_unit}),
        .out_bcd2(Result)
       
    
    );

    //mux de unit
    mux2 mux0(
        .in1(w_mux_in1),
        .in2(w_mux_in2),
        .sel(w_sel),
        .mux_out(w_mux_out[3:0])
    );
    mux2 mux1(
        .in1(w_mux_in1),
        .in2(w_mux_in2),
        .sel(w_sel),
        .mux_out(w_mux_out[7:4])
    );
    mux2 mux2(
        .in1(w_mux_in1),
        .in2(w_mux_in2),
        .sel(w_sel),
        .mux_out(w_mux_out[11:8])
    );
    mux2 mux3(
        .in1(w_mux_in1),
        .in2(w_mux_in2),
        .sel(w_sel),
        .mux_out(w_mux_out[15:12])
    );
    mux2 mux4(
        .in1(w_mux_in1),
        .in2(w_mux_in2),
        .sel(w_sel),
        .mux_out(w_mux_out[19:16])
    );

    sum sum0(
        .A(w_mux_out[3:0]),
        .B(w_unit),
        .sum_out(w_in_bin[3:0])
    );
    sum sum1(
        .A(w_mux_out[7:4]),
        .B(w_dec),
        .sum_out(w_in_bin[7:4])
    );
    sum sum2(
        .A(w_mux_out[11:8]),
        .B(w_cent),
        .sum_out(w_in_bin[11:8])
    );
    sum sum3(
        .A(w_mux_out[15:12]),
        .B(w_mil),
        .sum_out(w_in_bin[15:12])
    );
    sum sum4(
        .A(w_mux_out[19:16]),
        .B(w_decmil),
        .sum_out(w_in_bin[19:16])
    );

    count c0(
        .clk(clk),
        .reset(w_load),
        .dec(w_shift),
        .z(w_z)
    );

    reg_msb reg0(
        .clk(clk),
        .reset(load),
        .ld_reg(w_ld_reg),
        .out_en(w_out_en),
        .in(w_MSB),
        .wr_bcd(w_wr_bcd)
    );

    control ctrl(
        .clk(clk),
        .start(start),
        .reset(reset),
        .z(w_z),
        .load(w_load),
        .shift(w_shift),
        .sel(w_sel),
        .out_en(w_out_en),
        .ld_reg(w_ld_reg),
        .done(done)
    );
endmodule