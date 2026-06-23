`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: Am/148
// Engineer: AminMaky
//////////////////////////////////////////////////////////////////////////////////
module InputRegester3D_left #(parameter Num = 3, parameter InModule = 8) (Reset ,Clock, Loud, LoudValue, RegOut, EndFlag);

    input  logic Reset;
    input  logic Clock;
    input  logic  Loud;
    input  logic [InModule - 1 : 0]  LoudValue [Num - 1 : 0] [Num - 1 : 0];
    
    output logic [InModule - 1 : 0] RegOut [Num - 1 : 0];
    output logic EndFlag;

    logic [InModule - 1 : 0] Cmem [Num - 1 : 0][((2 * Num) - 1) : 0];
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
            for (i = 0; i < Num; i++)
                begin
                    for (j = 0; j < (2 * Num); j++)
                    begin
                        Cmem[i][j] <= 0;
                    end
                    RegOut[i] <= 0;
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
                        Cmem[x][x + y] <= LoudValue[x][y];
                        // Zeros are set at Reset.
                    end
                end
            EndFlag <= 0;
            Pointer <= 0;

        end
        else if(Pointer == (2 * Num) - 1)
        begin
            EndFlag <= 1;
        end
        else
        begin
            integer k;
            for (k = 0; k < Num; k++)
            begin
                RegOut [k] <= Cmem [k][Pointer];
            end
            Pointer <= NewPointer;
        end
    end
    
endmodule
