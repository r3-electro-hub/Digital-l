module mux2 (
    input   [3:0] in1,
    input   [3:0] in2,
    input   sel,
    output reg [3:0] mux_out
);

always @(*) begin
    if (sel) begin
        mux_out = in2; 
    end
    else
        mux_out = in1;
end
    
endmodule

