module hub75e_led1 (
    input clk,
    input reset,
    
    output hub75_clk,
    output nOE,
    output latch,
    output [2:0] RGB0,
    output [2:0] RGB1,
    output [3:0] ABCD
);

    wire w_rst_r;
    wire w_rst_c;
    wire w_rst_d;
    wire w_inc_r;
    wire w_inc_c;
    wire w_inc_d;
    wire w_px_clk_en;

    wire w_z_col;
    wire w_z_row;
    wire w_z_del;

    wire [5:0] w_col;
    wire [9:0] w_del;

    wire [9:0] w_addr;

    parameter DELAY = 1000;
    
    

    reg clk1;
    reg [4:0] clk_counter = 0;

    
    //assign hub75_clk = clk1 & w_px_clk_en;
    always @(posedge clk) begin
        if (~reset) begin
            clk_counter <= 0;
            clk1        <= 0;
        end else begin
            if (clk_counter == 2) begin
                clk1        <= ~clk1;
                clk_counter <= 0;
            end else begin
                clk_counter <= clk_counter + 1;
            end
        end
    end

    assign hub75_clk = clk1;
    assign w_addr = {ABCD, w_col};
    count #(
        .BITS(4)
    ) count_row (
        .clk(clk1),
        .rst(w_rst_r),
        .inc(w_inc_r),
        .count_out(ABCD),
        .z(w_z_row)
    );

    count #(
        .BITS(6)
    ) count_col (
        .clk(clk1),
        .rst(w_rst_c),
        .inc(w_inc_c),
        .count_out(w_col),
        .z(w_z_col)
    );

    count #(
        .BITS(11) // 14
    ) count_del (
        .clk(clk1),
        .rst(w_rst_d),
        .inc(w_inc_d),
        .count_out(w_del),
    );

    comp #(
        .VALUE(DELAY),
        .BITS(11)
    ) comp0 (
        .A(w_del),
        .z(w_z_del)
    );

    control ctrl (
        .clk(clk1),
        .reset(~reset),
        .init(1'b1),
        .z_row(w_z_row),
        .z_col(w_z_col),
        .z_del(w_z_del),
        .rst_r(w_rst_r),
        .rst_c(w_rst_c),
        .rst_d(w_rst_d),
        .inc_r(w_inc_r),
        .inc_c(w_inc_c),
        .inc_d(w_inc_d),
        .px_clk_en(w_px_clk_en),
        .latch(latch),
        .nOE(nOE)
    );

    memory mem0(
        .clk(clk1),
        .address(w_addr),
        .read(1'b1),
        .data_out({RGB0,RGB1})
    );

endmodule