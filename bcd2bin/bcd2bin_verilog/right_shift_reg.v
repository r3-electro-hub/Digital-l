module right_shift_reg (
    input           clk,
    input           load,
    input           shift,
    input [4:0]     wr_bcd,
    input [19:0]    in_bcd,
    input [19:0]    in_bin,
    output [19:0]   out_bcd,
    output [19:0]   out_bcd2
);
    reg [35:0] temp;
    assign out_bcd = temp[35:16];
    assign out_bcd2 = temp[15:0];

    always @(negedge clk ) begin
        if (load) begin
            temp[15:0] <= 16'h0000;
            temp[35:16] <= in_bcd;
        end
        else begin
            if (shift)
                temp <= temp>>1;
            else begin
                if (wr_bcd[4]==1)
                    temp[35:32] <= in_bin[19:16];
                if (wr_bcd[3]==1)
                    temp[31:28] <= in_bin[15:12];
                if (wr_bcd[2]==1)
                    temp[27:24] <= in_bin[11:8];
                if (wr_bcd[1]==1)
                    temp[23:20] <= in_bin[7:4];
                if (wr_bcd[0]==1)
                    temp[19:16] <= in_bin[3:0];
            end
        end
    end
    
endmodule