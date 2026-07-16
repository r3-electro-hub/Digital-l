module control (
    input       clk,
    input       reset,
    input       init,
    input       z_row,
    input       z_col,
    input       z_del,
    output reg  rst_r,
    output reg  rst_c,
    output reg  rst_d,
    output reg  inc_r,
    output reg  inc_c,
    output reg  inc_d,
    output reg  px_clk_en,
    output reg  latch,
    output reg  nOE
);

    parameter START         = 3'b000;
    parameter GET_PIXEL     = 3'b001;
    parameter INC_COL       = 3'b010;
    parameter SEND_ROW      = 3'b011;
    parameter DELAY_ROW     = 3'b100;
    parameter INC_ROW       = 3'b101;
    parameter READY_FRAME   = 3'b110;

    reg [2:0] state = START;

    always @(posedge clk) begin
        if (reset) begin
            state <= START;
        end else begin
            case (state)
                START: begin
                    if (init)
                        state <= GET_PIXEL;
                    else
                        state <= START;
                end
                GET_PIXEL:
                    state <= INC_COL;
                INC_COL: begin
                    if (z_col) begin
                        state <= SEND_ROW;
                    end
                    else
                        state <= INC_COL;
                end
                SEND_ROW:
                    state <= DELAY_ROW;
                DELAY_ROW: begin
                    if (z_del) begin
                        state <= INC_ROW;
                    end
                    else
                        state <= DELAY_ROW;
                end
                INC_ROW:
                    state <= READY_FRAME;
                READY_FRAME:
                    if (z_row) begin
                        state <= START;
                    end
                    else
                        state <= GET_PIXEL;
                default: state <= START;
            endcase
        end
    end

    always @(*) begin
        rst_r = 0;
        rst_c = 0;
        rst_d = 0;
        inc_r = 0;
        inc_c = 0;
        inc_d = 0;
        px_clk_en = 0;
        latch = 0;
        nOE = 1;

        
        case (state)
            START: begin
                nOE = 1;
                rst_r = 1;
                rst_c = 1;
                rst_d = 1;
            end
            GET_PIXEL: begin
                nOE = 1;
            end
            INC_COL: begin
                inc_c = 1;
                px_clk_en = 1;
                nOE = 1;
            end
            SEND_ROW: begin
                latch = 1;
            end
            DELAY_ROW: begin
                inc_d = 1;
                nOE = 0;
            end
            INC_ROW: begin
                inc_r = 1;
                rst_c = 1;
                rst_d = 1;

            end
            READY_FRAME: begin
                nOE = 1;
                
            end
            default: begin
                rst_r = 0;
                rst_c = 0;
                rst_d = 0;
                inc_r = 0;
                inc_c = 0;
                inc_d = 0;
                px_clk_en = 0;
                latch = 0;
                // nOE = 1;

            end 
        endcase
    end

    `ifdef BENCH
    reg [8*40:1] state_name;
    always @(*) begin
        case(state)
            START       : state_name = "START";
            GET_PIXEL   : state_name = "GET_PIXEL";
            INC_COL     : state_name = "INC_COL";
            SEND_ROW    : state_name = "SEND_ROW";
            DELAY_ROW   : state_name = "DELAY_ROW";
            INC_ROW     : state_name = "INC_ROW";
            READY_FRAME : state_name = "READY_FRAME";
            default     : state_name = "START";
        endcase
    end
    `endif
    
endmodule