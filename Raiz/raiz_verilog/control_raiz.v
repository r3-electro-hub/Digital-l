module control_raiz (

    input clk,
    input start,
    input rst,

    input z,
    input a_ge_res_bit,

    output reg load,
    output reg wr_a,
    output reg shift_res,
    output reg wr_res,
    output reg shift_bit,

    output reg done

);

parameter INIT_0         = 4'b0000;
parameter INIT           = 4'b0001;
parameter CHECK_BIT      = 4'b0010;
parameter CHECK_A        = 4'b0011;
parameter ASSIGN_A       = 4'b0100;
parameter ASSIGN_RES     = 4'b0101;
parameter SHIFT_RES      = 4'b1000;
parameter SHIFT_BIT      = 4'b1001;
parameter END_STATE      = 4'b1010;

reg [4:0] count;
reg [3:0] state;
always @(posedge clk) begin

    if(rst) begin
        state <= INIT_0;
        count <= 0;
    end

    else begin

        case(state)

            INIT_0: begin
                count <= 0;
                if(start)
                    state <= INIT;
                else
                    state <= INIT_0;
            end

            INIT: begin
                state <= CHECK_BIT;
            end

            CHECK_BIT: begin
                if(!z)
                    state <= CHECK_A;

                else
                    state <= END_STATE;
            end

            CHECK_A: begin
                if(a_ge_res_bit)
                    state <= ASSIGN_A;
                else
                    state <= SHIFT_RES;
            end

            ASSIGN_A: begin
                state <= ASSIGN_RES;
            end

            ASSIGN_RES: begin
                state <= SHIFT_BIT;
            end

            SHIFT_RES: begin
                state <= SHIFT_BIT;
            end

            SHIFT_BIT: begin
                state <= CHECK_BIT;
            end

            END_STATE: begin
                count <= count + 1'b1;
                if (count > 5'd28)
                    state <= INIT_0;
                else
                    state <= END_STATE;
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
    done       = 0;
    case (state)
        INIT: begin
            load = 1;
        end
        ASSIGN_A: begin
            wr_a = 1;
        end
        ASSIGN_RES: begin
            wr_res = 1;
        end
        SHIFT_RES: begin
            shift_res = 1;
        end
        SHIFT_BIT: begin
            shift_bit = 1;
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
        CHECK_A        : state_name = "CHECK_A";
        ASSIGN_A       : state_name = "ASSIGN_A";
        ASSIGN_RES     : state_name = "ASSIGN_RES";
        SHIFT_RES      : state_name = "SHIFT_RES";
        SHIFT_BIT      : state_name = "SHIFT_BIT";
        END_STATE      : state_name = "END_STATE";

        default:
            state_name = "UNKNOWN";

    endcase

end

`endif

endmodule
