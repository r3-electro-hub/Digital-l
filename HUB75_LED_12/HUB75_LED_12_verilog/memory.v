module memory (
    input               clk,
    input [9:0]         address,
    input               read,
    output reg [23:0]    data_out
);
    reg [23:0] MEM [1023:0];
    initial begin
        $readmemh("./image.hex", MEM);
    end

    always @(negedge clk ) begin
        if (read) begin
            data_out <= MEM[address];
        end
    end

endmodule