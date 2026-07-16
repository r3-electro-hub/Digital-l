module lsr #(
    parameter BITS = 8
) (
    input                   clk,
    input                   ld,
    input                   sh,
    input [BITS-1:0]        value, 
    output reg [BITS-1:0]   value_out
);

    always @(negedge clk) begin
        if (ld) begin
            value_out <= value;
        end 
        else if (sh) begin
            value_out <= {value_out[BITS-2:0], 1'b0};
        end
    end
    
endmodule