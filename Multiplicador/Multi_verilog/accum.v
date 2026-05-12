module accum (
    input clk,
    input [31:0] A,
    input add, //Señal de control add
    input reset, //Señal de control reset
    output reg [31:0] p //Registro P
);
always @(negedge clk)
    if (reset)
        p=32'h00000000;
    else
        begin
            if (add) p=p+A;
            else p=p;
        end
endmodule