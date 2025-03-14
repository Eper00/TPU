module tb_PU;

// Paraméterek
parameter DATA_WIDTH = 16;

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
    a = 0;
    b = 0;

    // Reset szekvencia
    reset = 1;
    #10;
    reset = 0;
    #10;
    
    // Engedélyezés és bemenetek állítása
    en = 1;
    a = 1; // a = 1
    b = 2; // b = 2
    #10;
    
    a = 1; // a = 3
    b = 1; // b = 1
    #10;
    
    a = 0; // a = 2
    b = 1; // b = 1
    #10;
    
    // Teszt leállítása
    $finish;
end



endmodule
