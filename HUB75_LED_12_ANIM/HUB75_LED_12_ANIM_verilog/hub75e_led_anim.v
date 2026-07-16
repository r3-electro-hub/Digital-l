module hub75e_led_anim (
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
    wire w_rst_i;
    wire w_rst_f;
    wire w_rst_fps;
    wire w_inc_r;
    wire w_inc_c;
    wire w_inc_d;
    wire w_inc_i;
    wire w_inc_f;
    wire w_inc_fps;
    wire w_load_d;
    wire w_sh_d;

    wire w_z_col;
    wire w_z_row;
    wire w_z_del;
    wire w_z_ind;
    wire w_z_fps;
    wire w_z_frame;
    
    //Numero de frames
    parameter NUM_FRAMES = 4;
    parameter REFRESH_RATE = 90; // Hz
    parameter FPS          = 15;

    localparam FPS_DELAY = REFRESH_RATE / FPS;


    localparam FRAME_BITS = $clog2(NUM_FRAMES);
    localparam FPS_BITS   = $clog2(FPS_DELAY+1);

    wire [5:0] w_col;
    wire [9:0] w_del;
    wire [1:0] w_ind;
    wire [FRAME_BITS-1:0] w_frame;
    wire [FPS_BITS-1:0]   w_fps;

    wire [9:0] w_addr;
    wire [23:0] mem_data;

    parameter DELAY = 20 ;
    wire [9:0] delay;

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
    count #(
        .BITS(3) // 14
    ) count_ind (
        .clk(clk1),
        .rst(w_rst_i),
        .inc(w_inc_i),
        .count_out(w_ind),
        .z(w_z_ind)
    );

    shift_reg #(
        .value(DELAY),
        .BITS(11)
    ) sh_reg (
        .clk(clk1),
        .load(w_load_d),
        .shift(w_sh_d),
        .val_out(delay)
    );

    comp #(
        .BITS(11)
    ) comp_delay (
        .A(w_del),
        .B(delay),
        .z(w_z_del)
    );
    count #(
        .BITS(FPS_BITS)
    ) count_fps (
        .clk(clk1),
        .rst(w_rst_fps),
        .inc(w_inc_fps),
        .count_out(w_fps),
    );
    comp #(
        .BITS(FPS_BITS)
    ) comp_fps (
        .A(w_fps),
        .B(FPS_DELAY),
        .z(w_z_fps)
    );
    count #(
        .BITS(FRAME_BITS)
    ) count_frame (
        .clk(clk1),
        .rst(w_rst_f),
        .inc(w_inc_f),
        .count_out(w_frame),
    );
    comp #(
        .BITS(FRAME_BITS)
    ) comp_frame (
        .A(w_frame),
        .B(NUM_FRAMES),
        .z(w_z_frame)
    );


    control ctrl (
        .clk(clk1),
        .reset(~reset),
        .init(1'b1),
        .z_row(w_z_row),
        .z_col(w_z_col),
        .z_del(w_z_del),
        .z_ind(w_z_ind),
        .z_frame(w_z_frame),
        .z_fps(w_z_fps),
        .rst_r(w_rst_r),
        .rst_c(w_rst_c),
        .rst_d(w_rst_d),
        .rst_i(w_rst_i),
        .rst_f(w_rst_f),
        .rst_fps(w_rst_fps),
        .load_d(w_load_d),
        .inc_r(w_inc_r),
        .inc_c(w_inc_c),
        .inc_d(w_inc_d),
        .inc_i(w_inc_i),
        .inc_f(w_inc_f),
        .inc_fps(w_inc_fps),
        .sh_d(w_sh_d),
        .latch(latch),
        .nOE(nOE)
    );

    mux1 mux0(
        .A(mem_data),
        .sel(w_ind),
        .out_mux({RGB0,RGB1})
    );

    memory #(
        .NUM_FRAMES(NUM_FRAMES)
    ) mem0(
        .clk(clk1),
        .address(w_addr),
        .frame(w_frame),
        .read(1'b1),
        .data_out(mem_data)
    );

endmodule