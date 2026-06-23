`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Am/148
// Engineer: AminMaky
//////////////////////////////////////////////////////////////////////////////////
module    FirstLinePE    #(parameter intop = 8, parameter inleft = 8, parameter Num = 3) 
(Reset, Clock, TopInput, LeftInput, InFlag, DownOutput, RightOutput, OutFlag, Result);

  input  logic Reset;
  input  logic Clock;

  input  logic [intop  - 1 : 0]           TopInput;
  input  logic [inleft - 1 : 0]          LeftInput;
  input  logic                              InFlag;  // This flag comes with the new input data.

  output logic [(intop + inleft + Num) : 0] DownOutput;
  output logic [inleft - 1 : 0]            RightOutput;
  output logic                                 OutFlag; 

  output logic [(intop + inleft + Num) : 0]     Result; // it can be used for Simulation 
  
  always_ff @(posedge Clock) 
  begin
    if (Reset == 1)
    begin
      Result  <= 0;
      OutFlag <= 0;
      DownOutput   <= 0;
      RightOutput  <= 0;
    end
    else if (InFlag == 1)
    begin
      Result      <= Result + (TopInput * LeftInput);
      DownOutput  <=  TopInput;
      RightOutput <= LeftInput;
      OutFlag     <= 1;
    end
    else
    begin
      OutFlag <= 0;
      DownOutput <= Result;
    end
  end
endmodule
