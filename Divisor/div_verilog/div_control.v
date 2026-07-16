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
          WAIT_SHIFT = 3'b010,
          CHECK_MSB  = 3'b011,
          ASSIGN_DV  = 3'b100,
          CHECK_C    = 3'b101,
          DONE_STATE = 3'b110;

reg [2:0] state;

reg [5:0] count;

always @(posedge clk) begin

    if (rst) begin

        state <= INIT;
        count <= 0;

    end

    else begin

        case (state)

            //================================================
            // ESTADO INICIAL
            //================================================

            INIT: begin

                reset  <= 1;
                shift  <= 0;
                dec    <= 0;
                lsb_DV <= 0;
                r_A    <= 0;
                done   <= 0;

                count <= 0;

                if (start)
                    state <= SHIFT_DV;
                else
                    state <= INIT;

            end

            //================================================
            // DESPLAZAMIENTO Y DECREMENTO
            //================================================

            SHIFT_DV: begin

                reset  <= 0;
                shift  <= 1;
                dec    <= 1;
                lsb_DV <= 0;
                r_A    <= 0;
                done   <= 0;

                state <= CHECK_MSB;
                if (z) begin
                    state<=DONE_STATE;
                end
            end



            //================================================
            // VERIFICAR SIGNO DE LA RESTA
            //================================================

            CHECK_MSB: begin

                reset  <= 0;
                shift  <= 0;
                dec    <= 0;
                lsb_DV <= 0;
                r_A    <= 0;
                done   <= 0;

                if (MSB_A == 0)
                    state <= ASSIGN_DV;
                else
                    state <= CHECK_C;

            end

            //================================================
            // ESCRIBIR BIT 1 EN EL COCIENTE
            // Y CARGAR NUEVO A
            //================================================

            ASSIGN_DV: begin

                reset  <= 0;
                shift  <= 0;
                dec    <= 0;
                lsb_DV <= 1;
                r_A    <= 1;
                done   <= 0;

                state <= CHECK_C;

            end

            //================================================
            // VERIFICAR CONTADOR
            //================================================

            CHECK_C: begin

                reset  <= 0;
                shift  <= 0;
                dec    <= 0;
                lsb_DV <= 0;
                r_A    <= 0;
                done   <= 0;

                if (z)
                    state <= DONE_STATE;
                else
                    state <= SHIFT_DV;

            end

            //================================================
            // FINALIZACIÓN
            //================================================

            DONE_STATE: begin

                reset  <= 0;
                shift  <= 0;
                dec    <= 0;
                lsb_DV <= 0;
                r_A    <= 0;
                done   <= 1;

                count <= count + 1;

                if (count > 28)
                    state <= INIT;
                else
                    state <= DONE_STATE;

            end

            //================================================
            // DEFAULT
            //================================================

            default: begin

                reset  <= 1;
                shift  <= 0;
                dec    <= 0;
                lsb_DV <= 0;
                r_A    <= 0;
                done   <= 0;

                state <= INIT;

            end

        endcase
    end
end

`ifdef BENCH

reg [8*40:1] state_name;

always @(*)
begin
    case(state)

        INIT  : state_name = "INIT";
        CHECK_MSB : state_name = "CHECK_MSB";
        CHECK_C : state_name = "CHECK_C";
        ASSIGN_DV   : state_name = "ASSING_DV";
        SHIFT_DV : state_name = "SHIFT_DV";
        DONE_STATE   : state_name = "DONE_STATE";

        default:
            state_name = "UNKNOWN";

    endcase
end

`endif
endmodule