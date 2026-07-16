`timescale 1ns/1ps

module contador_TB;

reg clk;
reg reset;
reg dec;

wire [4:0] c;



// Instancia del DUT
contador uut (
    .clk(clk),
    .reset(reset),
    .dec(dec),
    .c(c)
);


// Generación de reloj
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end


// Estímulos
initial begin

    // Inicialización
    reset  = 0;
    dec = 0 ;
    
    // =========================
    // RESET
    // =========================
    #2;
    reset = 1;

    #10;
    reset = 0;


    // =========================
    // DEC 1
    // =========================
    #10;
    dec = 1;

    #10;
    dec = 0;


    // =========================
    // DEC 2
    // =========================
    #10;
    dec = 1;

    #10;
    dec = 0;



    // =========================
    // RESET
    // =========================
    #2;
    reset = 1;

    #10;
    reset = 0;

    // =========================
    // DECREMENTAR HASTA 0
    // =========================
    while (c==0) begin

    #10;
    dec = 1;

    #10;
    dec = 0;

    end

    // FIN
    #20;
    $finish;

end

initial begin
    $dumpfile("contador_TB.vcd");
    $dumpvars(0, contador_TB);
end
endmodule