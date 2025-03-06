module PU #(
    parameter DATA_WIDTH = 8  // Paraméter, amely meghatározza a számok szélességét
)(
    input wire clk,                  // Órajel
    input wire reset,                // Reset jel
    input wire en,
    input wire [DATA_WIDTH-1:0] a,   // Első bemeneti szám
    input wire [DATA_WIDTH-1:0] b,   // Második bemeneti szám
    output reg [DATA_WIDTH-1:0] P // Kimeneti összeg
);


// A kimeneti eredmény frissítése
always @(posedge clk or posedge reset) begin
    if (reset) begin
        P <= 0;  // Reset esetén nullázza az előző állapotot
       
    end else begin 
    if (en) begin
        P <= a * b + P;  
        
    end else begin
        P <= P;    
    end
    end
end


endmodule
