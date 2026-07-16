module spi_control (
    input       clk,
    input       reset,
    input       start,
    input       Z_CMD,
    input       Z_BIT,
    input       Z_PIXEL,
    output reg  rst_b,
    output reg  rst_p,
    output reg  inc_p,
    output reg  inc_b,
    output reg  load_cmd,
    output reg  load_addr,
    output reg  load_rx,
    output reg  sh_cmd,
    output reg  sh_addr,
    output reg  sh_rx,
    output reg  mosi_sel,
    output reg  CS,
    output reg  ram_we
);

    parameter INIT      = 3'b000;
    parameter SEND_CMD  = 3'b001;
    parameter SEND_ADDR = 3'b010;
    parameter READ_DATA = 3'b011;
    parameter WRITE_RAM = 3'b100;
    parameter DONE      = 3'b101;

    reg [2:0] state; 

    always @(posedge clk) begin
        if (reset) begin
            state <= INIT;
        end else begin
            case (state)
                INIT: begin
                    if (start) begin
                        state <= SEND_CMD;
                    end
                    else
                        state <= INIT;
                end
                SEND_CMD: begin
                    if (Z_CMD) begin
                        state <= SEND_ADDR;
                    end
                    else
                        state <= SEND_CMD;
                end
                SEND_ADDR: begin
                    if (Z_BIT) begin
                        state <= READ_DATA;
                    end
                    else
                        state <= SEND_ADDR;
                end
                READ_DATA: begin
                    if (Z_BIT) begin
                        state <= WRITE_RAM;
                    end
                    else
                        state <= READ_DATA;
                end
                WRITE_RAM: begin
                    if (Z_PIXEL) begin
                        state <= DONE;
                    end
                    else
                        state <= READ_DATA;
                end
                DONE: begin
                    state <= INIT;
                end
                default: state <= INIT;
            endcase
        end
    end

    always @(*) begin
        rst_b       =0;
        rst_p       =0;
        inc_p       =0;
        inc_b       =0;
        load_cmd    =0;
        load_addr   =0;
        load_rx     =0;
        sh_cmd      =0;
        sh_addr     =0;
        sh_rx       =0;
        inc_b       =0;
        mosi_sel    =0;
        CS          =1;
        ram_we      =0;

        case (state)
            INIT: begin
                rst_b = 1;
                rst_p = 1;
                load_cmd = 1;
                load_addr = 1;
                load_rx = 1;
                CS = 1;
            end
            SEND_CMD: begin
                rst_b = Z_CMD;
                inc_b = 1;
                sh_cmd = 1;
                CS = 0;
            end
            SEND_ADDR: begin
                rst_b = Z_BIT;
                inc_b = 1;
                sh_addr = 1;
                mosi_sel = 1;
                CS = 0;
            end
            READ_DATA: begin
                rst_b = Z_BIT;
                inc_b = 1;
                sh_rx = 1;
                CS = 0;
            end
            WRITE_RAM: begin
                rst_b = 1;
                inc_p = 1;
                ram_we = 1;
                CS = 0;
            end
            DONE: begin
                rst_b = 1;
                rst_p = 1;
            end
            default: begin
                rst_b       =0;
                rst_p       =0;
                inc_p       =0;
                inc_b       =0;
                load_cmd    =0;
                load_addr   =0;
                load_rx     =0;
                sh_cmd      =0;
                sh_addr     =0;
                sh_rx       =0;
                inc_b       =0;
                mosi_sel    =0;
                CS          =1;
                ram_we      =0;
            end
        endcase
    end
endmodule