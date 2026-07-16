module shift_reg #(
    parameter value = 100,
    parameter BITS = 10
) (
    input clk,
    input load,
    input shift,

    output reg [BITS-1:0] val_out
);
    always @(negedge clk ) begin
        if (load) begin
            val_out <= value;
        end
        else begin
            if (shift) begin
                val_out <= val_out << 1;
            end
            else
                val_out <= val_out;
        end
    end
    
endmodule