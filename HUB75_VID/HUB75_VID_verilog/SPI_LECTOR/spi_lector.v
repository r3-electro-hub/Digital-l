module spi_lector (
    input clk,
    input reset,                     
    input [23:0] offset,            
    input spi_miso,
    input start_read,

    output spi_mosi,
    output spi_cs, 
    output reg spi_clk,            

    output [9:0] spi_addr,
    output ram_we,
    output [23:0] ram_data
);

    wire w_Z_CMD;
    wire w_Z_BIT;
    wire w_Z_PIXEL;

    wire w_rst_b;
    wire w_rst_p;
    wire w_inc_b;                    
    wire w_inc_p;
    wire w_load_cmd;
    wire w_load_addr;
    wire w_load_rx;
    wire w_sh_cmd;
    wire w_sh_addr;
    wire w_sh_rx;

    wire w_mosi_sel;

    wire [4:0] w_bit_counter;
    wire [9:0] w_pixel_counter;

    assign spi_addr = w_pixel_counter;

    wire [7:0] w_cmd;
    wire [23:0] read_address;
    assign read_address = 24'h200000 + offset;
    wire [23:0] w_address;

    reg [1:0] clk_counter;         
    wire rst_high = ~reset;

    //-------------------DIVISOR DE RELOJ (6.25 MHz)----------------------------
    always @(posedge clk) begin
        if (rst_high) begin             
            clk_counter <= 0;
            spi_clk     <= 0;
        end else begin
            if (clk_counter == 2'd1) begin 
                spi_clk     <= ~spi_clk;
                clk_counter <= 0;
            end else begin
                clk_counter <= clk_counter + 1;
            end
        end
    end

//-------------------BIT COUNTER----------------------------
    count #(
        .BITS(5)
    ) bit_counter(
        .clk(spi_clk),
        .rst(w_rst_b),
        .inc(w_inc_b),
        .count_out(w_bit_counter)    
    );

    comp #(
        .BITS(5)
    ) comp_CMD (
        .A(5'd8),                    
        .B(w_bit_counter),
        .z(w_Z_CMD)
    );

    comp #(
        .BITS(5)
    ) comp_BIT (
        .A(5'd24),                 
        .B(w_bit_counter),
        .z(w_Z_BIT)
    );

//-------------------PIXEL COUNTER----------------------------
    count #(
        .BITS(10)
    ) pixel_counter(
        .clk(spi_clk),
        .rst(w_rst_p),
        .inc(w_inc_p),
        .count_out(w_pixel_counter) 
    );

    comp #(
        .BITS(10)
    ) comp_PIXEL (                  
        .A(10'd1023),               
        .B(w_pixel_counter),
        .z(w_Z_PIXEL)
    );

//-------------------CMD_REG----------------------------
    lsr #(
        .BITS(8)
    ) cmd_reg (
        .clk(spi_clk),
        .ld(w_load_cmd),
        .sh(w_sh_cmd),
        .value(8'h03),
        .value_out(w_cmd)
    );

//-------------------ADDR_REG----------------------------
    lsr #(
        .BITS(24)
    ) addr_reg (
        .clk(spi_clk),
        .ld(w_load_addr),
        .sh(w_sh_addr),
        .value(read_address),
        .value_out(w_address)
    );

//-------------------MUX----------------------------
    mux2 mux_mosi(
        .A(w_cmd),                  
        .B(w_address),
        .sel(w_mosi_sel),
        .out_mux(spi_mosi)
    );

//-------------------RX_REG----------------------------
    rx_reg rx0 (
        .clk(spi_clk),
        .ld(w_load_rx),
        .sh(w_sh_rx),
        .spi_miso(spi_miso),
        .out_rx(ram_data)
    );

//-------------------CONTROL----------------------------
    spi_control ctrl_spi(
        .clk(spi_clk),
        .reset(reset_high),
        .start(start_read),
        .Z_CMD(w_Z_CMD),
        .Z_BIT(w_Z_BIT),
        .Z_PIXEL(w_Z_PIXEL),
        .rst_b(w_rst_b),
        .rst_p(w_rst_p),
        .inc_p(w_inc_p),
        .inc_b(w_inc_b),
        .load_cmd(w_load_cmd),
        .load_addr(w_load_addr),
        .load_rx(w_load_rx),
        .sh_cmd(w_sh_cmd),
        .sh_addr(w_sh_addr),
        .sh_rx(w_sh_rx),            
        .mosi_sel(w_mosi_sel),
        .CS(spi_cs),
        .ram_we(ram_we)
    );

endmodule