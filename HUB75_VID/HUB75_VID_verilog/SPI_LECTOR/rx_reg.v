module rx_reg (
    input           clk,
    input           ld,
    input           sh,
    input           spi_miso,
    output [23:0]   out_rx
);
    reg [23:0] data;

    assign out_rx = data;

    always @(negedge clk ) begin
        if (ld) begin
            data <= 0;        
        end
        else if (sh) begin
            data <= {data[22:0],spi_miso};
        end
    end
endmodule