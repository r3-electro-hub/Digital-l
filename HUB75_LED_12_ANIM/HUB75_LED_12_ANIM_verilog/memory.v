module memory #(
    parameter NUM_FRAMES = 15
)(
    input                   clk,
    input  [$clog2(NUM_FRAMES)-1:0] frame,
    input  [9:0]            address,
    input                   read,
    output reg [23:0]       data_out
);

    localparam MEM_SIZE = NUM_FRAMES * 1024;

    reg [23:0] MEM [0:MEM_SIZE-1];

    wire [$clog2(MEM_SIZE)-1:0] mem_address;

    assign mem_address = (frame << 10) + address;

    initial begin
        $readmemh("./image.hex", MEM);
    end

    always @(negedge clk) begin
        if(read)
            data_out <= MEM[mem_address];
    end

endmodule