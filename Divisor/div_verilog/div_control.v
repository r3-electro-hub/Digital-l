module div_control (

    input clk,
    input rst,
    input start,
    input MSB_A,
    input z,

    output reg reset,
    output reg shift,
    output reg dec,
    output reg lsb_DV,
    output reg r_A,
    output reg done

);

parameter INIT       = 3'b000,
          SHIFT_DV   = 3'b001,
          CHECK_MSB  = 3'b010,
          ASSIGN_DV  = 3'b011,
          CHECK_C    = 3'b100,
          DONE_STATE = 3'b101;

reg [2:0] state;
reg [5:0] count;

//====================================================
// FSM SECUENCIAL
//====================================================

always @(posedge clk or posedge rst) begin

    if (rst) begin
        state <= INIT;
        count <= 0;
    end

    else begin

        case (state)

            //========================================
            // ESTADO INICIAL
            //========================================

            INIT: begin

                count <= 0;

                if (start)
                    state <= SHIFT_DV;
                else
                    state <= INIT;

            end

            //========================================
            // DESPLAZAMIENTO
            //========================================

            SHIFT_DV: begin
                state <= CHECK_MSB;
            end

            //========================================
            // VERIFICAR SIGNO
            //========================================

            CHECK_MSB: begin

                if (MSB_A == 1'b0)
                    state <= ASSIGN_DV;
                else
                    state <= CHECK_C;

            end

            //========================================
            // ASIGNAR BIT DEL COCIENTE
            //========================================

            ASSIGN_DV: begin
                state <= CHECK_C;
            end

            //========================================
            // VERIFICAR CONTADOR
            //========================================

            CHECK_C: begin

                if (z)
                    state <= DONE_STATE;
                else
                    state <= SHIFT_DV;

            end

            //========================================
            // FINALIZACIÓN
            //========================================

            DONE_STATE: begin

                count <= count + 1;

                if (count >= 28)
                    state <= INIT;
                else
                    state <= DONE_STATE;

            end

            //========================================
            // DEFAULT
            //========================================

            default: begin
                state <= INIT;
                count <= 0;
            end

        endcase
    end
end

//====================================================
// LÓGICA COMBINACIONAL DE SALIDAS
//====================================================

always @(*) begin

    // Valores por defecto

    reset  = 0;
    shift  = 0;
    dec    = 0;
    lsb_DV = 0;
    r_A    = 0;
    done   = 0;

    case (state)

        INIT: begin
            reset = 1;
        end

        SHIFT_DV: begin
            shift = 1;
            dec   = 1;
        end

        ASSIGN_DV: begin
            lsb_DV = 1;
            r_A    = 1;
        end

        DONE_STATE: begin
            done = 1;
        end

        default: begin
            reset  = 0;
            shift  = 0;
            dec    = 0;
            lsb_DV = 0;
            r_A    = 0;
            done   = 0;
        end

    endcase
end

`ifdef BENCH

reg [8*40:1] state_name;

always @(*) begin

    case(state)

        INIT        : state_name = "INIT";
        SHIFT_DV    : state_name = "SHIFT_DV";
        CHECK_MSB   : state_name = "CHECK_MSB";
        ASSIGN_DV   : state_name = "ASSIGN_DV";
        CHECK_C     : state_name = "CHECK_C";
        DONE_STATE  : state_name = "DONE_STATE";

        default     : state_name = "UNKNOWN";

    endcase
end

`endif

endmodule