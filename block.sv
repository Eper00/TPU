module PU #(
    parameter DATA_WIDTH = 16  // Paraméter, amely meghatározza a számok szélességét
)(
    input wire clk,                  // Órajel
    input wire reset,                // Reset jel
    input wire en,                   // Engedélyezés jel
    input wire [DATA_WIDTH-1:0] a,   // Első bemeneti szám
    input wire [DATA_WIDTH-1:0] b,   // Második bemeneti szám
    output reg [DATA_WIDTH-1:0] P    // Kimeneti összeg
);

    // Két bemenetet használunk a Floating_point_Unit modulban:
    // Az első bemenet a szorzás eredménye (a * b), a második a korábbi eredmény (P) a hozzáadás végrehajtásához.
    reg [DATA_WIDTH-1:0] result_temp;  // Ideiglenes tároló a szorzás eredményének
    reg [DATA_WIDTH-1:0] result_sum;   // Az összeg, amit a Floating_point_Unit végez el (P_temp + P)
    // Floating point unit példányosítása (a szorzás és az összegzés végrehajtása)
    Floating_point_Unit #(DATA_WIDTH) multiplier  (
        .clk(clk),
        .reset(reset),
        .en(en),
        .dec(1),
        .a(a),             // Szorzáshoz szükséges bemeneti adat
        .b(b),             // Szorzáshoz szükséges bemeneti adat
        .result(result_temp)  // Szorzás eredménye
    );

    // Az összeg végrehajtása (P_temp + P) egy második Floating_point_Unit példány segítségével
    Floating_point_Unit #(DATA_WIDTH) adder (
        .clk(clk),
        .reset(reset),
        .en(en),
        .dec(0),
        .a(result_temp),     // Az előző szorzás eredménye
        .b(P),                // A korábbi kimenet
        .result(result_sum)   // Az összeg (P_temp + P)
    );

    // Az always blokk végrehajtja a kimenet frissítését
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result_temp<=0;
            result_sum<=0;
            P <= 0;  // Reset esetén a kimenetet nullázzuk
        end else if (en) begin
            P <= result_sum;  // Frissítjük a kimenetet az összeg eredményével
        end else begin
            P<=P;
        end
    end

endmodule
