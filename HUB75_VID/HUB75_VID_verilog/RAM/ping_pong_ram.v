module ping_pong_ram (
    input clk,
    input spi_we,
    input buffer_sel,

    input [23:0] data_in,
    input [9:0] spi_addr,
    input [9:0] hub75_addr,

    output [23:0] hub75_read_data
);
    wire [23:0] read_data_A;
    wire [23:0] read_data_B;

    bram bramA(
        .clk(clk),
        .wr(spi_we && (buffer_sel == 1'b0)),
        .hub75_addr(hub75_addr),
        .data_in(data_in),
        .spi_addr(spi_addr),
        .data_out(read_data_A)
    );
    bram bramB(
        .clk(clk),
        .wr(spi_we && (buffer_sel == 1'b1)),
        .hub75_addr(hub75_addr),
        .data_in(data_in),
        .spi_addr(spi_addr),
        .data_out(read_data_B)
    );
    assign hub75_read_data = (buffer_sel == 1'b0)? read_data_B : read_data_A;
endmodule