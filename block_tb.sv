module tb_PU;

// Paraméterek
parameter DATA_WIDTH = 8;

// Bemenetek
reg clk;
reg reset;
reg en;
reg [DATA_WIDTH-1:0] a;
reg [DATA_WIDTH-1:0] b;

// Kimenetek
wire [DATA_WIDTH-1:0] P;

// Modul példányosítása
PU #(
    .DATA_WIDTH(DATA_WIDTH)
) uut (
    .clk(clk),
    .reset(reset),
    .en(en),
    .a(a),
    .b(b),
    .P(P)
);

// Órajel generátor
always begin
    #5 clk = ~clk;  // Órajel 10 ns periodussal
end

// Tesztelési szekvencia
initial begin
    // Kezdeti értékek
    clk = 0;
    reset = 0;
    en = 0;
    a = 8'b00000000;
    b = 8'b00000000;

    // Reset szekvencia
    reset = 1;
    #10;
    reset = 0;
    #10;
    
    // Engedélyezés és bemenetek állítása
    en = 1;
    a = 8'b00000001; // a = 1
    b = 8'b00000010; // b = 2
    #10;
    
    a = 8'b00000011; // a = 3
    b = 8'b00000001; // b = 1
    #10;
    
    a = 8'b00000010; // a = 2
    b = 8'b00000001; // b = 1
    #10;
    
    // Teszt leállítása
    $finish;
end

// Kimenetek figyelése
initial begin
    $monitor("Time = %0t, a = %b, b = %b, P = %b", $time, a, b, P);
end

endmodule
