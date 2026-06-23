`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: Am/148
// Engineer: AminMaky
//////////////////////////////////////////////////////////////////////////////////
module Systolic2D #(parameter intop = 1, parameter inleft = 1, parameter Num = 3) (Reset, Clock, LeftSide, TopSide, InFlag,/* RealTimeResult*/, OutFlag, Result);

  input logic Reset;
  input logic Clock;
  input logic [inleft - 1 :0] LeftSide [Num - 1 : 0];
  input logic [inleft - 1 :0]  TopSide [Num - 1 : 0];
  input logic InFlag;

  // output logic [(intop + inleft + Num) : 0] RealTimeResult [Num - 1 : 0] [Num - 1 : 0]; // for Simulation
  output logic [(intop + inleft + Num) : 0] Result [Num - 1 : 0];
  output logic OutFlag;
    
  logic [intop  - 1 :0]              TopInputWire [Num - 1 : 0];
  logic [(intop + inleft + Num) : 0] ColWire      [Num - 1 : 0] [Num - 1 : 0];
  logic [inleft - 1 :0]              RowWire      [Num - 1 : 0] [Num - 1 : 0];
  logic FlagWire  [Num: 0] [Num - 1: 0];
  
  
  always_ff @(posedge Clock) 
  begin
    if(Reset)
    begin
      integer x;
      for (x = 0; x < Num; x++) 
      begin
        TopInputWire[x] <= 0;
        FlagWire [0][x] <= 0;
        RowWire  [x][0] <= 0;
        Result[x] <= 0;
      end
      OutFlag <= 0;
    end
    
    else
    begin
      integer f;
      for (f = 0; f < Num; f++) 
      begin
        FlagWire [0][f]  <=   InFlag ;
        TopInputWire[f]  <=  TopSide [f];
        RowWire  [f][0]  <= LeftSide [f];
        Result   [f]     <= ColWire [Num - 1][f];
      end
      OutFlag <= FlagWire [Num][Num - 1];
    end
    
  end
  
  //first row
  genvar k;
    generate
      for (k = 0; k < Num; k++) 
      begin
        FirstLinePE #(.intop(intop), .inleft(inleft),  .Num(Num)) FirstRowPE
            (.Reset(Reset),                   .Clock(Clock),
             .TopInput(TopInputWire[k]),        .LeftInput(RowWire[0][k]),
             .InFlag(FlagWire[0][k]),         .DownOutput(ColWire[0][k]), 
             .RightOutput(RowWire[0][k + 1]), .OutFlag(FlagWire[1][k])
         // ,.Result(RealTimeResult[0][k]) // for Simulation
              );
      end
    endgenerate
  
  //first column
  genvar m;
    generate
       for (m = 1; m < Num; m++) 
       begin
        PE #(.intop(intop), .inleft(inleft),  .Num(Num)) FirstColPE
            (.Reset(Reset),                   .Clock(Clock),
             .TopInput(ColWire[m - 1][0]),    .LeftInput(RowWire[m][0]),
             .InFlag(FlagWire[m][0]),         .DownOutput(ColWire[m][0]), 
             .RightOutput(RowWire[m][1]),     .OutFlag(FlagWire[m + 1][0])
         // ,.Result(RealTimeResult[m][0]) // for Simulation
             ); 
       end
    endgenerate

  //the rest of the array
  genvar i,j;
  generate
    
    for (i = 1; i < Num; i++) 
    begin
      for(j = 1; j < Num; j++) 
      begin  
        PE #(.intop(intop), .inleft(inleft),  .Num(Num)) BodysPE
            (.Reset(Reset),                   .Clock(Clock),
             .TopInput(ColWire[i - 1][j]),    .LeftInput(RowWire[i][j]),
             .InFlag(FlagWire[i][j]),         .DownOutput(ColWire[i][j]), 
             .RightOutput(RowWire[i][j + 1]), .OutFlag(FlagWire[i + 1][j]) 
         // ,.Result(RealTimeResult[i][j]) // for Simulation
             );
            end
    end
  endgenerate
endmodule
