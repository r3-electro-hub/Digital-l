module count #(
    parameter BITS = 6
) (
    input clk,
    input rst,
    input inc,

    output reg [BITS-1:0] count_out,
    output z
);

    always @(negedge clk)
    begin
        if(rst)
            count_out<=0;
        else if(inc)
            count_out<=count_out+1;
        end

assign z = (count_out==0);

endmodule