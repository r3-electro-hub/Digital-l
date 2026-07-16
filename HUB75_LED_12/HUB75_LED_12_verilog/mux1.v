module mux1 (
    input [23:0]        A,
    input [1:0]         sel,
    output reg [5:0]    out_mux
);
    
    always @(*) begin
        case (sel)
            2'b00: out_mux = {A[20], A[16], A[12], A[8], A[4], A[0]}; 
            2'b01: out_mux = {A[21], A[17], A[13], A[9], A[5], A[1]}; 
            2'b10: out_mux = {A[22], A[18], A[14], A[10], A[6], A[2]}; 
            2'b11: out_mux = {A[23], A[19], A[15], A[11], A[7], A[3]}; 
            default: out_mux = {A[20], A[16], A[12], A[8], A[4], A[0]}; 
        endcase
    end
endmodule