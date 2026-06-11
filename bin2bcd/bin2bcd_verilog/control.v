module control (
    input       clk,
    input       start,
    input       reset,
    input       z,
    output reg  load,
    output reg  shift,
    output reg  sel,
    output reg  out_en,
    output reg  ld_reg,
    output reg  done
);
    parameter INIT      = 3'b000;
    parameter SHIFT_A   = 3'b001;
    parameter CHECK_A      = 3'b010;
    parameter LOAD_A      = 3'b011;
    parameter SUM_A      = 3'b100;
    parameter END_STATE      = 3'b101;

    reg [2:0] state;
    reg [5:0] count;

    always @(posedge clk ) begin
        if (reset) begin
            state <= INIT;
            count <= 0;
        end
        else begin
            case (state)
                INIT: begin
                    count <= 0;
                    if (start)
                        state <= SHIFT_A;
                    else
                        state <= INIT;
                end 

                SHIFT_A: begin
                    if (z)
                        state <= END_STATE;
                    else
                        state <= CHECK_A; 
                end

                CHECK_A:
                    state <= LOAD_A;

                LOAD_A:
                    state <= SUM_A;

                SUM_A:
                    state <= SHIFT_A;
                
                END_STATE: begin
                    count <= count + 1;
                    if (count > 5'd28)
                        state <= INIT;
                    else
                        state <= END_STATE;
                end
                default: state <= INIT;
            endcase
        end
    end

    always @(*) begin
        load    = 0;
        shift   = 0;
        sel     = 0;
        out_en  = 0;
        ld_reg  = 0;
        done    = 0;

        case (state)
            INIT: 
                load = 1;
            
            SHIFT_A: begin
                shift = 1;
                sel = 1;
                ld_reg = 1;
            end
            
            CHECK_A: begin
                sel = 1;
                ld_reg = 1;
            end

            LOAD_A:
                out_en = 1;
            
            END_STATE:
                done = 1;

            default: begin
                load    = 0;
                shift   = 0;
                sel     = 0;
                out_en  = 0;
                ld_reg  = 0;
                done    = 0;
            end
        endcase
    end

        
    `ifdef BENCH
    reg [8*40:1] state_name;
    always @(*) begin
    case(state)
        INIT        : state_name = "INIT";
        SHIFT_A     : state_name = "SHIFT_A";
        CHECK_A     : state_name = "CHECK_A";
        LOAD_A      : state_name = "LOAD_A";
        SUM_A       : state_name = "SUM_A";
        END_STATE   : state_name = "END_STATE";
    endcase
    end
    `endif
endmodule