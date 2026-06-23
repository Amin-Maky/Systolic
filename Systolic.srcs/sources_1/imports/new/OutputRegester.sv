`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Am/148
// Engineer: AminMaky
//////////////////////////////////////////////////////////////////////////////////
module OutputRegester #(parameter Num = 3, parameter InModule = 8) (Reset ,Clock, ResevingFlag, ReseveData, LoudOutValue, EndFlag);
    
    input logic Reset;
    input logic Clock;
    input logic ResevingFlag;
    input  logic [InModule : 0] ReseveData [Num - 1 : 0];
    
    output logic [InModule : 0]  LoudOutValue [Num - 1 : 0] [Num - 1 : 0];
    output logic EndFlag;
    
    logic OneDelayFlag;
    
    always_ff @(posedge Clock)
    begin
        integer i, j;
        if (Reset) 
        begin
            EndFlag <= 0;
            OneDelayFlag <= 0;
            for (j = 0; j < Num; j++)
            begin
                for (i = 0; i < Num; i++)
                begin
                    LoudOutValue[i][j] <= 0;
                end
            end
        end
        else if(EndFlag)
        begin
            if(ResevingFlag)
            begin
                EndFlag <= 0;
                OneDelayFlag <= 0;
            end
        end
        else if(ResevingFlag)
        begin
            for (i = 0; i < Num; i++)
            begin
                for (j = 1; j < Num; j++)
                begin
                    LoudOutValue [0][i] <= ReseveData [i];
                    LoudOutValue [j][i] <= LoudOutValue [j - 1][i];
                end
            end
        end
        else
        begin
            if (OneDelayFlag)
            begin
                EndFlag <= 1;
            end
            else
            begin
                OneDelayFlag <= 1;
                for (i = 0; i < Num; i++)
                begin
                    for (j = 1; j < Num; j++)
                    begin
                        LoudOutValue [0][i] <= ReseveData [i];
                        LoudOutValue [j][i] <= LoudOutValue [j - 1][i];
                    end
                end
            end
        end
    end
    
endmodule