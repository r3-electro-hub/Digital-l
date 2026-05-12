module control(
    input clk,
    input rst,
    input lsb_B,
    input start,
    input z,

    output reg done,
    output reg shft,
    output reg reset_out,
    output reg add
);

parameter INIT  = 3'b000;
parameter CHECK = 3'b001;
parameter ADD   = 3'b010;
parameter SHIFT = 3'b011;
parameter END   = 3'b100;

reg [2:0] state;
reg [4:0] count;

always @(posedge clk)
begin

    if(rst)
    begin
        state <= INIT;
        count <= 0;
    end

    else
    begin

        case(state)

            INIT:
            begin
                done <= 0;
                reset_out <= 1;
                shft <= 0;
                add <= 0;
                count <= 0;

                if(start)
                    state <= CHECK;
                else
                    state <= INIT;
            end

            CHECK:
            begin
                done <= 0;
                reset_out <= 0;
                shft <= 0;
                add <= 0;

                if(lsb_B)
                    state <= ADD;
                else
                    state <= SHIFT;
            end

            ADD:
            begin
                done <= 0;
                reset_out <= 0;
                shft <= 0;
                add <= 1;

                state <= SHIFT;
            end

            SHIFT:
            begin
                done <= 0;
                reset_out <= 0;
                shft <= 1;
                add <= 0;

                if(z)
                    state <= END;
                else
                    state <= CHECK;
            end

            END:
            begin
                done <= 1;
                reset_out <= 0;
                shft <= 0;
                add <= 0;

                count <= count + 1;

                if(count > 28)
                    state <= INIT;
                else
                    state <= END;
            end

            default:
                state <= INIT;

          endcase

    end

end

`ifdef BENCH

reg [8*40:1] state_name;

always @(*)
begin
    case(state)

        INIT  : state_name = "INIT";
        CHECK : state_name = "CHECK";
        ADD   : state_name = "ADD";
        SHIFT : state_name = "SHIFT";
        END   : state_name = "END";

        default:
            state_name = "UNKNOWN";

    endcase
end

`endif

endmodule