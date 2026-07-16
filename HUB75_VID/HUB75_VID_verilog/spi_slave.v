module spi_slave (
    input wire clk,         // Reloj del sistema (ej: 25 MHz)
    input wire reset,       // Reset activo en alto (rst_high)
    
    // Pines físicos provenientes del ESP32
    input wire spi_sck,
    input wire spi_mosi,
    input wire spi_cs_n,

    // Conexión directa a la Ping-Pong RAM
    output reg [9:0]  write_addr,
    output reg [23:0] write_data,
    output reg        write_en,
    output reg        cs_posedge // Pulso que indica fin de transmisión de un frame
);

    reg [2:0] sck_r;
    reg [2:0] cs_n_r;
    reg [2:0] mosi_r;

    always @(posedge clk) begin
        sck_r  <= {sck_r[1:0], spi_sck};
        cs_n_r <= {cs_n_r[1:0], spi_cs_n};
        mosi_r <= {mosi_r[1:0], spi_mosi};
    end

    wire sck_posedge = (sck_r[2:1] == 2'b01);
    wire cs_active   = !cs_n_r[1];
    
    always @(posedge clk) begin
        cs_posedge <= (cs_n_r[2:1] == 2'b01);
    end

    reg [4:0]  bit_cnt;
    reg [23:0] shift_reg;

    always @(posedge clk or posedge reset) begin
    if (reset) begin
        bit_cnt <= 0;
        write_addr <= 0;
        write_en <= 0;
        shift_reg <= 0;
    end else if (!cs_active) begin
        bit_cnt <= 0;
        write_addr <= 0;
        write_en <= 0;
    end else begin
        // 1. Apaga el pulso y avanza la dirección DESPUÉS de haber escrito
        if (write_en) begin
            write_en <= 1'b0;
            write_addr <= write_addr + 1'b1; 
        end
        
        // 2. Lógica de recepción SPI
        if (sck_posedge) begin
            shift_reg <= {shift_reg[22:0], mosi_r[2]};
            if (bit_cnt == 23) begin
                bit_cnt <= 0;
                write_data <= {shift_reg[22:0], mosi_r[2]};
                write_en <= 1'b1; // Dispara la escritura para el próximo ciclo
            end else begin
                bit_cnt <= bit_cnt + 1'b1;
            end
        end
    end
end 
endmodule