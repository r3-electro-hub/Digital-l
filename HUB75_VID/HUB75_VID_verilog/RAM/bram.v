module bram (
    input               clk,
    input               wr,
    input [9:0]         hub75_addr,
    input [23:0]        data_in,
    input [9:0]         spi_addr,
    output reg [23:0]   data_out
);
    reg [23:0] MEM [0:1023];
    always @(negedge clk ) begin
        if (wr) begin
            MEM[spi_addr] <= data_in;
        end
        data_out <= MEM[hub75_addr];
    end
    
endmodule