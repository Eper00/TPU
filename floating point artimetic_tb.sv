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
        dec = 0;  // ÖSSZEADÁST tesztelünk!
        a = 16'b0;
        b = 16'b0;
        #10 reset = 0;

        // **Teszt 1: 2.0 + 3.0 = 5.0**
        en = 1;
        a = 16'h4400; // 2.0 (FP16)
        b = 16'hC000; // 3.0 (FP16)
        #10;

        // **Teszt 2: -2.5 + 4.0 = 1.5**
        a = 16'b1100000100000000; // -2.5 (FP16)
        b = 16'b0100100000000000; // 4.0 (FP16)
        #10;

        // **Teszt 3: 1.5 + (-1.5) = 0.0**
        a = 16'b0011111000000000; // 1.5 (FP16)
        b = 16'b1011111000000000; // -1.5 (FP16)
        #10;

        // **Teszt 4: 0.5 + 0.5 = 1.0**
        a = 16'b0011100000000000; // 0.5 (FP16)
        b = 16'b0011100000000000; // 0.5 (FP16)
        #10;

        // **Teszt 5: -1.0 + -1.0 = -2.0**
        a = 16'b1011110000000000; // -1.0 (FP16)
        b = 16'b1011110000000000; // -1.0 (FP16)
        #10;

        // **Teszt 6: 0 + 3.0 = 3.0**
        a = 16'b0000000000000000; // 0.0 (FP16)
        b = 16'b0100010000000000; // 3.0 (FP16)
        #10;

        // **Teszt 7: INF + 1.0 = INF**
        a = 16'b0111110000000000; // +INF (FP16)
        b = 16'b0011110000000000; // 1.0 (FP16)
        #10;

        // **Teszt 8: INF + (-INF) = NaN**
        a = 16'b0111110000000000; // +INF (FP16)
        b = 16'b1111110000000000; // -INF (FP16)
        #10;

        // Teszt végén leállítjuk a szimulációt
        $stop;
    end

endmodule
