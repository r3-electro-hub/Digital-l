module control_raiz (

    input clk,
    input start,
    input rst,

    input z,
    input bit_gt_a,
    input a_ge_temp,

    output reg load,
    output reg wr_a,
    output reg shift_res,
    output reg wr_res,
    output reg shift_bit,
    output reg wr_bit,
    output reg wr_temp,
    output reg [1:0] sel_A,
    output reg [1:0] sel_B,
    output reg sel_op,

    output reg done

);

parameter INIT_0         = 4'b0000;
parameter INIT           = 4'b0001;
parameter CHECK_BIT      = 4'b0010;
parameter SHIFT_BIT      = 4'b0011;
parameter ASSIGN_TEMP    = 4'b0100;
parameter CHECK_A        = 4'b0101;
parameter ASSIGN_A       = 4'b0110;
parameter ASSIGN_RES     = 4'b0111;
parameter SHIFT_RES_ONLY = 4'b1000;
parameter END_STATE      = 4'b1001;
parameter SHIFT_RES_ADD  = 4'b1010;

reg [3:0] state;
always @(posedge clk) begin

    if(rst) begin
        state <= INIT_0;
    end

    else begin

        case(state)

            INIT_0: begin
                if(start)
                    state <= INIT;
                else
                    state <= INIT_0;

            end

            INIT: begin
                state <= CHECK_BIT;

            end

            CHECK_BIT: begin

                if(bit_gt_a)
                    state <= SHIFT_BIT;

                else if(!z)
                    state <= ASSIGN_TEMP;

                else
                    state <= END_STATE;

            end

            SHIFT_BIT: begin
                // Evaluamos la condición de salida justo DESPUÉS de desplazar el bit de control
                if (z)
                    state <= END_STATE;
                else
                    state <= CHECK_BIT;
            end

            ASSIGN_TEMP: begin
                state <= CHECK_A;

            end

            CHECK_A: begin

                if(a_ge_temp)
                    state <= ASSIGN_A;

                else
                    state <= SHIFT_RES_ONLY;

            end

            ASSIGN_A: begin
                state <= SHIFT_RES_ADD;
                // state <= ASSIGN_RES;

            end

            SHIFT_RES_ADD: begin
                state <= ASSIGN_RES;
            end

            ASSIGN_RES: begin
                state <= SHIFT_BIT;
            end

            SHIFT_RES_ONLY: begin
                state <= SHIFT_BIT;
            end

            END_STATE: begin
                state<= INIT_0;
            end

            default: state <= INIT_0;

        endcase

    end

end

always @(*) begin
    load       = 0;
    wr_a       = 0;
    shift_res  = 0;
    wr_res     = 0;
    shift_bit  = 0;
    wr_bit     = 0;
    wr_temp    = 0;
    sel_A      = 2'b00;
    sel_B      = 2'b00;
    sel_op     = 0;
    done       = 0;
    case (state)
        INIT: begin
            load = 1;
        end
        SHIFT_BIT: begin
            shift_bit = 1;
        end
        ASSIGN_TEMP: begin
            wr_temp = 1;
            sel_A = 2'b01;
            sel_B = 2'b01;
            sel_op = 0;
        end
        ASSIGN_A: begin
            wr_a = 1;
            sel_A = 2'b10;
            sel_B = 2'b10;
            sel_op = 1;
        end

        SHIFT_RES_ADD: begin
            shift_res = 1;
        end

        ASSIGN_RES: begin
            wr_res = 1;
            // sel_A = 2'b11;
            // sel_B = 2'b10;
            sel_A = 2'b01;
            sel_B = 2'b01;
            sel_op = 0;
        end

        SHIFT_RES_ONLY: begin
            shift_res = 1;
        end
        END_STATE: begin
            done = 1;
        end
        default: begin
            load      = 0;
            wr_a      = 0;
            shift_res = 0;
            wr_res    = 0;
            shift_bit = 0;
            wr_bit    = 0;
            wr_temp   = 0;
            sel_A     = 2'b00;
            sel_B     = 2'b00;
            sel_op    = 0;
            done      = 0;
        end
    endcase
end

`ifdef BENCH

reg [8*40:1] state_name;

always @(*) begin

    case(state)
        INIT_0         : state_name = "INIT_0";
        INIT           : state_name = "INIT";
        CHECK_BIT      : state_name = "CHECK_BIT";
        SHIFT_BIT      : state_name = "SHIFT_BIT";
        ASSIGN_TEMP    : state_name = "ASSIGN_TEMP";
        CHECK_A        : state_name = "CHECK_A";
        ASSIGN_A       : state_name = "ASSIGN_A";
        SHIFT_RES_ADD  : state_name = "SHIFT_RES_ADD";
        ASSIGN_RES     : state_name = "ASSIGN_RES";
        SHIFT_RES_ONLY : state_name = "SHIFT_RES_ONLY";
        END_STATE      : state_name = "END_STATE";

        default:
            state_name = "UNKNOWN";

    endcase

end

`endif

endmodule
