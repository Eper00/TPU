module Systolic_Array #(
    parameter DATA_WIDTH = 8,  
    parameter M = 4,       
    parameter N = 4,       
    parameter L = 4         
)(
    input wire clk,                 
    input wire reset,                
    input wire en,                   
    input wire [DATA_WIDTH-1:0] a [0:M-1][0:L-1], 
    input wire [DATA_WIDTH-1:0] b [0:L-1][0:N-1], 
    output reg [DATA_WIDTH-1:0] P [0:M-1][0:N-1]  
);

// Regiszterek az adatok tárolására
reg [DATA_WIDTH-1:0] A_reg [0:M-1][0:N-1];
reg [DATA_WIDTH-1:0] B_reg [0:M-1][0:N-1];
reg [DATA_WIDTH-1:0] temp;
reg [3:0] f, l;  

// PU modulok deklarálása minden egyes elemhez
genvar i, j;
generate
    for (i = 0; i < M; i = i + 1) begin: row
        for (j = 0; j < N; j = j + 1) begin: col
            PU #(
                .DATA_WIDTH(DATA_WIDTH)
            ) pu_inst (
                .clk(clk),
                .reset(reset),
                .en(en),
                .a(A_reg[i][j]),  // A bemeneti adat
                .b(B_reg[i][j]),  // B bemeneti adat
                .P(P[i][j])       // Kimeneti adat
            );
        end
    end
endgenerate

// Fő működési logika
always @(posedge clk or posedge reset) begin
   
    if (reset) begin
        // Reseteljük az A_reg és B_reg mátrixokat
        for (integer x = 0; x < M; x = x + 1) begin
            for (integer y = 0; y < N; y = y + 1) begin
                A_reg[x][y] <= 0;
                B_reg[x][y] <= 0;
            end
        end
        l <= L-1;
        f <= L-1;
    end else if (en) begin
    $display("f= %d", f);
    
         for (integer k = 0; k < N; k = k + 1) begin
            B_reg[0][k] <= b[f][k];
            if (f > 0) begin
                f <= f - 1;
            end else begin
                f <= L-1;
            end
            for (integer m = M - 2; m >= 0; m = m - 1) begin
                B_reg[m + 1][k] <= B_reg[m][k];
                
            end
        end
        for (integer k = 0; k < M; k = k + 1) begin
            A_reg[k][0] <= a[k][l];
            if (l >0) begin
                l <= l - 1;
            end else begin
                l <= L-1;
            end
            for (integer m = N - 2; m >= 0; m = m - 1) begin
                A_reg[k][m + 1] <= A_reg[k][m];
                
            end
        end
    end
end

endmodule