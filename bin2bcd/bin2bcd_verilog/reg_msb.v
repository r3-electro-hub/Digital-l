module reg_msb (
    input               clk,
    input               reset,
    input               ld_reg,
    input               out_en,
    input [4:0]         in,
    output reg [4:0]    wr_bcd
);
reg [4:0] temp;

always @(*) begin
    if (out_en) begin
        wr_bcd = ~temp; //Manda el inverso bit a bit, puesto que no estamos viendo el carry del complemento a 2 del modulo sum
    end
    else
        wr_bcd = 0;
end

always @(negedge clk ) begin
    if (reset) begin
        temp <= 0;
    end
    else begin 
        if (ld_reg)
            temp <= in;
    end 
end
endmodule
