`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Am/148
// Engineer: AminMaky
//////////////////////////////////////////////////////////////////////////////////
module TopTestModule;

    // Parameters
    parameter Num = 3;
    parameter intop  = 8;
    parameter inleft = 8;

    // Inputs
    logic Reset;
    logic Clock;
    logic LoudIn;
    logic [intop  - 1:0] LoudUp   [Num-1:0][Num-1:0];
    logic [inleft - 1:0] LoudLeft [Num-1:0][Num-1:0];

    // Output
    logic [(intop + inleft + Num) : 0] RealTimeResult [Num - 1 : 0] [Num - 1 : 0];  // for Debug
    logic [(intop + inleft + Num) : 0] ColWire      [Num - 1 : 0] [Num - 1 : 0];    // for Debug
    logic [inleft - 1 :0]              RowWire      [Num - 1 : 0] [Num - 1 : 0];    // for Debug
  
    logic [(intop + inleft + Num) : 0] Result [Num - 1 : 0] [Num - 1 : 0];
    logic FinishLoudFlag;
    logic EndFlag;
    
    // Instantiate the Unit Under Test (UUT)
    Datapath #(.Num(Num), .intop(intop), .inleft(inleft)) UUT (
        .Reset(Reset),
        .Clock(Clock),
        .LoudIn(LoudIn),
        .LoudUp(LoudUp),
        .LoudLeft(LoudLeft),
        .RealTimeOut(RealTimeResult),
        .RowWire(RowWire),
        .ColWire(ColWire),
        .Result(Result),
        .FinishLoudFlag(FinishLoudFlag),
        .EndFlag(EndFlag)
    );

    // Clock generation
    always #5 Clock = ~Clock;

    // Initialize inputs and apply stimulus
    initial begin
        // Initial values and apply reset
        Clock = 0;
        Reset = 1;
        LoudIn = 0;

        // Clear LoudUp and LoudLeft
        for (int i = 0; i < Num; i++) begin
            for (int j = 0; j < Num; j++) begin
                LoudUp  [i][j] = 0;
                LoudLeft[i][j] = 0;
            end
        end

        // Reseting is finished
        #10;
        Reset = 0;

        // Load new values (3 x 3)
        #10;
        LoudIn = 1;
        
        LoudUp[0][0] = 0;   LoudUp[0][1] = 0;   LoudUp[0][2] = 0;
        LoudUp[1][0] = 0;   LoudUp[1][1] = 0;   LoudUp[2][2] = 0;
        LoudUp[2][0] = 0;   LoudUp[2][1] = 0;   LoudUp[2][2] = 0;
        
        LoudLeft[0][0] = 0; LoudLeft[0][1] = 0; LoudLeft[0][2] = 0;
        LoudLeft[1][0] = 0; LoudLeft[1][1] = 0; LoudLeft[1][2] = 0;
        LoudLeft[2][0] = 0; LoudLeft[2][1] = 0; LoudLeft[2][2] = 0;
        
        #50;
        LoudIn = 0; // and Start calculations
        
        wait(FinishLoudFlag == 0);
        wait(EndFlag == 1);
        
        #10; // New Inputs ...
        LoudIn = 1;
        
        LoudUp[0][0] = 1;   LoudUp[0][1] = 2;   LoudUp[0][2] = 3;
        LoudUp[1][0] = 4;   LoudUp[1][1] = 5;   LoudUp[1][2] = 6;
        LoudUp[2][0] = 7;   LoudUp[2][1] = 8;   LoudUp[2][2] = 9;
        
        LoudLeft[0][0] = 2; LoudLeft[0][1] = 0; LoudLeft[0][2] = 0;
        LoudLeft[1][0] = 0; LoudLeft[1][1] = 2; LoudLeft[1][2] = 0;
        LoudLeft[2][0] = 0; LoudLeft[2][1] = 0; LoudLeft[2][2] = 2;
        
        #50;
        LoudIn = 0; // and Start calculations
        
        wait(FinishLoudFlag == 0);
        wait(EndFlag == 1);
        
        #100;
        
        $finish;
    end

endmodule
