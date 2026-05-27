module control(
    input wire clk,
    input wire rst,
    input wire lsb_B,
    input wire start,
    input wire z,

    output reg done,
    output reg shft,
    output reg reset_out,
    output reg add
);

// Codificación de Estados
parameter INIT  = 3'b000;
parameter CHECK = 3'b001;
parameter ADD   = 3'b010;
parameter SHIFT = 3'b011;
parameter END   = 3'b100;

reg [2:0] state;
reg [4:0] count; 

always @(posedge clk) begin
    if (rst) begin
        state <= INIT;
        count <= 0;
    end else begin
        case (state)
            INIT: begin
                count <= 0;
                if (start)
                    state <= CHECK;
                else
                    state <= INIT;
            end

            CHECK: begin
                if (lsb_B)
                    state <= ADD;
                else
                    state <= SHIFT;
            end

            ADD: begin
                state <= SHIFT;
            end

            SHIFT: begin
                if (z)
                    state <= END;
                else
                    state <= CHECK;
            end

            END: begin
                count <= count + 1'b1;
                if (count > 5'd28)
                    state <= INIT;
                else
                    state <= END;
            end

            default: begin
                state <= INIT;
            end
        endcase
    end
end

always @(*) begin

    done      = 0;
    reset_out = 0;
    shft      = 0;
    add       = 0;

    case (state)
        INIT: begin
            reset_out = 1;
        end 
        
        ADD: begin
            add = 1;
        end
        
        SHIFT: begin
            shft = 1;
        end
        
        END: begin
            done = 1;
        end

        default: begin
            done      = 0;
            reset_out = 0;
            shft      = 0;
            add       = 0;
        end
    endcase
end

`ifdef BENCH
reg [8*40:1] state_name;

always @(*) begin
    case (state)
        INIT  : state_name = "INIT";
        CHECK : state_name = "CHECK";
        ADD   : state_name = "ADD";
        SHIFT : state_name = "SHIFT";
        END   : state_name = "END";
        default: state_name = "UNKNOWN";
    endcase
end
`endif

endmodule