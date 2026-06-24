`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: Am/148
// Engineer: AminMaky
//////////////////////////////////////////////////////////////////////////////////
module Datapath #(parameter Num = 3, parameter intop = 4, parameter inleft = 4) (Reset ,Clock, LoudIn, LoudUp, LoudLeft, RealTimeOut, ColWire, RowWire, Result, FinishLoudFlag, EndFlag);

    input  logic Reset;
    input  logic Clock;
    input  logic LoudIn;
    
    input  logic [intop  - 1 : 0]  LoudUp   [Num - 1 : 0] [Num - 1 : 0];
    input  logic [inleft - 1 : 0]  LoudLeft [Num - 1 : 0] [Num - 1 : 0];
    
    // logic [intop  - 1 : 0]  LoudUp   [Num - 1 : 0] [Num - 1 : 0]; // for Simulation
    // logic [inleft - 1 : 0]  LoudLeft [Num - 1 : 0] [Num - 1 : 0]; // for Simulation
    output logic [(intop + inleft + Num) : 0] RealTimeOut [Num - 1 : 0] [Num - 1 : 0]; // for Simulation
    output logic [(intop + inleft + Num) : 0] ColWire      [Num - 1 : 0] [Num - 1 : 0];
    output logic [inleft - 1 :0]              RowWire      [Num - 1 : 0] [Num - 1 : 0];
  
    output logic [(intop + inleft + Num) : 0] Result [Num - 1 : 0] [Num - 1 : 0];
    output logic FinishLoudFlag;
    output logic EndFlag;
    
    wire [inleft - 1 : 0] LeftWire [Num - 1 : 0];
    wire [intop - 1 : 0] UpWire    [Num - 1 : 0];
    wire [(intop + inleft + Num) : 0] OutWire [Num - 1 : 0];
    
    wire   UpEndFlag;
    wire LeftEndFlag;
    wire     OutFlag;
    // wire     ZeroSet;
    
    // Controling ...
    nand(FinishLoudFlag, UpEndFlag, LeftEndFlag);
    // and (ZeroSet, ~FinishLoudFlag, Reset);
    
    Systolic2D #(.intop(intop), .inleft(inleft), .Num(Num)) SystolicUnit (
                                                                            .Reset(Reset),
                                                                            .Clock(Clock),
                                                                            .LeftSide(LeftWire),           // [inleft - 1 :0] LeftSide [Num - 1 : 0]
                                                                            .TopSide(UpWire),              // [inleft - 1 :0]  TopSide [Num - 1 : 0]
                                                                            .InFlag(FinishLoudFlag),
                                                                            .RealTimeResult(RealTimeOut),  // [(intop + inleft + Num) : 0] RealTimeResult [Num - 1 : 0] [Num - 1 : 0]
                                                                                                           // for Simulation
                                                                            .ColWire(ColWire),
                                                                            .RowWire(RowWire),
                                                                            .OutFlag(OutFlag),
                                                                            .Result(OutWire));             // [(intop + inleft + Num) : 0] Result [Num - 1 : 0]
                                                                            
    InputRegester3D_up #(.Num(Num), .InModule(intop)) Up (
                                                 .Reset(Reset),
                                                 .Clock(Clock), 
                                                 .Loud(LoudIn), 
                                                 .LoudValue(LoudUp), 
                                                 .RegOut(UpWire),     // [InModule - 1 : 0] RegOut [Num - 1 : 0] 
                                                 .EndFlag(UpEndFlag));

    InputRegester3D_left #(.Num(Num), .InModule(inleft)) Left (
                                                 .Reset(Reset),
                                                 .Clock(Clock), 
                                                 .Loud(LoudIn), 
                                                 .LoudValue(LoudLeft), 
                                                 .RegOut(LeftWire),     // [InModule - 1 : 0] RegOut [Num - 1 : 0]
                                                 .EndFlag(LeftEndFlag));
                                                 
    OutputRegester #(.Num(Num), .InModule(intop + inleft + Num)) Down (
                                                 .Reset(Reset),
                                                 .Clock(Clock),
                                                 .ResevingFlag(OutFlag),
                                                 .ReseveData(OutWire), 
                                                 .LoudOutValue(Result),
                                                 .EndFlag(EndFlag));
                                                 
                                                 

/*
    initial // for Simulation
    begin
        LoudUp[0][0] = 1;   LoudUp[0][1] = 2;   LoudUp[0][2] = 3;
        LoudUp[1][0] = 4;   LoudUp[1][1] = 5;   LoudUp[1][2] = 6;
        LoudUp[2][0] = 7;   LoudUp[2][1] = 8;   LoudUp[2][2] = 9;
        
        LoudLeft[0][0] = 2; LoudLeft[0][1] = 0; LoudLeft[0][2] = 0;
        LoudLeft[1][0] = 0; LoudLeft[1][1] = 2; LoudLeft[1][2] = 0;
        LoudLeft[2][0] = 0; LoudLeft[2][1] = 0; LoudLeft[2][2] = 2;
    end
*/
endmodule