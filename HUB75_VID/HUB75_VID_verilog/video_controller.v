module video_controller #(
    parameter NUM_FRAMES = 900, // Requerido por el comando -chparam de Yosys
    parameter FPS = 10         // Requerido por el comando -chparam de Yosys
) (
    input wire clk,       // Reloj físico (25.00 MHz)
    input wire reset,     // Botón físico de reset (activo en bajo)

    // Interfaz con ESP32 (SPI)
    input wire spi_sck,
    input wire spi_mosi,
    input wire spi_cs_n,

    // Salidas físicas para la matriz HUB75
    output wire hub75_clk,
    output wire nOE,
    output wire latch,
    output wire [2:0] RGB0,
    output wire [2:0] RGB1,
    output wire [3:0] ABCD
);

    wire rst_high = ~reset;

    wire [9:0]  spi_waddr;
    wire [23:0] spi_wdata;
    wire        spi_we;
    wire        end_of_frame;

    spi_slave u_spi_rx (
        .clk          (clk),
        .reset        (rst_high),
        .spi_sck      (spi_sck),
        .spi_mosi     (spi_mosi),
        .spi_cs_n     (spi_cs_n),
        .write_addr   (spi_waddr),
        .write_data   (spi_wdata),
        .write_en     (spi_we),
        .cs_posedge   (end_of_frame)
    );

    reg buffer_sel;
    always @(posedge clk or posedge rst_high) begin
        if (rst_high) begin
            buffer_sel <= 1'b0;
        end else if (end_of_frame) begin
            buffer_sel <= ~buffer_sel; // Cambia el búfer al finalizar el frame
        end
    end

    wire [9:0]  hub75_raddr;
    wire [23:0] hub75_rdata;

    ping_pong_ram u_ping_pong (
        .clk              (clk),
        .spi_we           (spi_we),
        .buffer_sel       (buffer_sel),
        .data_in          (spi_wdata),
        .spi_addr         (spi_waddr),
        .hub75_addr       (hub75_raddr),
        .hub75_read_data  (hub75_rdata)
    );

    // Instanciamos heredando los parámetros inyectados por el compilador
    hub75e_led_anim #(
        .NUM_FRAMES(NUM_FRAMES),
        .FPS(FPS)
    ) u_hub75_ctrl (
        .clk              (clk),
        .reset            (reset),
        .hub75_read_data  (hub75_rdata),
        .hub75_read_addr  (hub75_raddr),
        .current_frame    (), // Puertos de salida mapeados a vacío (open)
        .frame_tick       (), // ya que la sincronización la maneja el ESP32
        .hub75_clk        (hub75_clk),
        .nOE              (nOE),
        .latch            (latch),
        .RGB0             (RGB0),
        .RGB1             (RGB1),
        .ABCD             (ABCD)
    );

endmodule