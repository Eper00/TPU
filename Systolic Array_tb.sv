`timescale 1ns / 1ps
module tb_Systolic_Array;

    // Paraméterek
    parameter DATA_WIDTH = 8;
    parameter M = 2;
    parameter N = 3;
    parameter L= 6;
    // Jelek
    reg clk;
    reg reset;
    reg en;
    reg [0:DATA_WIDTH-1] a [0:M-1][0:L-1];
    reg [0:DATA_WIDTH-1] b [0:L-1][0:N-1];
    wire [0:DATA_WIDTH-1] P [0:M-1][0:N-1];

    // MatrixPU modul példányosítása
    Systolic_Array #(
        .DATA_WIDTH(DATA_WIDTH),
        .M(M),
        .N(N),
        .L(L)
    ) uut (
        .clk(clk),
        .reset(reset),
        .en(en),
        .a(a),
        .b(b),
        .P(P)
    );

    // Órajel generálás
    always begin
        #5 clk = ~clk;  // 10 időegység oszcilláció
    end

    // Inicializálás és tesztelés
    initial begin
        // Kezdeti értékek
        clk = 0;
        reset = 0;
        en = 0;

        a[0][0] = 8'd0; a[0][1] = 8'd0; a[0][2] = 8'd0; a[0][3] = 8'd1; a[0][4] = 8'd3;a[0][5] = 8'd2; 
        a[1][0] = 8'd0; a[1][1] = 8'd0; a[1][2] = 8'd1; a[1][3] = 8'd2; a[1][4] = 8'd3; a[1][5] = 8'd0;
        
       
        b[0][0] = 8'd0; b[0][1] = 8'd0; b[0][2] = 8'd0;
        b[1][0] = 8'd0; b[1][1] = 8'd0; b[1][2] = 8'd2; 
        b[2][0] = 8'd0; b[2][1] = 8'd3; b[2][2] = 8'd2; 
        b[3][0] = 8'd1; b[3][1] = 8'd2; b[3][2] = 8'd1;
        b[4][0] = 8'd2; b[4][1] = 8'd1; b[4][2] = 8'd0;
        b[5][0] = 8'd3; b[5][1] = 8'd0; b[5][2] = 8'd0;
       
         
        
        // Reset és engedélyezés
        reset = 1;
        #10 reset = 0;
        en = 1;

        // Véletlenszerű időzítések, hogy a kimenetek frissüljenek
        #10;
        
        // Ellenőrzés
        
        // Teszt befejezése
        #100;
        $finish;
    end

endmodule
