`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: Am/148
// Engineer: AminMaky
//////////////////////////////////////////////////////////////////////////////////
module InputRegester3D_up #(parameter Num = 3, parameter InModule = 8) (Reset ,Clock, Loud, LoudValue, RegOut, EndFlag);

    input  logic Reset;
    input  logic Clock;
    input  logic  Loud;
    input  logic [InModule - 1 : 0]  LoudValue [Num - 1 : 0] [Num - 1 : 0];
    
    output logic [InModule - 1 : 0] RegOut [Num - 1 : 0];
    output logic EndFlag;

    logic [InModule - 1 : 0] Cmem [((2 * Num) - 1) : 0] [Num - 1 : 0];
    logic [Num:0] Pointer;
    logic [Num:0] NewPointer;
    
    FullAdder #(.N(Num + 1)) PointerCounter (.a(Pointer),
                                             .b(5'b1), 
                                             .cin(0),
                                             .sum(NewPointer), 
                                             .cout());
   
    always_ff @(posedge Clock)
    begin
        if (Reset) 
        begin
            integer i, j;
            for (j = 0; j < Num; j++)
                begin
                    for (i = 0; i < (2 * Num); i++)
                    begin
                        Cmem[i][j] <= 0;
                    end
                    RegOut[j] <= 0;
                end
            EndFlag <= 0;
            Pointer <= 0;
        end
        else if (Loud == 1) 
        begin
            // initialization ...
            integer x, y;
                for (x = 0; x < Num; x++)
                begin
                    for (y = 0; y < Num; y++)
                    begin
                        Cmem[x + y][y] <= LoudValue[x][y];
                        // Zeros are set at Reset.
                    end
                end
            EndFlag <= 0;
            Pointer <= 0;

        end
        else if(Pointer == ((2 * Num) - 1))
        begin
            EndFlag <= 1;
        end
        else
        begin
            integer k;
            for (k = 0; k < Num; k++)
            begin
                RegOut [k] <= Cmem [Pointer][k];
            end
            Pointer <= NewPointer;
        end
    end
    
endmodule