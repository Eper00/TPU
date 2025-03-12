`timescale 1ns / 1ps

module tb_Floating_point_Unit;

    // Paraméterek
    parameter DATA_WIDTH = 16;
    
    // Tesztjelzők
    reg clk;
    reg reset;
    reg en;
    reg dec;
    reg [DATA_WIDTH-1:0] a, b;
    wire [DATA_WIDTH-1:0] result;

    // DUT példányosítás (Device Under Test)
    Floating_point_Unit #(DATA_WIDTH) dut (
        .clk(clk),
        .reset(reset),
        .en(en),
        .dec(dec),
        .a(a),
        .b(b),
        .result(result)
    );

    // Órajel generálás (50 MHz)
    always #5 clk = ~clk;

    // Teszt szekvencia
   initial begin
        // Kezdeti értékek
        clk = 0;
        reset = 1;
        en = 0;
         dec = 1;  // SZORZÁST tesztelünk!
        a = 16'b0;
        b = 16'b0;
        #10 reset = 0;

        // **Teszt 1: 2.0 * 3.0 = 6.0**
        en = 1;
        a = 16'h1C80; // 2.0
        b = 16'h25F0; // 3.0
        #10;
        $display("Test 1: 2.0 * 3.0 = %0h (Expected: 6.0)", result);

        // Teszt 2: Negatív és pozitív szám szorzása (-2.0 * 3.0 = -6.0)
        a = 16'hC000; // -2.0
        b = 16'h4040; // 3.0
        #10;
        $display("Test 2: -2.0 * 3.0 = %0h (Expected: -6.0)", result);

        // Teszt 3: Nulla szorzás
        a = 16'h0000; // 0.0
        b = 16'h4040; // 3.0
        #10;
        $display("Test 3: 0.0 * 3.0 = %0h (Expected: 0.0)", result);

        // Teszt 4: Nagy számok szorzása (Max lebegőpontos számok)
        a = 16'h7C00; // Max lebegőpontos szám (inf)
        b = 16'h7C00; // Max lebegőpontos szám (inf)
        #10;
        $display("Test 4: inf * inf = %0h (Expected: inf)", result);

        // Teszt 5: Kis számok szorzása (Underflow teszt)
        a = 16'h3800; // 0.0009765625
        b = 16'h3800; // 0.0009765625
        #10;
        $display("Test 5: Underflow Test: 0.0009765625 * 0.0009765625 = %0h (Expected: 9.5367431640625e-7)", result);

        // Teszt 6: Különböző előjeles számok szorzása (-1.0 * 0.5 = -0.5)
        a = 16'hB000; // -1.0
        b = 16'h3E00; // 0.5
        #10;
        $display("Test 6: -1.0 * 0.5 = %0h (Expected: -0.5)", result);

        // Teszt 7: Pozitív számok szorzása: 1.5 * 2.0 = 3.0
        a = 16'h3E00; // 0.5
        b = 16'h4000; // 2.0
        #10;
        $display("Test 7: 1.5 * 2.0 = %0h (Expected: 3.0)", result);

        // Teszt 8: Nulla és nem nulla szám szorzása
        a = 16'h0000; // 0.0
        b = 16'h3E00; // 0.5
        #10;
        $display("Test 8: 0.0 * 0.5 = %0h (Expected: 0.0)", result);

        // Teszt 9: Nagy szám szorzása kis számokkal (Overflow teszt)
        a = 16'h7C00; // Max lebegőpontos szám (inf)
        b = 16'h3800; // Kis szám
        #10;
        $display("Test 9: inf * small = %0h (Expected: inf)", result);
        
        $stop;
    end

endmodule
